# Load libraries 
library(data.table)
library(tidyverse)
library(lubridate)
library(dplyr)

# Read the table
household <- fread("household_power_consumption.txt")%>%
  as_tibble()
# Merge date and time columns as single column formatted as POSIXlt
household <- mutate(household, DateTime = paste(Date,Time, sep=" "))
household$DateTime <- dmy_hms(household$DateTime)

#  assign column variable types
household$Date <- dmy(household$Date)
household$Time <- hms(household$Time)
household$Global_active_power <- as.numeric(household$Global_active_power)
household$Global_reactive_power <- as.numeric(household$Global_reactive_power)
household$Voltage <- as.numeric(household$Voltage)
household$Global_intensity <- as.numeric(household$Global_intensity)
household$Sub_metering_1 <- as.numeric(household$Sub_metering_2)
household$Sub_metering_2 <- as.numeric(household$Sub_metering_2)

# Filter the dates to 2007-02-01 and 2007-02-02 only.
# https://www.earthdatascience.org/courses/earth-analytics/time-series-data/subset-time-series-data-in-r/
household_sub <- filter(household,DateTime< as.Date("2007-02-03 00:00:00") & DateTime > as.Date("2007-02-01 00:00:00"))

#http://rfunction.com/archives/1912
#strptime() and as.Date()

# dplyr to mutate 
household_sub %>%
  mutate(DayAndTime = paste(Date,Time,sep=" "))

# The Histogram
with(household_sub, hist(Global_active_power, col="red",xlab="Global Active Power (killowatts)"))

