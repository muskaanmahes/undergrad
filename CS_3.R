setwd("/Users/muskaanmahes/Downloads/COVID-19")
cases_TX <- read.csv("COVID-19_cases_TX.csv")
mobility <- read.csv("Global_Mobility_Report.csv")
cases <- read.csv("COVID-19_cases_plus_census.csv")

library("tidyverse")
library(ggplot2)
# install.packages("RWeka")
library(RWeka)
library(caret)
library(dplyr)
library(MLmetrics)
library(maps)
library(stringr)
library(seriation)
library(tidycensus)
library(tigris)
library(sf)

###########Data prepartion#########
cases <- cases %>% mutate_if(is.character, factor)
dim(cases)

cases <- cases %>% filter(confirmed_cases > 0) 

cases <- cases %>% 
  arrange(desc(confirmed_cases)) #%>%    
#select(county_name, state, confirmed_cases, deaths, total_pop, median_income, median_age)
cases <- cases %>% mutate(
  cases_per_10k = confirmed_cases/total_pop*10000, 
  deaths_per_10k = deaths/total_pop*10000, 
  death_per_case = deaths/confirmed_cases)
write.csv(cases, file = "new_cases.csv", row.names = FALSE)
str(cases)


#engineered features
cases_sel <- cases %>%
  mutate(
    housing_density_proxy = housing_units / total_pop,
    senior_count = (male_65_to_66 + male_67_to_69 + male_70_to_74 + male_75_to_79 + 
                      male_80_to_84 + male_85_and_over +
                      female_65_to_66 + female_67_to_69 + female_70_to_74 + female_75_to_79 + 
                      female_80_to_84 + female_85_and_over) / total_pop,
    gender_ratio = male_pop / female_pop
  ) %>%
  #predictive features
  select(
    county_name, state, total_pop, white_pop, black_pop, asian_pop, hispanic_pop, amerindian_pop,
    median_age, median_income, median_rent, income_per_capita,
    households, nonfamily_households, family_households,
    commuters_by_public_transportation, aggregate_travel_time_to_work,
    cases_per_10k, deaths_per_10k, death_per_case,
    housing_density_proxy, senior_count, gender_ratio 
  )


####normalize by population###################
cases_sel <- cases_sel %>% mutate(
  white_pop = white_pop/total_pop,
  black_pop = black_pop/ total_pop, 
  asian_pop = asian_pop/total_pop, 
  hispanic_pop = hispanic_pop/total_pop, 
  amerindian_pop = amerindian_pop/total_pop,
  households = households/total_pop,
  nonfamily_households = nonfamily_households/total_pop,
  family_households = family_households/total_pop,
  commuters_by_public_transportation = commuters_by_public_transportation/ total_pop
)
summary(cases_sel)

#checking for missing values
table(complete.cases(cases_sel))

#removing 140 incomplete rows
cases_sel <- cases_sel %>% 
  filter(complete.cases(.))

#checking that class variable is a factor
str(cases_sel)


#check for correlation for numeric variables

cm <- cor(cases_sel %>% select(
  total_pop, white_pop, black_pop, asian_pop, hispanic_pop, amerindian_pop,
  median_age, median_income, median_rent, income_per_capita,
  households, nonfamily_households, family_households,
  commuters_by_public_transportation, aggregate_travel_time_to_work,
  cases_per_10k, deaths_per_10k, death_per_case,
  housing_density_proxy, senior_count, gender_ratio
), use = "complete.obs")

# 2. Plot heatmap
hmap(cm, margins = c(14, 14))


############Class definition##########################


# getting the threshold
#option 1 to find the threshold visually 

ggplot(cases_sel, aes(x = deaths_per_10k)) +
  geom_histogram(bins = 30, fill = "#1f77b4", color = "white") +
  labs(
    title = "Distribution of Deaths per 10,000 People",
    x = "Deaths per 10,000",
    y = "Number of Counties"
  )


#option 2 using quantiles
quantiles <- quantile(cases_sel$deaths_per_10k, probs = c(0.33, 0.66), na.rm = TRUE)
print(quantiles)

cases_sel <- cases_sel %>%
  mutate(
    risk_class = case_when(
      deaths_per_10k <= 8.60879  ~ "Low",
      deaths_per_10k <= 15.07347  ~ "Medium",
      TRUE ~ "High"
    ), 
    risk_class = factor(risk_class, levels = c("Low", "Medium", "High"))
  )


#check class variable if its imbalanced
table(cases_sel$risk_class)
prop.table(table(cases_sel$risk_class))



#checking the cases in other states
CA_cases = cases  %>% 
filter(state == "CA")  
CA_sum = sum(CA_cases[,6])
CA_sum

FL_cases = cases %>% 
  filter(state== "FL")
FL_sum = sum(FL_cases[,6])
FL_sum


threeState_cases = cases %>% 
  filter(state == "TX")
TX_sum = sum(threeState_cases[,6])
TX_sum
head(threeState_cases)


  
#hypothesis for states risk levels
threeState_cases = cases_sel %>% 
  filter(state %in% c("TX", "CA", "FL")) %>% 
  group_by(state)  




#getting the proportions for all Texas risk levels
threeState_cases %>%
  count(risk_class) %>%
  mutate(pct = n / sum(n))


#########Modeling#################
# #Logistic Regression Model(model 1)
 
# #spliting data into train/test
 set.seed(123)
train_index <- createDataPartition(threeState_cases$risk_class, p = 0.8, list = FALSE)

train_data <- threeState_cases[train_index, ]
test_data  <- threeState_cases[-train_index, ]

# Remove ID vars (caret can't handle characters/factors as predictors)
train_data_caret <- train_data %>% select(-county_name, -state)
test_data_caret  <- test_data %>% select(-county_name, -state)


# #Cross validation
ctrl <- trainControl(
  method = "cv",
  number = 5,
  classProbs = TRUE,
  summaryFunction = multiClassSummary,
  savePredictions = "final"
)

# # Define tuning grid for glmnet (penalty = lambda, mixture = alpha)
tune_grid <- expand.grid(
  alpha = seq(0, 1, length.out = 5), #mixture
  lambda = 10^seq(-3, 0, length.out = 5) #penalty 
)


# # Train the model
set.seed(123)
logReg_caret <- train(
  risk_class ~ .,
  data = train_data_caret,
  method = "glmnet",
  preProcess = c("center", "scale"),
  trControl = ctrl,
  tuneGrid = tune_grid
)


#view best model and tuning results
logReg_caret

#best parameters
logReg_caret$bestTune

# Predict labels
test_preds <- predict(logReg_caret, newdata = test_data_caret)

# Evaluate
confusionMatrix(test_preds, test_data_caret$risk_class)



#Map
# Get FIPS crosswalk
data("fips_codes")

# Clean and join FIPS to your data
cases_sel_clean <- cases_sel %>%
  mutate(
    state_join = state,
    county_join = county_name
  ) %>%
  left_join(
    fips_codes %>%
      transmute(
        state = state,
        county = county,
        GEOID = paste0(state_code, county_code)
      ),
    by = c("state_join" = "state", "county_join" = "county")
  )



# Get county shapefile with FIPS
counties_sf <- counties(cb = TRUE, resolution = "20m", year = 2020) %>%
  st_as_sf() %>%
  filter(!STATE_NAME %in% c("Alaska", "Hawaii", "Puerto Rico"))

# Perform the join by FIPS (GEOID)
county_risk_map <- counties_sf %>%
  left_join(cases_sel_clean, by = "GEOID")


ggplot(county_risk_map) +
  geom_sf(aes(fill = risk_class), color = NA) +
  scale_fill_manual(
    values = c("Low" = "#2ca25f", "Medium" = "#fec44f", "High" = "#de2d26"),
    na.value = "gray90"
  ) +
  labs(
    title = "COVID-19 Death Risk Classification by County",
    fill = "Risk Level"
  ) +
  theme_minimal() +
  theme(
    legend.position = "bottom",
    plot.title = element_text(hjust = 0.5)
  )




#Rule-based classifier: PART(model 2)

#training/test-PART
train_data_part <- threeState_cases[train_index, ]
test_data_part  <- threeState_cases[-train_index, ]


# 3. Remove ID vars from training data
train_data_part_caret <- train_data_part %>% select(-county_name, -state)
test_data_part_caret  <- test_data_part  %>% select(-county_name, -state)



#Train PART
# Define cross-validation
 # 5-fold CV
ctrl <- trainControl(
  method = "cv",
  number = 5,
  classProbs = TRUE,
  summaryFunction = multiClassSummary
)

# Defining PART model
set.seed(123)

part_model <- train(
  risk_class ~ .,
  data = train_data_part_caret,
  method = "PART",
  trControl = ctrl,
  tuneLength = 5  
)
part_model

#final model based on training
print(part_model$finalModel)

#predict on the testing data
test_preds_part <- predict(part_model, newdata = test_data_part_caret)


# Confusion matrix
confusionMatrix(test_preds_part, test_data_part_caret$risk_class)



#Map
data("fips_codes")

test_data_part <- test_data_part %>%
  ungroup() %>%
  mutate(predicted_risk_class = test_preds_part)


# Prepare test data for join
test_data_part_geo <- test_data_part %>%
  mutate(
    state_join = state,
    county_join = county_name
  ) %>%
  left_join(
    fips_codes %>%
      transmute(
        state = state,
        county = county,
        GEOID = paste0(state_code, county_code)
      ),
    by = c("state_join" = "state", "county_join" = "county")
  )

counties_sf <- counties(cb = TRUE, resolution = "20m", year = 2020) %>%
  st_as_sf() %>%
  filter(!STATE_NAME %in% c("Alaska", "Hawaii", "Puerto Rico"))

# Join predictions by GEOID
part_map <- counties_sf %>%
  left_join(test_data_part_geo, by = "GEOID")

# Plot the map
ggplot(part_map) +
  geom_sf(aes(fill = predicted_risk_class), color = NA) +
  scale_fill_manual(
    values = c("Low" = "#2ca25f", "Medium" = "#fec44f", "High" = "#de2d26"),
    na.value = "gray90"
  ) +
  labs(
    title = "PART Model: Predicted COVID-19 Risk Class by County",
    fill = "Predicted Risk"
  ) +
  theme_minimal() +
  theme(
    legend.position = "bottom",
    plot.title = element_text(hjust = 0.5)
  )



#Nearest Neighbor Classifier (model 3)

#spilt train/test data
set.seed(123)
train_index_knn <- createDataPartition(threeState_cases$risk_class, p = 0.8, list = FALSE)

train_data_knn <- threeState_cases[train_index_knn, ]
test_data_knn  <- threeState_cases[-train_index_knn, ]

# 3. Remove non-predictive ID columns
train_data_knn_caret <- train_data_knn %>% select(-county_name, -state)
test_data_knn_caret  <- test_data_knn  %>% select(-county_name, -state)

#CV
ctrl_knn <- trainControl(
  method = "cv",
  number = 5,
  classProbs = TRUE,
  summaryFunction = multiClassSummary
)

#tuning grid
k_grid <- expand.grid(k = 1:20)


#train the model using caret
set.seed(123)

knn_model <- train(
  risk_class ~ .,
  data = train_data_knn_caret,
  method = "knn",
  tuneGrid = k_grid,
  trControl = ctrl_knn,
  preProcess = c("center", "scale")
)
knn_model

knn_model$bestTune  # shows best k value

#Predict on the test data
test_preds_knn <- predict(knn_model, newdata = test_data_knn_caret)

#Evaluate model performance
confusionMatrix(test_preds_knn, test_data_knn_caret$risk_class)


#MAP
# Ungroup in case grouping is still applied
test_data_knn <- test_data_knn %>%
  ungroup() %>%
  mutate(predicted_risk_class = test_preds_knn)

data("fips_codes")

# Join GEOID using county and state names
test_data_knn_geo <- test_data_knn %>%
  mutate(
    state_join = state,
    county_join = county_name
  ) %>%
  left_join(
    fips_codes %>%
      transmute(
        state = state,
        county = county,
        GEOID = paste0(state_code, county_code)
      ),
    by = c("state_join" = "state", "county_join" = "county")
  )

# Load contiguous U.S. counties
counties_sf <- counties(cb = TRUE, resolution = "20m", year = 2020) %>%
  st_as_sf() %>%
  filter(!STATE_NAME %in% c("Alaska", "Hawaii", "Puerto Rico"))

# Join predictions by GEOID
knn_map <- counties_sf %>%
  left_join(test_data_knn_geo, by = "GEOID")


ggplot(knn_map) +
  geom_sf(aes(fill = predicted_risk_class), color = NA) +
  scale_fill_manual(
    values = c("Low" = "#2ca25f", "Medium" = "#fec44f", "High" = "#de2d26"),
    na.value = "gray90"
  ) +
  labs(
    title = "KNN Model: Predicted COVID-19 Risk Class by County",
    fill = "Predicted Risk"
  ) +
  theme_minimal() +
  theme(
    legend.position = "bottom",
    plot.title = element_text(hjust = 0.5)
  )

#####Variable importance

# VIP penalized logistic regression
log_importance <- varImp(logReg_caret, scale = TRUE)
log_importance

# Optional: Plot
plot(log_importance, top = 20, main = "Logistic Regression - Variable Importance")



#VIP part model
part_importance <- varImp(part_model, scale = TRUE)
part_importance
plot(part_importance, top = 20, main = "PART - Variable Importance")

 
 
 
# VIP KNN model
# This will give you importance per class
knn_importance <- filterVarImp(
  x = train_data_caret %>% select(-risk_class),
  y = train_data_caret$risk_class
)
knn_importance




knn_importance$MeanImportance <- rowMeans(knn_importance)

# Plot top 20
library(ggplot2)
knn_importance %>%
  arrange(desc(MeanImportance)) %>%
  slice_head(n = 20) %>%
  mutate(varname = fct_reorder(rownames(.), MeanImportance)) %>%
  ggplot(aes(x = varname, y = MeanImportance)) +
  geom_col(fill = "#2E86AB") +
  coord_flip() +
  labs(
    title = "KNN Variable Importance (mean across classes)",
    x = "Variable",
    y = "Importance"
  ) +
  theme_minimal()


# VIP KNN model
knn_importance <- varImp(knn_model, scale = TRUE)
knn_importance

# Optional: Plot
plot(knn_importance, top = 20, main = "KNN - Variable Importance")





