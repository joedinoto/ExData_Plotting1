# Load libraries 
library(data.table)
library(tidyverse)
library(lubridate)
library(dplyr)

# Read the table
class <- c("date","date", repeat(7,"numeric"))
household <- fread("household_power_consumption.txt",colClasses = class)%>%
  as_tibble()
# Merge date and time columns as single column formatted as POSIXlt
household <- mutate(household, DateTime = paste(Date,Time, sep=" "))
household$DateTime <- dmy_hms(household$DateTime)

# Filter the dates to 2007-02-01 and 2007-02-02 only.
# https://www.earthdatascience.org/courses/earth-analytics/time-series-data/subset-time-series-data-in-r/
household <- filter(household,DateTime< as.Date("2007-02-03 00:00:00") & DateTime > as.Date("2007-02-01 00:00:00"))

# Write to CSV (for reference)
write.csv(household, file = "household.csv")

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