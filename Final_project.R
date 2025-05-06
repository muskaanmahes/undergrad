library(tidyverse)
library(lubridate)
library(astsa)
library(tswge)
library(forecast)
setwd("/Users/muskaanmahes/Desktop/Stat 4363")
climate = read.csv("global_temp.csv", skip =4, header =FALSE)
save(climate, file = "climate.RData")
#plotting the time series
climate <- climate[-1, ]  # drop the row with "Year" and "Anomaly"

# Rename and convert types
climate <- climate %>%
  rename(Year = V1, Anomaly = V2) %>%
  mutate(
    Year = as.numeric(Year),
    Anomaly = as.numeric(Anomaly)
  )

# Create time series object
climate_ts <- ts(data = climate$Anomaly, start = min(climate$Year), frequency = 1)


climate_ts <- ts(data = climate$Anomaly, start = 1850, end = 2025, frequency = 1)


plotts.wge(climate_ts, style =1, xlab = "Time", ylab = "Temperature Anomalies")

years <- c(1850:2025)
plot.ts(climate_ts, xlab="Year", ylab="Temp Anomalies", main = "Figure 1: Southern Hemisphere Temperature Anomalies (1850–2025)")




#ACF
acf(climate_ts, lag.max = 100, main = "Figure 2: ACF of Temperature Anomalies")

#difference 
diff_acf <- diff(climate_ts)
acf(diff_acf, lag.max = 100, main = "Figure 3: ACF of Differenced Series")



#PACF

pacf(climate_ts, lag.max = 100, main = "Figure 4: PACF of Temperature Anomalies")


#spectral Density
parzen.wge(climate_ts)
title(sub = "Figure 5")


# Fit the best ARMA model 
aic5.wge(diff_ts, p=0:5, q=0:5)



# Fit and SARIMA Model
sarima(climate_ts, p=5, d=1, q=4, seasonal=FALSE)
sarima(climate_ts, p=1, d=1, q=2, seasonal=FALSE)

# Forecast 
sarima.for(climate_ts, n.ahead = 10, p = 2, d = 1, q= 2, P = 0 , D=0, Q=0, S=0)





