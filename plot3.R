## Data from https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip

## Load the data if the file is in the working directory
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

## Set up PNG output device
png("plot3.png")

## Create plot 3
plot(allData$DateTime, allData$Sub_metering_1, xlab = "", 
     ylab = "Energy sub metering", type = 'l')
lines(allData$DateTime, allData$Sub_metering_2, col = "red")
lines(allData$DateTime, allData$Sub_metering_3, col = "blue")
legend("topright", col = c("black", "red", "blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       lty = 1)

## Close the PNG output device
dev.off()
