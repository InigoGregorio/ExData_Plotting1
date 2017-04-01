# R Script to download, subset and plot data
# of Global Active Power
# from Individual household electric power consumption Data Set
# in UC Irvine Machine Learning Repository

## Load packages needed
library(data.table)
library(dtplyr)

## Download data
fileurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
if(!file.exists("exdata_data_household_power_consumption.zip")) {
    file.create("exdata_data_household_power_consumption.zip")
    download.file(fileurl, "exdata_data_household_power_consumption.zip")
    unzip("exdata_data_household_power_consumption.zip")
}
filename <- "household_power_consumption.txt"

## Read full data set and format date and time
dataSet <- fread(filename, header = TRUE, sep = ';', na.strings = '?')
dataSet$Date <- as.Date(dataSet$Date, format = "%d/%m/%Y")

## Subset data to first two days of February, 2007
energyData <- dataSet[Date >= as.Date("01/02/2007", format = "%d/%m/%Y") & Date <= as.Date("02/02/2007", format = "%d/%m/%Y")]

## Format data Time
energyData$Time <- as.POSIXct(paste(energyData$Date, energyData$Time))

## Create png file
png(file = "plot3.png", height = 480, width = 480)

## Plot data as determined
with(energyData, {
    plot(Sub_metering_1 ~ Time, col = "Black", type = "l", xlab = "", ylab = "Energy sub metering")
    lines(Sub_metering_2 ~ Time, col = "Red")
    lines(Sub_metering_3 ~ Time, col = "Blue")
}) 
legend("topright", col = c("Black", "Red", "Blue"), lty=1, lwd=2, legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))


## Draw plot into a png file
dev.off()
