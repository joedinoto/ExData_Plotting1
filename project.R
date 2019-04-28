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
# (really, I should do this when reading the .txt file)
household$Date <- dmy(household$Date)
household$Time <- hms(household$Time)
household$Global_active_power <- as.numeric(household$Global_active_power)
household$Global_reactive_power <- as.numeric(household$Global_reactive_power)
household$Voltage <- as.numeric(household$Voltage)
household$Global_intensity <- as.numeric(household$Global_intensity)
household$Sub_metering_1 <- as.numeric(household$Sub_metering_1)
household$Sub_metering_2 <- as.numeric(household$Sub_metering_2)
household$Sub_metering_3 <- as.numeric(household$Sub_metering_3)

# Write to CSV
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

# Plot 2 -- Global active power
with(household,plot(DateTime,Global_active_power,
                    type="l",
                    ylab="Global Active Power (kilowatts)",
                    xlab=""))

# Making a PNG
# Warning - plot in the output copy may not look exactly like plot on screen!
dev.copy(png,file="Plot2.png") # open graphics device
dev.off() #close graphics device


# Plot 3 - three line graphs
# set up the plot 
xrange<- range(household$DateTime)
yrange<- range(household$Sub_metering_1)
plot(xrange, yrange, type="n", xlab="", ylab="Energy Sub metering" ) 
with(household,lines(DateTime,Sub_metering_1))
with(household,lines(DateTime,Sub_metering_2,col="red"))
with(household,lines(DateTime,Sub_metering_3,col="blue"))
legend("topright", lty=1, col = c("black","red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))


# Making a PNG
# Warning - plot in the output copy may not look exactly like plot on screen!
dev.copy(png,file="Plot3.png") # open graphics device
dev.off() #close graphics device

# Plot 4 - 2x2 array
par(mfrow =c(2,2),mar = c(4, 4, 2, 1), oma = c(0, 0, 2, 0))
xrange<- range(household$DateTime)
yrange<- range(household$Sub_metering_1)
with(household,{
  plot(DateTime,Global_active_power,
       type="l",
       ylab="Global Active Power (kilowatts)",
       xlab="")
  plot(DateTime,Voltage,type="l")
plot(xrange, yrange, type="n", xlab="", ylab="Energy Sub metering" ) 
with(household,lines(DateTime,Sub_metering_1))
with(household,lines(DateTime,Sub_metering_2,col="red"))
with(household,lines(DateTime,Sub_metering_3,col="blue"))
legend("topright", lty=1, bty="n",col = c("black","red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
plot(DateTime,Global_reactive_power,type="l")
})

dev.copy(png,file="Plot4.png") # open graphics device
dev.off() #close graphics device

# Other notes

#http://rfunction.com/archives/1912
#strptime() and as.Date()
# https://www.statmethods.net/graphs/line.html for line plotting