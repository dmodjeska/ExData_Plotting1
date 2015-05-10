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
png("plot2.png")

## Create plot 2
plot(allData$DateTime, allData$Global_active_power, xlab = "", 
     ylab = "Global Active Power (kilowatts)", type = 'l')

## Close the PNG output device
dev.off()
