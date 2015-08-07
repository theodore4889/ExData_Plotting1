# Specify directory location and file name for data set
file_nm <- "household_power_consumption.txt"

# Read in data.  Since the file is huge, I visually inspected the file to find
#  the last row we need to read in (the last entry for 2007-02-02).
#  Unfortunately, the "skip" condition for read.table will also skip the header,
#  So I was unable to filter the data for dates before 2007-02-01.
hpc_data <- read.table(file_nm, 
                       sep=";",
                       blank.lines.skip=TRUE,
                       na.strings="?",
                       header=TRUE, 
                       nrows=69516)

# Load the dplyr library so we can use its nifty functions
library(dplyr)

# Convert the date column from characters to dates
hpc_data <- mutate(hpc_data, Date=as.Date(Date, "%d/%m/%Y"))

# Filter out dates < 2007-02-01 and dates > 2007-02-02
hpc_data <- filter(hpc_data,
                   Date >= as.Date("2007-02-01", "%Y-%m-%d") 
                   & Date <= as.Date("2007-02-02", "%Y-%m-%d"))

# Create new column that combines date and time
hpc_data$DateTime <- strptime(paste(format(hpc_data$Date, "%Y-%m-%d"), hpc_data$Time), "%Y-%m-%d %H:%M:%S")

library(datasets)

# Plot 3
png(
  "plot3.png",
  width     = 480,
  height    = 480,
  units     = "px"
)

lab_esm = "Energy sub metering"
plot(c(hpc_data$DateTime, hpc_data$DateTime, hpc_data$DateTime), c(hpc_data$Sub_metering_1, hpc_data$Sub_metering_2, hpc_data$Sub_metering_3), type="n", xlab="", ylab=lab_esm)
lines(hpc_data$DateTime, hpc_data$Sub_metering_1)
lines(hpc_data$DateTime, hpc_data$Sub_metering_2, col="red")
lines(hpc_data$DateTime, hpc_data$Sub_metering_3, col="blue")
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=c(1,1,1), col=c("black", "red", "blue"))

dev.off()