## Data from https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip

## Check if the data file is in the working directory
dataFile <- "household_power_consumption.txt"
if (!file.exists(dataFile)) {
        errorMessage <- sprintf("This script requires the file '%s' to be in the working directory.", 
                                dataFile)
        stop(errorMessage)
}

library(readr)
library(dplyr)
library(lubridate)
library(tidyr)

## Load the data file, 
## combine the date and time variables into a date/time variable,
## and subset the data to 1-2 February 2007
allData <- read_csv2(dataFile, na = '?') %>%
        unite(DateTime, Date, Time, sep = " ") %>%
        mutate(DateTime = dmy_hms(DateTime)) %>%
        filter(DateTime >= dmy("1 February 2007"), 
               DateTime < dmy("3 February 2007"))

## Check for missing data values
if (all(colSums(is.na(allData)) != 0)) {
        print(sprintf("%s has missing data values\n", dataFile))
}

library(graphics)
library(grDevices)

## Set up PNG output device for 2 rows and 2 columns of small plots
png("plot4.png")
par(mfrow = c(2, 2))

## Create plot 1
plot(allData$DateTime, allData$Global_active_power, xlab = "", 
     ylab = "Global Active Power", type = 'l')

## Create plot 2
plot(allData$DateTime, allData$Voltage, xlab = "datetime", ylab = "Voltage", 
     type = 'l')

## Create plot 3
plot(allData$DateTime, allData$Sub_metering_1, xlab = "", 
     ylab = "Energy sub metering", type = 'l')
lines(allData$DateTime, allData$Sub_metering_2, col = "red")
lines(allData$DateTime, allData$Sub_metering_3, col = "blue")
legend("topright", col = c("black", "red", "blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       lty = 1, bty = "n")

## Create plot 4
plot(allData$DateTime, allData$Global_reactive_power, xlab = "datetime", ylab = "Global_reactive_power", 
     type = 'l')

## Close the PNG output device
dev.off()
