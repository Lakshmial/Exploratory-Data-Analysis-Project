library(dplyr)
library(data.table)
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


##  get coal combustion related data only from SCC using grepl
coal_combustion_source<-grepl("Fuel Comb.*Coal",SCC$EI.Sector)

##extract the above data and assign it to coal_combustion_related_source
coal_combustion_related_source<-SCC[coal_combustion_source,]

##extract above  data from NEI

NEI_coal_combustion_related<-NEI[NEI$SCC %in% coal_combustion_related_source$SCC,]

##create plot
png("plot4.png")
ggplot(NEI_coal_combustion_related,aes(x=factor(year),y=Emissions))+geom_bar(stat="identity",aes(fill=year))+xlab("year")+ylab("Emissions")+ggtitle("Emissions related to coal Combustion from 1999-2008")
dev.off()