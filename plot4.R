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

# Do plot 4
png(filename="plot4.png", width = 480, height = 480)
par(mfrow=c(2,2))

with(data, plot(DateTime, Global_active_power, type="l", ylab="Global Active Power", xlab=""))

with(data, plot(DateTime, Voltage, type="l", ylab="Voltage", xlab="datetime"))

with(data, plot(DateTime, Sub_metering_1, type="l", ylab="Energy sub metering", xlab="", col="black"))
with(data, lines(DateTime, Sub_metering_2, col="red"))
with(data, lines(DateTime, Sub_metering_3, col="blue"))
legend("topright", 
       col = c("black", "red", "blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       lty=1, lwd=2.5, bg="transparent", box.col="transparent", cex=1.1)

with(data, plot(DateTime, Global_reactive_power, type="l", ylab="Global_reactive_power", xlab="datetime"))

dev.off()
