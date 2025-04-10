library("ggplot2")
library("ggrepel")
library("ggcorrplot")
library("DT")
library(dplyr)
library(scales)
library(tidyr)
library(dbscan)
library(cluster)
library(purrr)
library(factoextra)
library(knitr)
library(fpc)
library(mclust)



pkgs <- c("cluster", "dbscan", "e1071", "factoextra", "fpc", 
          "GGally", "kernlab", "mclust", "mlbench", "scatterpie", 
          "seriation", "tidyverse", "ggplot2", "ggrepel", "ggcorrplot", "DT", 
          "dplyr", "scales", "dendextend", "purrr", "knitr")

pkgs_install <- pkgs[!(pkgs %in% installed.packages()[,"Package"])]
if(length(pkgs_install)) install.packages(pkgs_install)


#loading in datasets
setwd("/Users/muskaanmahes/Downloads/COVID-19")
cases_TX <- read.csv("COVID-19_cases_TX.csv")
mobility <- read.csv("Global_Mobility_Report.csv")
cases <- read.csv("COVID-19_cases_plus_census.csv")



#Filter for Texas mobility data
mobility_TX <- mobility %>%
  filter(sub_region_1 == "Texas")


#Merging mobility and cases datasets
composite <- merge(x=cases_TX, y = mobility_TX, by.x = c("county_name", "date"), 
                   by.y = c("sub_region_2", "date"))

#Merge total population into composite dataset
composite <- composite %>%
  filter(date == "2021-01-22") %>%
  mutate(total_pop = cases$total_pop[match(county_name, cases$county_name)]) %>%
  mutate(median_income = cases$median_income[match(county_name, cases$county_name)]) %>%
  mutate(median_age = cases$median_age[match(county_name, cases$county_name)]) %>%
  mutate(nonfamily_households = cases$nonfamily_households[match(county_name, cases$county_name)]) %>%
  mutate(family_households = cases$family_households[match(county_name, cases$county_name)]) %>%
  mutate(poverty = cases$poverty[match(county_name, cases$county_name)]) %>%
  mutate(households = cases$households[match(county_name, cases$county_name)])


#Removing extra columns
composite$county_fips_code <- NULL
composite$state_fips_code <- NULL
composite$country_region_code <- NULL
composite$sub_region_1 <- NULL
composite$country_region <- NULL
composite$metro_area <- NULL
composite$iso_3166_2_code <- NULL
composite$census_fips_code <- NULL

#write.csv(composite, file = "composite.csv", row.names = FALSE)



#Checking for missing values
missing_values <- colSums(is.na(composite))
print(missing_values)

#Checking for duplicate data
duplicates <- composite[duplicated(composite), ]
print(duplicates)

summary(composite)

##STATS##

#Variance
variance_composite <- composite %>%
  summarise(across(where(is.numeric), var, na.rm = TRUE))
print(variance_composite)


#St. deviance
st_deviance = composite %>%
  summarise(across(where(is.numeric), sd, na.rm = TRUE))
print(st_deviance)


#Function to calculate mode
get_mode <- function(x) {
  uniq_x <- unique(x[!is.na(x)])  # Remove NA values
  uniq_x[which.max(tabulate(match(x, uniq_x)))]
}

#Apply mode function to all variables
mode_values <- composite %>%
  summarise(across(everything(), get_mode))

print("Mode of all variables:")
print(mode_values)

#Range where we do max-min
range_diff <- composite %>%
  summarise(across(where(is.numeric), ~ max(.x, na.rm = TRUE) - min(.x, na.rm = TRUE)))

#Print the range values
print("Range (Max - Min) of all numeric variables:")
print(range_diff)

colnames(composite)

#Normalizing

composite_normalized <- composite %>% mutate(
  cases_per_10000 = confirmed_cases/total_pop*10000, 
  deaths_per_10000 = deaths/total_pop*10000,
  death_per_case = deaths/confirmed_cases,
nonfamily_households_10000 = nonfamily_households/households*10000,
family_households_10000 = family_households/households*10000,
poverty_10000 = poverty/total_pop*10000)
summary(composite_normalized)

##MODELING##

##K-MEANS##
#Households
composite_scaled_households <- composite_normalized %>%
  select(median_income, median_age, nonfamily_households_10000, family_households_10000, cases_per_10000, deaths_per_10000) %>%
  scale() %>%
  as_tibble()

summary(composite_scaled_households)

#elbow method

# Vector of k values to test
ks <- 1:10

# Compute total within-cluster sum of squares for each k
WCSS <- sapply(ks, function(k) {
  kmeans(composite_scaled_households, centers = k, nstart = 25)$tot.withinss
})

# Plot the elbow graph
ggplot(tibble(k = ks, WCSS), aes(x = k, y = WCSS)) +
  geom_line(size = 1) +
  geom_point(size = 2) +
  scale_x_continuous(breaks = 1:10)+
  geom_vline(xintercept = 3, linetype = "dashed", color = "red") +  # Optional: guessed best k
  labs(title = "Elbow Method for Optimal Clusters",
       x = "Number of Clusters (k)",
       y = "Total Within-Cluster Sum of Squares (WCSS)") +
  theme_minimal()

#plot kmeans 
set.seed(123)
km <- kmeans(composite_scaled_households, centers=3, nstart=25)
km

ggplot(pivot_longer(as_tibble(km$centers,  rownames = 
                                "cluster"), 
                    cols = colnames(km$centers)), 
       aes(y = name, x = value, fill = cluster)) +
  geom_bar(stat = 
             "identity") +
  facet_grid(cols = vars(cluster)) +
  labs(y = 
         "feature", x = 
         "z-scores", title = 
         "Cluster Profiles") + 
  guides(fill=
           "none")


#Poverty
composite_scaled_poverty <- composite_normalized %>%
  select(median_income, median_age, poverty_10000, cases_per_10000, deaths_per_10000) %>%
  scale() %>%
  as_tibble()

summary(composite_scaled_poverty)

set.seed(123)
km <- kmeans(composite_scaled_poverty, centers=3, nstart=25)
km

ggplot(pivot_longer(as_tibble(km$centers,  rownames = 
                                "cluster"), 
                    cols = colnames(km$centers)), 
       aes(y = name, x = value, fill = cluster)) +
  geom_bar(stat = 
             "identity") +
  facet_grid(cols = vars(cluster)) +
  labs(y = 
         "feature", x = 
         "z-scores", title = 
         "Cluster Profiles") + 
  guides(fill=
           "none")

#DemoMobility
composite_scaled_demomobility <- composite_normalized %>%
  select(median_income,
         median_age,
         retail_and_recreation_percent_change_from_baseline,
         grocery_and_pharmacy_percent_change_from_baseline,
         workplaces_percent_change_from_baseline,
         residential_percent_change_from_baseline, cases_per_10000, deaths_per_10000) %>%
  scale() %>%
  as_tibble()

# 2. Clean: remove rows with NA, NaN, or Inf
composite_scaled_demomobility_clean <- composite_scaled_demomobility %>%
  drop_na() %>%
  filter(if_all(everything(), ~ is.finite(.)))

set.seed(123)
km <- kmeans(composite_scaled_demomobility_clean, centers=3, nstart=25)
km

ggplot(pivot_longer(as_tibble(km$centers,  rownames = 
                                "cluster"), 
                    cols = colnames(km$centers)), 
       aes(y = name, x = value, fill = cluster)) +
  geom_bar(stat = 
             "identity") +
  facet_grid(cols = vars(cluster)) +
  labs(y = 
         "feature", x = 
         "z-scores", title = 
         "Cluster Profiles") + 
  guides(fill=
           "none")

#Mobility
composite_scaled_mobility <- composite_normalized %>%
  select(retail_and_recreation_percent_change_from_baseline,
         grocery_and_pharmacy_percent_change_from_baseline,
         workplaces_percent_change_from_baseline,
         residential_percent_change_from_baseline, cases_per_10000, deaths_per_10000) %>%
  scale() %>%
  as_tibble()

# 2. Clean: remove rows with NA, NaN, or Inf
composite_scaled_mobility_clean <- composite_scaled_mobility %>%
  drop_na() %>%
  filter(if_all(everything(), ~ is.finite(.)))

set.seed(123)
km <- kmeans(composite_scaled_mobility_clean, centers=3, nstart=25)
km

ggplot(pivot_longer(as_tibble(km$centers,  rownames = 
                                "cluster"), 
                    cols = colnames(km$centers)), 
       aes(y = name, x = value, fill = cluster)) +
  geom_bar(stat = 
             "identity") +
  facet_grid(cols = vars(cluster)) +
  labs(y = 
         "feature", x = 
         "z-scores", title = 
         "Cluster Profiles") + 
  guides(fill=
           "none")



##HIERARCHICAL##
library(dendextend)

#Households
selected_features_households <- c(
  "median_income",
  "median_age",
  "nonfamily_households_10000",
  "family_households_10000",
  "cases_per_10000",
  "deaths_per_10000"
)
composite_clean_households <- composite_normalized %>%
  select(all_of(selected_features_households)) %>%
  drop_na()

scaled_data <- scale(composite_clean_households)


distance_matrix <- dist(scaled_data, method = "euclidean")
hc <- hclust(distance_matrix, method = "ward.D2")
plot(hc, cex = 0.6, hang = -1, main = "Dendrogram of Hierarchical Clustering")
clusters <- cutree(hc, k = 3)

dend <- as.dendrogram(hc) # Convert clustering to dendrogram
dend_colored <- color_branches(dend, k = 3) # Color branches by cluster
labels_colors(dend_colored) <- clusters[order.dendrogram(dend)] # Color labels to match clusters

# Plot the colored dendrogram
plot(dend_colored, main = "Colored Dendrogram with Cluster Labels")

pca <- prcomp(scaled_data) # Run PCA for plotting
pca_data <- as.data.frame(pca$x) # Convert to data frame
pca_data$cluster <- as.factor(clusters)
# Plot
ggplot(pca_data, aes(x = PC1, y = PC2, color = cluster)) +
  geom_point(alpha = 0.7) +  
  theme_minimal() +
  labs(title = "PCA Plot of Hierarchical Clustering")

#Poverty
selected_features_poverty <- c(
  "median_income",
  "median_age",
  "poverty_10000",
  "cases_per_10000",
  "deaths_per_10000"
)
composite_clean_poverty <- composite_normalized %>%
  select(all_of(selected_features_poverty)) %>%
  drop_na()

scaled_data <- scale(composite_clean_poverty)


distance_matrix <- dist(scaled_data, method = "euclidean")
hc <- hclust(distance_matrix, method = "ward.D2")
plot(hc, cex = 0.6, hang = -1, main = "Dendrogram of Hierarchical Clustering")
clusters <- cutree(hc, k = 3)

dend <- as.dendrogram(hc) # Convert clustering to dendrogram
dend_colored <- color_branches(dend, k = 3) # Color branches by cluster
labels_colors(dend_colored) <- clusters[order.dendrogram(dend)] # Color labels to match clusters

# Plot the colored dendrogram
plot(dend_colored, main = "Colored Dendrogram with Cluster Labels")

pca <- prcomp(scaled_data) # Run PCA for plotting
pca_data <- as.data.frame(pca$x) # Convert to data frame
pca_data$cluster <- as.factor(clusters)
# Plot
ggplot(pca_data, aes(x = PC1, y = PC2, color = cluster)) +
  geom_point(alpha = 0.7) + 
  theme_minimal() +
  labs(title = "PCA Plot of Hierarchical Clustering")


#DemoMobility
selected_features_demomobility <- c(
  "median_income",
  "median_age",
  "retail_and_recreation_percent_change_from_baseline",
  "grocery_and_pharmacy_percent_change_from_baseline",
  "workplaces_percent_change_from_baseline",
  "residential_percent_change_from_baseline","cases_per_10000",
   "deaths_per_10000"
)
composite_clean <- composite_normalized %>%
  select(all_of(selected_features_demomobility)) %>%
  drop_na()

scaled_data <- scale(composite_clean)

distance_matrix <- dist(scaled_data, method = "euclidean")
hc <- hclust(distance_matrix, method = "ward.D2")
plot(hc, cex = 0.6, hang = -1, main = "Dendrogram of Hierarchical Clustering")
clusters <- cutree(hc, k = 3)

dend <- as.dendrogram(hc) # Convert clustering to dendrogram
dend_colored <- color_branches(dend, k = 3) # Color branches by cluster
labels_colors(dend_colored) <- clusters[order.dendrogram(dend)] # Color labels to match clusters

# Plot the colored dendrogram
plot(dend_colored, main = "Colored Dendrogram with Cluster Labels")

pca <- prcomp(scaled_data) # Run PCA for plotting
pca_data <- as.data.frame(pca$x) # Convert to data frame
pca_data$cluster <- as.factor(clusters)
# Plot
ggplot(pca_data, aes(x = PC1, y = PC2, color = cluster)) +
  geom_point(alpha = 0.7) + 
  theme_minimal() +
  labs(title = "PCA Plot of Hierarchical Clustering")

#Mobility
selected_features_mobility <- c(
  "retail_and_recreation_percent_change_from_baseline",
  "grocery_and_pharmacy_percent_change_from_baseline",
  "workplaces_percent_change_from_baseline",
  "residential_percent_change_from_baseline", "cases_per_10000",
  "deaths_per_10000"
)
composite_clean <- composite_normalized %>%
  select(all_of(selected_features_mobility)) %>%
  drop_na()

scaled_data <- scale(composite_clean)


distance_matrix <- dist(scaled_data, method = "euclidean")
hc <- hclust(distance_matrix, method = "ward.D2")
plot(hc, cex = 0.6, hang = -1, main = "Dendrogram of Hierarchical Clustering")
clusters <- cutree(hc, k = 3)

dend <- as.dendrogram(hc) # Convert clustering to dendrogram
dend_colored <- color_branches(dend, k = 3) # Color branches by cluster
labels_colors(dend_colored) <- clusters[order.dendrogram(dend)] # Color labels to match clusters

# Plot the colored dendrogram
plot(dend_colored, main = "Colored Dendrogram with Cluster Labels")

pca <- prcomp(scaled_data) # Run PCA for plotting
pca_data <- as.data.frame(pca$x) # Convert to data frame
pca_data$cluster <- as.factor(clusters)
# Plot
ggplot(pca_data, aes(x = PC1, y = PC2, color = cluster)) +
  geom_point(alpha = 0.7) +
  theme_minimal() +
  labs(title = "PCA Plot of Hierarchical Clustering")



##HIERARCHICAL - CURE##
#Households
clustering_vars_households <- composite_normalized %>%
  select(median_age, median_income,
         nonfamily_households_10000, family_households_10000, cases_per_10000, deaths_per_10000)

vars = names(clustering_vars_households)
composite_cleaned <- composite_normalized %>%
  select(all_of(vars)) %>%
  drop_na()

# Scale the data
clustering_scaled <- scale(composite_cleaned) %>% as.data.frame()

dist_matrix <- dist(clustering_scaled)

# Hierarchical clustering (Ward's method)
hc <- hclust(dist_matrix, method = "ward.D2")

# Plot dendrogram
plot(hc, hang = -1, labels = FALSE, main = "Hierarchical Clustering Dendrogram")
rect.hclust(hc, k = 3, border = "red")




#cutting into 3 clusters
composite_cleaned$cluster_hier <- factor(cutree(hc, k = 3))

# Visualize dendrogram with cluster rectangles
fviz_dend(hc, k = 3, rect = TRUE, show_labels = FALSE,
          main = "Simulated CURE via Hierarchical Clustering")


# Perform PCA on scaled data
pca_result <- prcomp(clustering_scaled)

# Convert PCA results to data frame for ggplot
pca_data <- as.data.frame(pca_result$x)

# Add cluster assignments to the PCA data
pca_data$cluster <- composite_cleaned$cluster_hier

# Visualize the clusters in PCA space

ggplot(pca_data, aes(x = PC1, y = PC2, color = cluster)) +
  geom_point(alpha = 0.7) +
  theme_minimal() +
  labs(title = "PCA Plot of Hierarchical Clustering (CURE Approximation)", 
       x = "Principal Component 1",
       y = "Principal Component 2"
  ) +
  theme(
    legend.position = "right",
    legend.title = element_text(face = "bold"),
    legend.text = element_text(size = 12)
  )

#Poverty
clustering_vars_poverty <- composite_normalized %>%
  select(median_age, median_income,
         poverty_10000, cases_per_10000, deaths_per_10000)

vars = names(clustering_vars_poverty)
composite_cleaned <- composite_normalized %>%
  select(all_of(vars)) %>%
  drop_na()

# Scale the data
clustering_scaled <- scale(composite_cleaned) %>% as.data.frame()

dist_matrix <- dist(clustering_scaled)

# Hierarchical clustering (Ward's method)
hc <- hclust(dist_matrix, method = "ward.D2")

# Plot dendrogram
plot(hc, hang = -1, labels = FALSE, main = "Hierarchical Clustering Dendrogram")
rect.hclust(hc, k = 3, border = "red")


#cutting into 3 clusters
composite_cleaned$cluster_hier <- factor(cutree(hc, k = 3))

# Visualize dendrogram with cluster rectangles
fviz_dend(hc, k = 3, rect = TRUE, show_labels = FALSE,
          main = "Simulated CURE via Hierarchical Clustering")


# Perform PCA on scaled data
pca_result <- prcomp(clustering_scaled)

# Convert PCA results to data frame for ggplot
pca_data <- as.data.frame(pca_result$x)

# Add cluster assignments to the PCA data
pca_data$cluster <- composite_cleaned$cluster_hier

# Visualize the clusters in PCA space

ggplot(pca_data, aes(x = PC1, y = PC2, color = cluster)) +
  geom_point(alpha = 0.7) +
  theme_minimal() +
  labs(title = "PCA Plot of Hierarchical Clustering (CURE Approximation)", 
       x = "Principal Component 1",
       y = "Principal Component 2"
  ) +
  theme(
    legend.position = "right",
    legend.title = element_text(face = "bold"),
    legend.text = element_text(size = 12)
  )

#DemoMobility
clustering_vars_demomobility <- composite_normalized %>%
  select(median_income,
         median_age,
         retail_and_recreation_percent_change_from_baseline,
         grocery_and_pharmacy_percent_change_from_baseline,
         workplaces_percent_change_from_baseline,
         residential_percent_change_from_baseline, cases_per_10000, deaths_per_10000)

vars = names(clustering_vars_demomobility)
composite_cleaned <- composite_normalized %>%
  select(all_of(vars)) %>%
  drop_na()


# Scale the data
clustering_scaled <- scale(composite_cleaned) %>% as.data.frame()


dist_matrix <- dist(clustering_scaled)

# Hierarchical clustering (Ward's method)
hc <- hclust(dist_matrix, method = "ward.D2")


# Plot dendrogram
plot(hc, hang = -1, labels = FALSE, main = "Hierarchical Clustering Dendrogram")
rect.hclust(hc, k = 3, border = "red")


#cutting into 3 clusters
composite_cleaned$cluster_hier <- factor(cutree(hc, k = 3))

# Visualize dendrogram with cluster rectangles
fviz_dend(hc, k = 3, rect = TRUE, show_labels = FALSE,
          main = "Simulated CURE via Hierarchical Clustering")


# Perform PCA on scaled data
pca_result <- prcomp(clustering_scaled)

# Convert PCA results to data frame for ggplot
pca_data <- as.data.frame(pca_result$x)

# Add cluster assignments to the PCA data
pca_data$cluster <- composite_cleaned$cluster_hier

# Visualize the clusters in PCA space

ggplot(pca_data, aes(x = PC1, y = PC2, color = cluster)) +
  geom_point(alpha = 0.7) +
  theme_minimal() +
  labs(title = "PCA Plot of Hierarchical Clustering (CURE Approximation)", 
       x = "Principal Component 1",
       y = "Principal Component 2"
  ) +
  theme(
    legend.position = "right",
    legend.title = element_text(face = "bold"),
    legend.text = element_text(size = 12)
  )

#Mobility
clustering_vars_mobility <- composite_normalized %>%
  select(retail_and_recreation_percent_change_from_baseline,
         grocery_and_pharmacy_percent_change_from_baseline,
         workplaces_percent_change_from_baseline,
         residential_percent_change_from_baseline, cases_per_10000, deaths_per_10000)

vars = names(clustering_vars_mobility)
composite_cleaned <- composite_normalized %>%
  select(all_of(vars)) %>%
  drop_na()


# Scale the data
clustering_scaled <- scale(composite_cleaned) %>% as.data.frame()


dist_matrix <- dist(clustering_scaled)

# Hierarchical clustering (Ward's method)
hc <- hclust(dist_matrix, method = "ward.D2")


# Plot dendrogram
plot(hc, hang = -1, labels = FALSE, main = "Hierarchical Clustering Dendrogram")
rect.hclust(hc, k = 3, border = "red")


#cutting into 3 clusters
composite_cleaned$cluster_hier <- factor(cutree(hc, k = 3))

# Visualize dendrogram with cluster rectangles
fviz_dend(hc, k = 3, rect = TRUE, show_labels = FALSE,
          main = "Simulated CURE via Hierarchical Clustering")


# Perform PCA on scaled data
pca_result <- prcomp(clustering_scaled)

# Convert PCA results to data frame for ggplot
pca_data <- as.data.frame(pca_result$x)

# Add cluster assignments to the PCA data
pca_data$cluster <- composite_cleaned$cluster_hier

# Visualize the clusters in PCA space

ggplot(pca_data, aes(x = PC1, y = PC2, color = cluster)) +
  geom_point(alpha = 0.7) +
  theme_minimal() +
  labs(title = "PCA Plot of Hierarchical Clustering (CURE Approximation)", 
       x = "Principal Component 1",
       y = "Principal Component 2"
  ) +
  theme(
    legend.position = "right",
    legend.title = element_text(face = "bold"),
    legend.text = element_text(size = 12)
  )


#DBSCAN
#Households
clustering_vars_households <- composite_normalized %>%
  select(
    median_age, median_income,
    nonfamily_households_10000, family_households_10000, cases_per_10000, deaths_per_10000
  )

# Step 2: Clean data - remove missing values
clustering_vars_clean <- clustering_vars_households %>%
  drop_na()

# Step 3: Scale the data
db_data <- scale(clustering_vars_clean)

# Step 4: Determine eps value using k = dimensions (4 variables) + 1
kNNdistplot(db_data, k = 6)
abline(h = 2.2, col = "red")

# Step 5: Run DBSCAN with adjusted eps
db <- dbscan(db_data, eps = 2.2, minPts = 7)

# Step 6: Add cluster results to clean data
clustering_vars_clean <- clustering_vars_clean %>%
  mutate(dbscan_cluster = as.factor(db$cluster))

# Step 7: Visualize clusters
fviz_cluster(db, data = db_data) +
  labs(title = "DBSCAN Clustering on Households Data (eps = 2.2)")

#Poverty
clustering_vars_poverty <- composite_normalized %>%
  select(
    median_age, median_income,
    poverty_10000, cases_per_10000, deaths_per_10000
  )

# Step 2: Clean data - remove missing values
clustering_vars_clean <- clustering_vars_poverty %>%
  drop_na()

# Step 3: Scale the data
db_data <- scale(clustering_vars_clean)

# Step 4: Determine eps value using k = dimensions (4 variables) + 1
kNNdistplot(db_data, k = 5)
abline(h = 1.4, col = "red")

# Step 5: Run DBSCAN with adjusted eps
db <- dbscan(db_data, eps = 1.4, minPts = 6)

# Step 6: Add cluster results to clean data
clustering_vars_clean <- clustering_vars_clean %>%
  mutate(dbscan_cluster = as.factor(db$cluster))

# Step 7: Visualize clusters
fviz_cluster(db, data = db_data) +
  labs(title = "DBSCAN Clustering on Poverty Data (eps = 1.4)")

#DemoMobility
clustering_vars_demomobility <- composite_normalized %>%
  select(
    median_income,
    median_age,
    retail_and_recreation_percent_change_from_baseline,
    grocery_and_pharmacy_percent_change_from_baseline,
    workplaces_percent_change_from_baseline,
    residential_percent_change_from_baseline, 
    cases_per_10000, deaths_per_10000
  )

# Step 2: Clean data - remove missing values
clustering_vars_clean <- clustering_vars_demomobility %>%
  drop_na()

# Step 3: Scale the data
db_data <- scale(clustering_vars_clean)

# Step 4: Determine eps value using k = dimensions (4 variables) + 1
kNNdistplot(db_data, k = 8)
abline(h = 3.3, col = "red")

# Step 5: Run DBSCAN with adjusted eps
db <- dbscan(db_data, eps = 3.3, minPts = 9)

# Step 6: Add cluster results to clean data
clustering_vars_clean <- clustering_vars_clean %>%
  mutate(dbscan_cluster = as.factor(db$cluster))

# Step 7: Visualize clusters
fviz_cluster(db, data = db_data) +
  labs(title = "DBSCAN Clustering on Demographics and Mobility Data (eps = 3.3)")


#Mobility
clustering_vars_mobility <- composite_normalized %>%
  select(
    retail_and_recreation_percent_change_from_baseline,
    grocery_and_pharmacy_percent_change_from_baseline,
    workplaces_percent_change_from_baseline,
    residential_percent_change_from_baseline, cases_per_10000, deaths_per_10000
  )

# Step 2: Clean data - remove missing values
clustering_vars_clean <- clustering_vars_mobility %>%
  drop_na()

# Step 3: Scale the data
db_data <- scale(clustering_vars_clean)

# Step 4: Determine eps value using k = dimensions (4 variables) + 1
kNNdistplot(db_data, k = 6)
abline(h = 1.9, col = "red")

# Step 5: Run DBSCAN with adjusted eps
db <- dbscan(db_data, eps = 1.9, minPts = 7)

# Step 6: Add cluster results to clean data
clustering_vars_clean <- clustering_vars_clean %>%
  mutate(dbscan_cluster = as.factor(db$cluster))

# Step 7: Visualize clusters
fviz_cluster(db, data = db_data) +
  labs(title = "DBSCAN Clustering on Mobility Data (eps = 1.9)")


##Determining the Right No. of Clusters##


##Silhouette - Unsupervised Evaluation for Hierarchical##


##HOUSEHOLDS#####

##KMEANS
# Step 1: Compute distance matrix (same data used in K-means)
composite_scaled_households <- composite_normalized %>%
  select(median_income, median_age, nonfamily_households_10000, family_households_10000, cases_per_10000, deaths_per_10000) %>%
  scale() %>%
  as_tibble()

# Step 2: Run K-Means on the same scaled data
set.seed(123)
km <- kmeans(composite_scaled_households, centers = 3, nstart = 25)
dist_matrix <- dist(composite_scaled_households)


# Step 2: Compute silhouette object
sil_kmeans <- silhouette(km$cluster, dist_matrix)


# Step 4: fviz_silhouette for clean ggplot-style output
fviz_silhouette(sil_kmeans,
                palette = "Set1",         # Cluster colors
                print.summary = TRUE,     # Shows average silhouette width
                ggtheme = theme_minimal(), 
                color = "cluster")        # Color bars by cluster

#### Hierarchical clustering####

# Re-select and clean the data
composite_clean_households <- composite_normalized %>%
  select(median_income, median_age,
         nonfamily_households_10000, family_households_10000,
         cases_per_10000, deaths_per_10000) %>%
  drop_na()

# Scale the data
scaled_data <- scale(composite_clean_households)

# Distance matrix (must match scaled_data)
distance_matrix <- dist(scaled_data)

hc <- hclust(distance_matrix, method = "ward.D2")
clusters <- cutree(hc, k = 3)


# Step 1: Compute silhouette object
sil_hierarchical <- silhouette(clusters, distance_matrix)

# Step 2: Optional base R plot
plot(sil_hierarchical, main = "Silhouette Plot for Hierarchical Clustering")

# Step 3: ggplot-style plot
fviz_silhouette(sil_hierarchical,
                palette = "Set1",         # Colors by cluster
                print.summary = TRUE,     # Show avg silhouette width
                ggtheme = theme_minimal(),
                color = "cluster")

###Hierarchial CURE ######

# Ensure clusters match the matrix length
clusters_cure <- as.numeric(cutree(hc, k = 3))  # from your hclust object

# Make sure distance matrix and cluster vector match
length(clusters_cure) == attr(dist_matrix, "Size")  # this must be TRUE

# Silhouette analysis
sil_cure <- silhouette(clusters_cure, dist_matrix)

# Plot
fviz_silhouette(sil_cure,
                palette = "Set1",
                print.summary = TRUE,
                ggtheme = theme_minimal(),
                color = "cluster")


##DBSCAN####- not enough clusters will not work 


##################################################

##SILHOUETTE ANALYSIS FOR POVERTY###

#KMEANS
# Step 1: Compute distance matrix (based on scaled data)
dist_matrix_poverty <- dist(composite_scaled_poverty)

# Step 2: Compute silhouette object
sil_poverty <- silhouette(km$cluster, dist_matrix_poverty)

fviz_silhouette(sil_poverty,
                palette = "Set1",           # colors per cluster
                print.summary = TRUE,       # show average silhouette
                ggtheme = theme_minimal(),
                color = "cluster")


#HIERARCHICAL
sil_poverty_hier <- silhouette(clusters, distance_matrix)

fviz_silhouette(sil_poverty_hier,
                palette = "Set1",           # color by cluster
                print.summary = TRUE,       # average silhouette width
                ggtheme = theme_minimal(),
                color = "cluster")




#HIRERARCHICAL-CURE
# Clean data
composite_cleaned <- composite_normalized %>%
  select(median_age, median_income,
         poverty_10000, cases_per_10000, deaths_per_10000) %>%
  drop_na()

# Scale data and create distance matrix
clustering_scaled <- scale(composite_cleaned)
dist_matrix <- dist(clustering_scaled)

# Hierarchical clustering
hc <- hclust(dist_matrix, method = "ward.D2")
clusters_cure <- cutree(hc, k = 3)  # Numeric vector of cluster labels

# Now silhouette will work
sil_cure_poverty <- silhouette(clusters_cure, dist_matrix)

# Plot

fviz_silhouette(sil_cure_poverty,
                palette = "Set1",
                print.summary = TRUE,
                ggtheme = theme_minimal(),
                color = "cluster")



#DBSCAN - not enough clustered points, will not work

#########################################################

#### SILHOUETTE ANLAYSIS FOR DEMOMOBILITY ###

#KMEANS
# Step 1: K-means clustering on cleaned data
set.seed(123)
km <- kmeans(composite_scaled_demomobility_clean, centers = 3, nstart = 25)

# Step 3: Recreate distance matrix from the exact same cleaned data
dist_matrix_demomob <- dist(composite_scaled_demomobility_clean)

# Step 4: Compute silhouette object
sil_demomob_kmeans <- silhouette(km$cluster, dist_matrix_demomob)

# Step 5: Plot silhouette
fviz_silhouette(sil_demomob_kmeans,
                palette = "Set1",
                print.summary = TRUE,
                ggtheme = theme_minimal(),
                color = "cluster")

#HIRERARCHICAL
# Step 1: Compute silhouette object
sil_demomobility_hier <- silhouette(clusters, distance_matrix)

# Step 2: ggplot-style plot with summary
fviz_silhouette(sil_demomobility_hier,
                palette = "Set1",          # Cluster color palette
                print.summary = TRUE,      # Shows average silhouette width
                ggtheme = theme_minimal(),
                color = "cluster")


#HIRERARCHICAL-CURE -- Cannot be computed because cluster count < 2


#DBSCAN- Not enough non-noise points or only one cluster — silhouette cannot be computed




#########################################################

#### SILHOUETTE ANLAYSIS FOR MOMOBILITY ###

#KMEANS
# Step 1: Recreate distance matrix from the cleaned data
dist_matrix_mobility <- dist(composite_scaled_mobility_clean)

# Step 2: Compute silhouette object
sil_mobility_kmeans <- silhouette(km$cluster, dist_matrix_mobility)
fviz_silhouette(sil_mobility_kmeans,
                palette = "Set1",           # Cluster color palette
                print.summary = TRUE,       # Shows average silhouette width
                ggtheme = theme_minimal(),
                color = "cluster")



#HIRERARCHICAL
# Step 1: Compute silhouette object
sil_mobility_hier <- silhouette(clusters, dist(distance_matrix))  # or just use: silhouette(clusters, distance_matrix)


# Step 2: ggplot-style plot with factoextra
fviz_silhouette(sil_mobility_hier,
                palette = "Set1",
                print.summary = TRUE,
                ggtheme = theme_minimal(),
                color = "cluster")


##HIRERARCHICAL-CURE -  Cannot be computed because cluster count < 2


##DBSCAN- Silhouette can't be computed: too few clusters or only noise.


################## SUPERVISED EVALUATION ##################
##supervised cluster evaluation uses ground truth information- gives us an idea
#on how the data should be grouped

### SET UP


# Evaluation functions
purity <- function(cluster, truth, show_table = FALSE) {
  if (length(cluster) != length(truth)) stop("Cluster and truth lengths differ.")
  tbl <- table(cluster, truth)
  if (show_table) print(tbl)
  majority <- apply(tbl, 1, max)
  sum(majority) / length(cluster)
}

entropy <- function(cluster, truth, show_table = FALSE) {
  if (length(cluster) != length(truth)) stop("Cluster and truth lengths differ.")
  tbl <- table(cluster, truth)
  p <- sweep(tbl, 2, colSums(tbl), "/")
  if (show_table) print(p)
  e <- -p * log(p, 2)
  e <- rowSums(e, na.rm = TRUE)
  w <- table(cluster) / length(cluster)
  sum(w * e)
}

evaluate_clustering <- function(data, truth, km_k = 3, hier_k = 3, db_eps = 1.5, db_minPts = 5, subset_name = "Subset") {
  results <- list()
  d <- dist(data)
  
  # K-means
  km <- kmeans(data, centers = km_k, nstart = 25)
  results$KMeans <- c(
    ARI = adjustedRandIndex(km$cluster, truth),
    Purity = purity(km$cluster, truth),
    Entropy = entropy(km$cluster, truth)
  )
  
  # Hierarchical
  hc <- hclust(d, method = "ward.D2")
  hc_cut <- cutree(hc, k = hier_k)
  results$Hierarchical <- c(
    ARI = adjustedRandIndex(hc_cut, truth),
    Purity = purity(hc_cut, truth),
    Entropy = entropy(hc_cut, truth)
  )
  
  # CURE (simulated with hclust)
  results$CURE <- c(
    ARI = adjustedRandIndex(hc_cut, truth),
    Purity = purity(hc_cut, truth),
    Entropy = entropy(hc_cut, truth)
  )
  
  # DBSCAN
  db <- db <- dbscan::dbscan(data, eps = db_eps, minPts = db_minPts)
  db_labels <- db$cluster
  valid <- db_labels != 0
  if (sum(valid) > 0 && length(unique(db_labels[valid])) > 1) {
    results$DBSCAN <- c(
      ARI = adjustedRandIndex(db_labels[valid], truth[valid]),
      Purity = purity(db_labels[valid], truth[valid]),
      Entropy = entropy(db_labels[valid], truth[valid])
    )
  } else {
    results$DBSCAN <- c(ARI = NA, Purity = NA, Entropy = NA)
  }
  
  return(bind_rows(results, .id = "Method") %>% mutate(Subset = subset_name))
}


##HOUSEHOLDS
house <- composite_normalized %>%
  mutate(severity = cut(death_per_case, breaks = quantile(death_per_case, probs = c(0, 1/3, 2/3, 1), na.rm = TRUE),
                        labels = c("Low", "Medium", "High"), include.lowest = TRUE)) %>%
  select(median_income, median_age, nonfamily_households_10000, family_households_10000, cases_per_10000, deaths_per_10000, severity) %>%
  drop_na()

house_result <- evaluate_clustering(
  data = scale(house %>% select(-severity)),
  truth = house$severity,
  km_k = 3, hier_k = 3, db_eps = 2.2, db_minPts = 7,
  subset_name = "Households"
)


##POVERTY
poverty <- composite_normalized %>%
  mutate(severity = cut(death_per_case, breaks = quantile(death_per_case, probs = c(0, 1/3, 2/3, 1), na.rm = TRUE),
                        labels = c("Low", "Medium", "High"), include.lowest = TRUE)) %>%
  select(median_income, median_age, poverty_10000, cases_per_10000, deaths_per_10000, severity) %>%
  drop_na()

poverty_result <- evaluate_clustering(
  data = scale(poverty %>% select(-severity)),
  truth = poverty$severity,
  km_k = 3, hier_k = 3, db_eps = 1.4, db_minPts = 6,
  subset_name = "Poverty"
)


##DEMOMOBILITY
demomob <- composite_normalized %>%
  mutate(severity = cut(death_per_case, breaks = quantile(death_per_case, probs = c(0, 1/3, 2/3, 1), na.rm = TRUE),
                        labels = c("Low", "Medium", "High"), include.lowest = TRUE)) %>%
  select(median_income, median_age,
         retail_and_recreation_percent_change_from_baseline,
         grocery_and_pharmacy_percent_change_from_baseline,
         workplaces_percent_change_from_baseline,
         residential_percent_change_from_baseline,
         cases_per_10000, deaths_per_10000, severity) %>%
  drop_na()

demomob_result <- evaluate_clustering(
  data = scale(demomob %>% select(-severity)),
  truth = demomob$severity,
  km_k = 3, hier_k = 3, db_eps = 3.3, db_minPts = 9,
  subset_name = "Demomobility"
)


#MOBILITY
mobility <- composite_normalized %>%
  mutate(severity = cut(death_per_case, breaks = quantile(death_per_case, probs = c(0, 1/3, 2/3, 1), na.rm = TRUE),
                        labels = c("Low", "Medium", "High"), include.lowest = TRUE)) %>%
  select(retail_and_recreation_percent_change_from_baseline,
         grocery_and_pharmacy_percent_change_from_baseline,
         workplaces_percent_change_from_baseline,
         residential_percent_change_from_baseline,
         cases_per_10000, deaths_per_10000, severity) %>%
  drop_na()

mobility_result <- evaluate_clustering(
  data = scale(mobility %>% select(-severity)),
  truth = mobility$severity,
  km_k = 3, hier_k = 3, db_eps = 1.9, db_minPts = 7,
  subset_name = "Mobility"
)

#RESULTS
all_results <- bind_rows(house_result, poverty_result, demomob_result, mobility_result)
print(all_results)

all_results_rounded <- all_results %>%
  mutate(across(c(ARI, Purity, Entropy), ~ round(as.numeric(.), 3)))

all_results_rounded <- all_results %>%
  mutate(across(c(ARI, Purity, Entropy), ~ round(as.numeric(.), 3)))

# Save as HTML table
kable(all_results_rounded, format = "html", caption = "Supervised Clustering Evaluation") %>%
  cat(file = "clustering_results_static.html")




# Optional plot
ggplot(all_results, aes(x = Method, y = ARI, fill = Method)) +
  geom_bar(stat = "identity") +
  facet_wrap(~Subset) +
  labs(title = "Adjusted Rand Index (ARI) by Clustering Method and Subset") +
  theme_minimal()



 
