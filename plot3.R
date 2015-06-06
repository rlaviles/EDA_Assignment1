# working directory 
setwd('C:/Users/roberto/Desktop/iconos/DataScience_and_Analysis/4_ExploratoryDataAnalysis/exdata-data-household_power_consumption')

# plots folder ...
#if (!file.exists('DataPlots')) {
#  dir.create('DataPlots')
#}

# load the data; because homework request only the 4 plots R scripts
# we add to every script the get and prepare data R script (redundant but...)
# it'd have been better, imho, to use...source('get_n_PrepData.R')... anyway..

# lines 13 to 51 purpose: to get and prepare the data for further plotting
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
png(filename='plot3.png',width=480,height=480,units='px')

# plot data
lncol<-c('black','red','blue')
lbls<-c('Sub_metering_1','Sub_metering_2','Sub_metering_3')
plot(epUsed$DateTime,epUsed$SubMetering1,type='l',col=lncol[1],xlab='',ylab='Energy sub metering')
lines(epUsed$DateTime,epUsed$SubMetering2,col=lncol[2])
lines(epUsed$DateTime,epUsed$SubMetering3,col=lncol[3])

# add legend
legend('topright',legend=lbls,col=lncol,lty='solid')

# close device
x<-dev.off()