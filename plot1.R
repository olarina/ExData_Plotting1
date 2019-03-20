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

## Creates histogram
png(filename = "plot1.png", width = 480, height = 480)
hist(data$Global_active_power, col = "red", xlab = "Global Active Power (kilowatts)",
     main="Global Active Power")
dev.off()
