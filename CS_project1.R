
library("tidyverse")
library("ggplot2")
library("ggrepel")
library("ggcorrplot")
library("DT")
library(dplyr)
library(scales)


# Read the data
cases <- read_csv("/Users/muskaanmahes/Downloads/COVID-19/COVID-19_cases_plus_census.csv")
cases
#str(cases)

# Make character factors for analysis
cases <- cases %>% mutate_if(is.character, factor)
dim(cases)
str(cases)
summary(cases)

# Finding the scale of measurement
is.factor(cases$state)
is.ordered(cases$state)  #Nominal

is.factor(cases$county_name)
is.ordered(cases$county_name)  #Nominal

is.factor(cases$confirmed_cases)
is.ordered(cases$confirmed_cases) #Nominal

is.factor(cases$deaths)
is.ordered(cases$deaths) #Nominal

is.factor(cases$total_pop)
is.ordered(cases$total_pop)  #Nominal

is.factor(cases$median_income)
is.ordered(cases$median_income)  #Nominal

is.factor(cases$median_age)
is.ordered(cases$median_age)  #Nominal

is.factor(cases$employed_education_health_social)
is.ordered(cases$employed_education_health_social)  #Nominal

is.factor(cases$employed_science_management_admin_waste)
is.ordered(cases$employed_science_management_admin_waste)  #Nominal

is.factor(cases$nonfamily_households)
is.ordered(cases$nonfamily_households)  #Nominal

is.factor(cases$family_households)
is.ordered(cases$family_households)  #Nominal


# Filter for state of Texas
cases_TX <- cases %>% filter(state == "TX")
dim(cases_TX)
summary(cases_TX[,1:10])
cases_TX


# Renaming variables
cases_new <- cases_TX %>%
  rename(
    State = state,
    County = county_name,
    Confirmed_Cases = confirmed_cases,
    Deaths = deaths,
    Total_Population = total_pop,
    Median_Income = median_income,
    Median_Age = median_age,
    Employed_Edu_Health = employed_education_health_social,
    Employed_Science_Admin = employed_science_management_admin_waste,
    Nonfamily_Households = nonfamily_households,
    Family_Households = family_households
  ) %>%
  group_by(State, County) %>%
  summarise(
    Confirmed_Cases = sum(Confirmed_Cases, na.rm = TRUE),
    Deaths = sum(Deaths, na.rm = TRUE),
    Total_Population = sum(Total_Population, na.rm = TRUE),
    Median_Income = mean(Median_Income, na.rm = TRUE),
    Median_Age = mean(Median_Age, na.rm = TRUE),
    Employed_Edu_Health = sum(Employed_Edu_Health, na.rm = TRUE),
    Employed_Science_Admin = sum(Employed_Science_Admin, na.rm = TRUE),
    Nonfamily_Households = sum(Nonfamily_Households, na.rm = TRUE),
    Family_Households = sum(Family_Households, na.rm = TRUE),
    .groups = "drop"  # Ensures the output is ungrouped
  )

cases_new

# Checking for missing values
missing_values <- colSums(is.na(cases_new)) # Checking for any Missing Values
print(missing_values)

# Checking for duplicate data
duplicates <- cases_new[duplicated(cases_new), ] # Checking for any Duplicates
print(duplicates)

# Checking for outliers
boxplot_stats <- function(column) { 
  if (is.numeric(column)) { 
    return(boxplot.stats(column)$out) 
  } else { 
    return(NULL) } 
} 

# Summarize all numeric columns per county
final_df <- cases_new %>%
  group_by(County) %>%
  summarise(across(where(is.numeric), sum, na.rm = TRUE)) %>% 
  ungroup() %>%
  pivot_longer(-County, names_to = "Variable", values_to = "Total_Value") %>%
  left_join(
    cases_new %>%
      select(County, where(is.numeric)) %>%
      pivot_longer(-County, names_to = "Variable", values_to = "Value") %>%
      group_by(County, Variable) %>%
      mutate(
        Q1 = quantile(Value, 0.25, na.rm = TRUE),
        Q3 = quantile(Value, 0.75, na.rm = TRUE),
        IQR = Q3 - Q1,
        Lower_Bound = Q1 - 1.5 * IQR,
        Upper_Bound = Q3 + 1.5 * IQR
      ) %>%
      filter(Value < Lower_Bound | Value > Upper_Bound) %>%  # Keep only true outliers
      group_by(County, Variable) %>%
      summarise(Outlier_Value = paste(Value, collapse = ", "), .groups = "drop"),  # Concatenate multiple outliers
    by = c("County", "Variable")
  )

# Print column names with actual outlier values
if (any(!is.na(final_df$Outlier_Value))) {
  print("Detected Outliers by Column:")
  print(final_df)
} else {
  print("No outliers detected in the dataset.")
}



# Summary of variables
summary_cases <- summary(cases_new)
print(summary_cases)

##STATS

# Variance
variance_cases <- cases_new %>%
  summarise(across(where(is.numeric), var, na.rm = TRUE))
print(variance_cases)


# St. deviance
st_deviance = cases_new %>%
  summarise(across(where(is.numeric), sd, na.rm = TRUE))
print(st_deviance)




# Function to calculate mode
get_mode <- function(x) {
  uniq_x <- unique(x[!is.na(x)])  # Remove NA values
  uniq_x[which.max(tabulate(match(x, uniq_x)))]
}

# Apply mode function to all variables
mode_values <- cases_new %>%
  summarise(across(everything(), get_mode))

print("Mode of all variables:")
print(mode_values)

# Averages total population modes
find_mode <- function(cases_new, Total_Population) {
  column_data <- cases_new[["Total_Population"]]
  freq_table <- table(column_data)
  max_freq <- max(freq_table)
  mode_values <- as.numeric(names(freq_table[freq_table == max_freq]))
  mode_avg <- mean(mode_values)
  return(mode_avg)
}
print(find_mode(cases_new, "Total_Population"))

# Range where we do max-min
range_diff <- cases_new %>%
  summarise(across(where(is.numeric), ~ max(.x, na.rm = TRUE) - min(.x, na.rm = TRUE)))

# Print the range values
print("Range (Max - Min) of all numeric variables:")
print(range_diff)



##GRAPHS


###################################################################
# Confirmed_Cases - Histogram
ggplot(cases_new, aes(x = Confirmed_Cases)) +
  geom_histogram(binwidth = 1000, fill = "green", color = "black") +
  coord_cartesian(xlim = c(0,30000)) +
  labs(title = "Histogram of Confirmed_Cases", x = "Confirmed_Cases", y = "Count") +
  theme_minimal()
#lognormal distribution, why this distribution happens, generating process, what kind of process generates this data

###################################################################

# Deaths - Histogram
ggplot(cases_new, aes(x = Deaths)) +
  geom_histogram(binwidth = 50, fill = "green", color = "black") +
  coord_cartesian(xlim = c(0, 1000)) +
  labs(title = "Histogram of Deaths (Zoomed In)", x = "Deaths", y = "Count") +
  theme_minimal()

###################################################################
# Total_Population  - Histogram
ggplot(cases_new, aes(x = Total_Population)) +
  geom_histogram(binwidth = 5000, fill = "red", color = "black") +
  coord_cartesian(xlim = c(0, 500000)) +
  labs(title = "Histogram of Total_Population", x = "Total_Population", y = "Count") +
  scale_x_continuous(labels = scales::comma) 


# Median_Income  - Histogram
ggplot(cases_new, aes(x = Median_Income)) +
  geom_histogram(binwidth = 5000, fill = "lightblue", color = "black") +
  labs(title = "Histogram of Median_Income", x = "Median_Income", y = "Count") +
  scale_x_continuous(labels = scales::comma)

# Median_Age - Histogram
ggplot(cases_new, aes(x = Median_Age)) +
  geom_histogram(binwidth = 2, fill = "steelblue", color = "black") +
  labs(title = "Histogram of Median_Age", x = "Median_Age", y = "Count") +
  scale_x_continuous(labels = scales::comma)

# Employed_Edu_Health - Histogram
ggplot(cases_new, aes(x = Employed_Edu_Health)) +
  geom_histogram(binwidth = 500, fill = "#82BfB7", color = "black") +
  coord_cartesian(xlim = c(0, 50000)) +
  labs(title = "Histogram of Employed_Edu_Health", x = "Employed_Edu_Health", y = "Count") +
  scale_x_continuous(labels = scales::comma)

# Employed_Science_Admin - Histogram
ggplot(cases_new, aes(x = Employed_Science_Admin)) +
  geom_histogram(binwidth = 100, fill = "#82BfB7", color = "black") +
  coord_cartesian(xlim = c(0, 6000)) +
  labs(title = "Histogram of Employed_Science_Admin", x = "Employed_Science_Admin", y = "Count") +
  scale_x_continuous(labels = scales::comma)

# Nonfamily_Households - Histogram
ggplot(cases_new, aes(x = Nonfamily_Households)) +
  geom_histogram(binwidth = 1000, fill = "#f2a2bd", color = "black") +
  coord_cartesian(xlim = c(0, 75000)) +
  labs(title = "Histogram of Nonfamily_Households", x = "Nonfamily_Households", y = "Count") +
  scale_x_continuous(labels = scales::comma)

# Family_Households - Histogram
ggplot(cases_new, aes(x = Family_Households)) +
  geom_histogram(binwidth = 2000, fill = "#f2a2bd", color = "black") +
  coord_cartesian(xlim = c(0, 150000)) +
  labs(title = "Histogram of Family_Households", x = "Family_Households", y = "Count") +
  scale_x_continuous(labels = scales::comma)

# State - Map 
library(maps)
states_map <- map_data("state")

#Compute state centers for labels (average longitude & latitude)
state_centers <- states_map %>%
  group_by(region) %>%
  summarise(long = mean(range(long)), lat = mean(range(lat)))  # Get midpoints

ggplot() +
  #Plot state map
  geom_polygon(data = states_map, aes(x = long, y = lat, group = group), 
               fill = "lightblue", color = "white") +
  #Add state labels
  geom_text(data = state_centers, aes(x = long, y = lat, label = region), 
            size = 3, color = "black") +  #Adjust label size & color
  coord_fixed(1.3) +
  labs(title = "State-Level Map with Labels") +
  theme_void()  #Removes background & grid


# County - Map
#Get US counties map data
counties_map <- map_data("county")

#Filter for Texas
texas_map <- counties_map %>%
  filter(region == "texas")

#Convert county names to lowercase for merging
cases_new <- cases_new %>%
  mutate(County = tolower(County), State = tolower(State))
cases_texas <- cases_new %>%
  filter(State == "texas")

#Merge Texas county map with cases data
texas_map_data <- left_join(texas_map, cases_texas, 
                            by = c("subregion" = "County"))
#Compute county centroids for labeling
county_labels <- texas_map_data %>%
  group_by(subregion) %>%
  summarise(long = mean(long), lat = mean(lat))

str(texas_map_data)

ggplot(data = texas_map_data, aes(x = long, y = lat, group = group, fill = Confirmed_Cases)) +
  geom_polygon(color = "white") +
  geom_text_repel(data = county_labels, aes(x = long, y = lat, label = subregion),
                  inherit.aes = FALSE,
                  size = 3, color = "black", box.padding = 0.3, max.overlaps = Inf) +  # Add county labels
  coord_fixed(1.3) +
  theme_minimal() +
  labs(title = "Texas County Map of Confirmed Cases",
       fill = "Confirmed Cases") +
  scale_fill_gradient(low = "lightblue", high = "red", na.value = "gray")

#Mobility data graph
mobility <- read.csv("C:/SMU/24-25/CS 7331/COVID-19/Global_Mobility_Report.csv")
mobility_TX <- mobility %>%
  filter(sub_region_1 == "Texas") %>%
  mutate(date =  ymd(date)) 
#write.csv(mobility_TX, file = "mobility_TX.csv", row.names = FALSE)

# Compute the average mobility trends per day
mobility_trends <- mobility_TX %>%
  group_by(date) %>%
  summarize(
    retail = mean(retail_and_recreation_percent_change_from_baseline, na.rm = TRUE),
    grocery = mean(grocery_and_pharmacy_percent_change_from_baseline, na.rm = TRUE),
    workplaces = mean(workplaces_percent_change_from_baseline, na.rm = TRUE),
    residential = mean(residential_percent_change_from_baseline, na.rm = TRUE)
  )

# Plot the mobility trends over time
ggplot(mobility_trends, aes(x = date)) +
  geom_line(aes(y = retail, color = "Retail & Recreation"), linetype = "solid") +
  geom_line(aes(y = grocery, color = "Grocery & Pharmacy"), linetype = "dashed") +
  geom_line(aes(y = workplaces, color = "Workplaces"), linetype = "dotdash") +
  geom_line(aes(y = residential, color = "Residential"), linetype = "dotted") +
  labs(
    title = "Mobility Trends Over Time in Texas",
    x = "Date",
    y = "Percentage Change from Baseline",
    color = "Mobility Category"
  ) +
  theme_minimal() +
  theme(legend.position = "bottom") +
  scale_color_manual(values = c("Retail & Recreation" = "red", 
                                "Grocery & Pharmacy" = "green", 
                                "Workplaces" = "blue",
                                "Residential" = "purple"))

##RELATIONSHIPS BETWEEN ATTRIBUTES

# Confirmed_Cases vs Deaths
ggplot(cases_new, aes(x=Confirmed_Cases, y=Deaths)) + 
  geom_point() + 
  xlim(0, 250000)+
  ylim(0, 10000)+
  geom_smooth(color="red", se = FALSE) +
  labs(title = "Scatterplot of Confirmed Cases vs Deaths",
       x="Confirmed Cases", y="Deaths")

# County vs Deaths
cases_new <- cases_new %>% 
  mutate(County = toupper(County))
head(cases_new)

top10_deaths <- cases_new %>% 
  arrange(desc(Deaths)) %>% 
  slice_head(n=10) %>% 
  select(County,Deaths)
print(top10_deaths)

# Confirmed_Cases vs County
cases_new <- cases_new %>% 
  mutate(County = toupper(County))
head(cases_new)

top10_cases <- cases_new %>% 
  arrange(desc(Confirmed_Cases)) %>% 
  slice_head(n=10) %>% 
  select(County,Confirmed_Cases)
print(top10_cases)



# Median_Age vs Deaths (Both are numerical data types)
ggplot(cases_new, aes(x=Median_Age, y=Deaths)) + 
  geom_point() + 
  ylim(0,10000)+
  geom_smooth(color = "red", se= FALSE)
labs(title = "Scatterplot of Median Age vs Deaths",
     x="Median Age", y="Deaths")

# Median_Age vs Employed_Edu_Health
ggplot(cases_new, aes(x = Median_Age, y = Employed_Edu_Health)) +
  geom_point(color = "blue", alpha = 0.6) + 
  ylim(0,500000)+
  geom_smooth(color = "red", se = FALSE)
labs(x = "Median Age", y = "Employed Education Health Social", 
     title = "Employment vs. Median Age") + 
  theme_minimal()

# Median_Age vs Employed_Science_Admin
ggplot(cases_new, aes(x = Median_Age, y = Employed_Science_Admin)) +
  geom_point(color = "blue", alpha = 0.6) + 
  ylim(0,500000) +
  geom_smooth(color = "red", se = FALSE)
labs(x = "Median Age", y = "Employed Science  
Management Admin Waste", 
     title = "Employment vs. Median Age") + 
  theme_minimal() 


# Median_Income vs Deaths
ggplot(cases_new, aes(x=Median_Income, y=Deaths)) + 
  geom_point() + 
  xlim(0,100000)+
  ylim(0,10000)+
  geom_smooth(color = "red", se= FALSE)
labs(title = "Scatterplot of Median Income vs Deaths",
     x="Median Income", y="Deaths")


# Nonfamily_Households and Family_Households vs Median_Income vs Deaths
top10_income <- cases_new %>% 
  arrange(desc(Median_Income)) %>%  # Sort by Median Income in descending order
  slice_head(n = 10) %>%  # Select top 10 counties
  select(Family_Households, Nonfamily_Households, Median_Income, Deaths)  # Keep relevant columns

print(top10_income)


