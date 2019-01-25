library(dplyr)
library(data.table)
library(ggplot2)
fileUrl="https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileUrl,destfile="exdata%2Fdata%2FNEI_data.zip",mode="wb")
unzip(zipfile="exdata%2Fdata%2FNEI_data.zip")

##reading files using readRDS
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

##converting NEI to data .table
NEI<-as.data.table(NEI)

view(NEI)

##extract data for baltimore city from NEI and assign to variable summarized.year.type
summarized.year.type<-NEI[fips=="24510",]

##create plot
png("plot3.png",width=560,heigth=480)

ggplot(summarized.year.type,aes(x=factor(year),y=Emissions,fill=type))+geom_bar(stat="identity")+facet_grid(.~type)+ggtitle("Emissions from 1999-2008 for Baltimore City")+xlab("year")+ylab("Emissions ")

dev.off()