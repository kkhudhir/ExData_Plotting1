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
png(file='plot4.png') # this one doesn't copy well, so we write directly to the png graphics device from the get-go
par(mfrow=c(2,2))

# upper left
plot(data$dt, data$Global_active_power, type='l', ylab='Global Active Power', xlab='', cex.lab=.9)

# upper right
plot(data$dt, data$Voltage, type='l', ylab='Voltage', xlab='datetime', cex.lab=.9)

# lower left
plot(data$dt, data$Sub_metering_1, type='l', ylab='Energy sub metering', xlab='', cex.lab=.9)
lines(data$dt, data$Sub_metering_2, type='l', col='red')
lines(data$dt, data$Sub_metering_3, type='l', col='blue')
legend(x='topright', legend=c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3'), lty=1, col=c('black', 'red', 'blue'), cex=.9, box.lty=0, inset=.02)

# lower right
plot(data$dt, data$Global_reactive_power, type='l', cex.lab=.9 , ylab='Global_reactive_power', xlab='datetime')

#dev.copy(png, file='plot4.png') # get overall shape right, then comment out and swap to the png-direct row above
dev.off()
