library(sqldf)
## Gets data file if it's not downloaded yet
if(!file.exists("./data"))
{
    dir.create("./data")
}
if (!file.exists("./data/household_power_consumption.txt")){
    fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(fileUrl, destfile="./data/dataset.zip", method="curl")
    unzip("./data/dataset.zip",exdir="./data")   
}
## Loads subset into R
data <- read.csv2.sql("./data/household_power_consumption.txt", 
                      sql = "select * from file where Date = '1/2/2007' OR
                      Date = '2/2/2007'", eol = "\n")
## Converts time and date
data$Time <- strptime(paste(data$Date,data$Time), "%d/%m/%Y %H:%M:%OS")
data$Date <- as.Date(data$Date,tryFormats = "%d/%m/%Y")

## Creates plot
png(filename = "plot4.png", width = 480, height = 480)
par(mfrow = c(2,2))
plot(data$Time, data$Global_active_power, type="n",
     xlab="", ylab = "Global Active Power")
lines(data$Time, data$Global_active_power)

plot(data$Time,data$Voltage, type="n",
     xlab="datetime", ylab = "Voltage")
lines(data$Time,data$Voltage)

plot(data$Time, data$Sub_metering_1, type="n",
     xlab="", ylab = "Enegy Sub Metering")
lines(data$Time, data$Sub_metering_1,col="black")
lines(data$Time, data$Sub_metering_2,col="red")
lines(data$Time, data$Sub_metering_3,col="blue")
legend("topright", lty = 1, col = c("black","red","blue"), bty = "n",##No box
       inset=c(0.01, 0.01),## Steps from margins
       legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))

plot(data$Time, data$Global_reactive_power, type="n",
     xlab="datetime", ylab="Global_reactive_power")
lines(data$Time, data$Global_reactive_power)
dev.off()