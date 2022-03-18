library(lubridate)

# Run our data downloading and import when necessary
datapath <- 'data'
filepath <- 'data/household_power_consumption.txt'

if(!file.exists(datapath)){
        dir.create(datapath)
        setwd(datapath)
        download.file('https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip', 'data.zip')
        unzip('data.zip')
        setwd('..')
}
if(!exists('import')){
        import<-read.csv(file=filepath, header=TRUE, sep=';', na.strings='?', colClasses=c('character', 'character', 'numeric', 'numeric', 'numeric', 'numeric', 'numeric','numeric','numeric'))
}

# get to the data we care about
import$dt <- strptime(paste(import$Date, import$Time), format='%d/%m/%Y %H:%M:%S')
startdate <- as.Date('2007-02-01', format='%Y-%m-%d')
enddate <- as.Date('2007-02-03', format='%Y-%m-%d')
data <- import[(import$dt < enddate) & (import$dt >= startdate),]

# check if/where NAs are (uncomment--first shows how many in each col, second shows which rows...which are all empty rows)
# sapply(data, function(x) sum(is.na (x)))
# data[rowSums(is.na(data)) > 0,]

# clean it up:
data <- na.omit(data)

#start plotting
plot(data$dt, data$Global_active_power, type='l', ylab='Global Active Power (kilowatts)', xlab='')
dev.copy(png, file='plot2.png')
dev.off()
