#  working directory ...
setwd('C:/Users/roberto/Desktop/iconos/DataScience_and_Analysis/4_ExploratoryDataAnalysis/exdata-data-household_power_consumption')

# plots folder...  only 8 files requested.... simplify
#if (!file.exists('DataPlots')) {
#  dir.create('DataPlots')
#}
# my current working directory 
setwd('C:/Users/roberto/Desktop/iconos/DataScience_and_Analysis/4_ExploratoryDataAnalysis/exdata-data-household_power_consumption')

# the packages we'll need
library(data.table)
library(lubridate)

# get the data and extract the 2 needed dates
if (!file.exists('household_power_consumption.txt')) {
  
  # download the zip file and unzip
  file.url<-'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
  download.file(file.url,destfile='data.zip')
  unzip('data.zip',overwrite=TRUE)
  
  # read the raw table, extract 2 days, define a file 'epUsed', electrical power used or consumed
  variable.class<-c(rep('character',2),rep('numeric',7))
  epUsed<-read.table('household_power_consumption.txt',header=TRUE,
                     sep=';',na.strings='?',colClasses=variable.class)
  epUsed<-epUsed[epUsed$Date=='1/2/2007' | epUsed$Date=='2/2/2007',]
  
  # clean up the variable names and convert date/time fields
  cols<-c('Date','Time','GlobalActivePower','GlobalReactivePower','Voltage','GlobalIntensity',
          'SubMetering1','SubMetering2','SubMetering3')
  colnames(epUsed)<-cols
  epUsed$DateTime<-dmy(epUsed$Date)+hms(epUsed$Time)
  epUsed<-epUsed[,c(10,3:9)]
  
  # write a clean data set to the directory
  write.table(epUsed,file='data.txt',sep='|',row.names=FALSE)
} else {
  
  epUsed<-read.table('data',header=TRUE,sep='|')
  epUsed$DateTime<-as.POSIXlt(epUsed$DateTime)
  
}
# remove the large raw data set 
if (file.exists('household_power_consumption.txt')) {
  x<-file.remove('household_power_consumption.txt')
}

# open device
png(filename='plot2.png',width=480,height=480,units='px')

# plot data
plot(epUsed$DateTime,epUsed$GlobalActivePower,ylab='Global Active Power (kilowatts)', xlab='', type='l')

# close device
x<-dev.off()