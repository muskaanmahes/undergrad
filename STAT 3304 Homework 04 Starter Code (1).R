############################## STAT 3304 Homework 04 Starter Code #################################

# Include the following libraries
library(tidyverse) ## includes the readr library (it is part of tidyverse)
library(readr)     ## includes read_csv()  read_tsv()  read_table()  ######### package for reading CSV (and other data types) ############
library(readxl)    ## includes read_excel() and read_xlsx()   ############ package for reading XLSX ##############
library(openxlsx)  ## includes read.xlsx() and write.xlsx()   ######### package for reading and writing XLSX ############


# Set your working directory to your SASDATA folder

setwd("___________")

# Read either the file "OLYMPICS_athlete_events.csv" or the file "OLYMPICS_athlete_events.xlsx"




# Create a subset dataset from the Olympics dataset, including only the years from 1994 onward:


# Use write.xlsx to save this data as an XLSX file in your "R data" folder (i.e.first "change" your directory with setwd() and then write)



# Using Excel, open your saved Excel file, and edit the Sheet name from "Sheet1" to "Olympics 1994-2016" 
# After saving the edit to your XLSX file, then read it back into R using the new sheet name



## Section 2  -  CSV files


# Unique Country Names:  Run this code to look at all the distinct Country (Team) names in the Olympics dataset

Teams <- Olympics %>% select(Country) %>%
  distinct() %>%
  arrange(Country)

# How many distinct Team names are there?


# A visual review of this table gives us an idea of what country names need to be fixed
# But we can take a systematic approach to find out as well...

# Install the package stringr, and attach the library, in order to run the following cleanup code for Olympics country names
library(stringr)
library(dplyr)

# Country name_type Counts:  Run this code on the Olympics dataset to view unique Country names (which may need to be fixed)

# This produces a table of how many levels of Country-1, Country-2, etc.... need to be corrected (what is the maximum?)
Olympics_fix_count <- Olympics %>% 
  mutate(name_type=ifelse(str_detect(Country,"-1")==TRUE,"Country-1",
                          ifelse(str_detect(Country,"-2")==TRUE,"Country-2",
                                 ifelse(str_detect(Country,"-3")==TRUE,"Country-3",
                                        ifelse(str_detect(Country,"-4")==TRUE,"Country-4",
                                               ifelse(str_detect(Country,"-5")==TRUE,"Country-5","Country")))))) %>%
  group_by(name_type) %>%
  summarize(N=n())

# We counted as far as Country-5 in the code above, but what do the results tell us?  What is the most number of replicate names for any country?


# Fix1: Country Names:  Run the following code to replace all the "-1", "-2", etc, with "" (essentially remove those tags from the Country names)
Olympics_fix1 <- Olympics %>%
  mutate(Country=ifelse(str_detect(Country,"-1")==TRUE,str_replace(Country,"-1",""),Country)) %>%
  mutate(Country=ifelse(str_detect(Country,"-2")==TRUE,str_replace(Country,"-2",""),Country)) %>%
  mutate(Country=ifelse(str_detect(Country,"-3")==TRUE,str_replace(Country,"-3",""),Country)) %>%
  mutate(Country=ifelse(str_detect(Country,"-4")==TRUE,str_replace(Country,"-4",""),Country)) %>%
  mutate(Country=ifelse(str_detect(Country,"-5")==TRUE,str_replace(Country,"-5",""),Country))


# Run this code, to again look at all the distinct team names in the Olympics dataset (now that we fixed them)

Teams <- Olympics_fix1 %>% select(Country) %>%
  distinct() %>%
  arrange(Country)

# Now how many distinct Team names are there?




# Part 2:  Read the Gapworld CSV data tables downloaded from Canvas "R data" folder




# Start with Countries and Left join with Population, left join with GDP, and left join with LifeExpectancy
# to create countries_data.  Also rename time to be Year, and filter by Year to only keep the years  that match the Olympics data years (1994 onward)

countries_data <- Countries %>%
  left_join(_________) %>%
  rename(_______) %>%
  filter(Year >= 1994) %>%
  # Countries Data stops at 2015, Olympics stops at 2016 -> replace 2015 with 2016 in Countries data 
  mutate(Year=ifelse(Year==2015,2016,Year))


# Missing population counts: Run this code to find the number of missing values for the variable Population ... for each country and each year

count_na_byyear <- countries_data %>%
  group_by(Year) %>%
  summarize(na_pop=sum(is.na(population_total)))


# Now prepare to merge this country data with the Olympics data.
# Start with Olympics_fixed, and left join with countries_data 

Olympics_all <- Olympics_fix1 %>%
  full_join(countries_data,by=c("Country","Year"))


# Fix2: Rename countries in Olympics (to newest names in Countries_data) after manually aligning:

Olympics_fix2 <- Olympics_fix1 %>%
  mutate(Country=ifelse(Country=="Congo (Kinshasa)","Congo, Dem. Rep.",Country)) %>%
  mutate(Country=ifelse(Country=="Congo (Brazzaville)","Congo, Rep.",Country)) %>%
  mutate(Country=ifelse(Country=="Federated States of Micronesia","Micronesia, Fed. Sts.",Country)) %>%
  mutate(Country=ifelse(Country=="Guinea Bissau","Guinea-Bissau",Country)) %>%
  mutate(Country=ifelse(Country=="Kyrgyzstan","Kyrgyz Republic",Country)) %>%
  mutate(Country=ifelse(Country=="Macedonia","North Macedonia",Country)) %>%                                                                                                                
  mutate(Country=ifelse(Country=="Slovakia","Slovak Republic",Country)) %>%
  mutate(Country=ifelse(Country=="Saint Kitts and Nevis","St. Kitts and Nevis",Country)) %>%
  mutate(Country=ifelse(Country=="Saint Lucia","St. Lucia",Country)) %>%
  mutate(Country=ifelse(Country=="Saint Vincent and the Grenadines","St. Vincent and the Grenadines",Country)) %>%
  mutate(Country=ifelse(Country=="Chinese Taipei","Taiwan",Country)) %>%
  mutate(Country=ifelse(Country=="Timor Leste","Timor-Leste",Country)) %>%
  mutate(Country=ifelse(Country=="United States Virgin Islands","Virgin Islands (U.S.)",Country))


# Fix3: Rename countries in Countries_data (to correct names in Olympics) after manually aligning:

countries_data_fix3 <- countries_data %>%
  mutate(Country=ifelse(Country=="Cook Is","Cook Islands",Country)) %>%
  mutate(Country=ifelse(Country=="Eswatini","Swaziland",Country)) %>%
  mutate(Country=ifelse(Country=="UK","Great Britain",Country)) %>%
  mutate(Country=ifelse(Country=="Hong Kong, China","Hong Kong",Country)) %>%
  mutate(Country=ifelse(Country=="Lao","Laos",Country)) %>%
  mutate(Country=ifelse(Country=="USA","United States",Country)) %>%
  mutate(Country=ifelse(Country=="UAE","United Arab Emirates",Country))


# Merge: Final Data
# Now prepare to merge this country data with the Olympics data.
# Start with the fixed Olympics_fix2 data, and left join with fixed countries_data_fix3 data
# Left_join by both Country and Year

Olympics_final <- Olympics_fix2 %>%
  left_join(countries_data_fix3,by=c("Country","Year")) %>%
  mutate(Medal_yes_no=ifelse(is.na(Medal),"No Medal","Medal"))

# Medals By Year:
Medals_byyear <- Olympics_final %>%
  group_by(Country,Season,Year) %>%
  summarize(Medal_count=(sum(!is.na(Medal))))

# Medals By Year Per Capita:
Medals_byyear_pcap <- Medals_byyear %>%
  inner_join(countries_data_fix3, by=c("Country","Year")) %>%
  mutate(Medals_per_capita=Medal_count/population_total)

