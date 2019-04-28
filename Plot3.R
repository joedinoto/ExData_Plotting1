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

# Plot 3 - three line graphs
# https://www.coursera.org/learn/exploratory-data-analysis/discussions/weeks/1/threads/h7zoxKBJEeaWGQ4arwmx_A
# "Why are my titles cut off?" - use png() instead of dev.copy(png,...)

# step 1 open png() device
dev.print(png, file = "Plot3.png", width = 1024, height = 768)
png(file = "Plot3.png", bg = "transparent")
# step 2 plot the function
xrange<- range(household$DateTime)
yrange<- range(household$Sub_metering_1)
plot(xrange, yrange, type="n", xlab="", ylab="Energy Sub metering" ) 
with(household,lines(DateTime,Sub_metering_1))
with(household,lines(DateTime,Sub_metering_2,col="red"))
with(household,lines(DateTime,Sub_metering_3,col="blue"))
legend("topright", lty=1, col = c("black","red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
# step 3 close the png() device
dev.off()