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

# Filter the dates to 2007-02-01 and 2007-02-02 only.
# https://www.earthdatascience.org/courses/earth-analytics/time-series-data/subset-time-series-data-in-r/
household <- filter(household,DateTime< as.Date("2007-02-03 00:00:00") & DateTime > as.Date("2007-02-01 00:00:00"))

#  assign column variable types
household$Date <- dmy(household$Date)
household$Time <- hms(household$Time)
household$Global_active_power <- as.numeric(household$Global_active_power)
household$Global_reactive_power <- as.numeric(household$Global_reactive_power)
household$Voltage <- as.numeric(household$Voltage)
household$Global_intensity <- as.numeric(household$Global_intensity)
household$Sub_metering_1 <- as.numeric(household$Sub_metering_2)
household$Sub_metering_2 <- as.numeric(household$Sub_metering_2)

# Plot1 -- Histogram
with(household, hist(Global_active_power, 
                     col="red",
                     xlab="Global Active Power (killowatts)",
                     main="Global Active Power")
     )
# Making a PNG
# Warning - plot in the output copy may not look exactly like plot on screen!

dev.copy(png,file="Plot1.png") # open graphics device
dev.off() #close graphics device

# Other notes

#http://rfunction.com/archives/1912
#strptime() and as.Date()