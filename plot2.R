library(data.table)
library(dplyr)

# Download end extract the data
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zipfile <- "household_power_consumption.zip"
txtfile <- "household_power_consumption.txt"
download.file(fileUrl,destfile=zipfile,method="curl")
unzip(zipfile, files=txtfile, overwrite=TRUE)

# Load the data into memory
colclasses <- c("factor", "factor", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric")
fulldata <- read.table(txtfile, header = TRUE, sep=";", colClasses = colclasses, na.strings = "?")

#filter only the data for the two days we need.
data <- filter(fulldata, Date == "1/2/2007" | Date == "2/2/2007")

# Reclaim the memory for the full data
rm(fulldata)

# Merge the date and time to a new column.
data$DateTime <- strptime( paste(data$Date, data$Time), format = "%d/%m/%Y %H:%M:%S")
# Make sure the dates are printed as expected.
Sys.setlocale("LC_TIME", "English")

# Do plot 2
png(filename="plot2.png", width = 480, height = 480)
with(data, plot(DateTime, Global_active_power, type="l", ylab="Global Active Power (kilowatts)", xlab=""))
dev.off()
