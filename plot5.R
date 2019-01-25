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
##converting SCC to data .table
SCC<-as.data.table(SCC)

##find the rows which has motor Vehicle emission data
SCC_motor_vehicle_grepl<-grepl("Mobile.*Vehicles",SCC$EI.Sector)

##get the rows with motor vehicles and assign it to SCC_motor_vehicle_data
SCC_motor_vehicle_data<-SCC[,SCC_motor_vehicle_grepl]

##finding the corresponding motor_vehicle related in NEI and assign it to 
##NEI_motor_vehicle_related
NEI_motor_vehicle_related<-NEI[NEI$SCC %in% SCC_motor_vehicle_data$SCC,]

## Find the data only for Baltimore city from NEI_motor_vehicle_related

NEI_motor_vehicle_related_baltimore_city<-NEI_motor_vehicle_related[fips=="24510",]

##create a plot
png("plot5.png")

ggplot(NEI_motor_vehicle_related_baltimore_city,aes(x=factor(year),y=Emissions))+geom_bar(stat="identity",aes(fill=year))+xlab("year")+ylab("Emissions")+ggtitle("Emissions related to motor vehicles in Baltimore City from 1999-2008")

dev.off()
