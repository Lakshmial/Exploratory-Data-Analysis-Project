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


###Finding the emission related to motor vehicles for Baltimore City (fips=="24510")
## Find the data only for Baltimore city from NEI_motor_vehicle_related

NEI_motor_vehicle_related_baltimore_city<-NEI_motor_vehicle_related[fips=="24510",]

##Adding another column for City
NEI_motor_vehicle_related_baltimore_city$City<-c("Baltimore City")
###Finding the emission related to motor vehicles for Los Angeles,california(fips=="06037")
## Find the data only for Los Angeles from NEI_motor_vehicle_related

NEI_motor_vehicle_related_Los_Angeles<-NEI_motor_vehicle_related[fips=="06037",]

##Adding another column for City
NEI_motor_vehicle_related_Los_Angeles$City<-c("Los Angeles County")

##combining both baltimore and LA 's NEI motor vehicle related 

NEI_Baltimore_Los<-rbind(NEI_motor_vehicle_related_baltimore_city,NEI_motor_vehicle_related_Los_Angeles)

##Create plot
png("plot6.png")

ggplot(NEI_Baltimore_Los,aes(x=factor(year),y=Emissions))+geom_bar(stat="identity",aes(fill=year))+facet_grid(.~City)+xlab("year")+ylab("Emissions")+ggtitle("Emissions from Baltimore City & Los Angeles from 1999-2008")

Dev.off()



