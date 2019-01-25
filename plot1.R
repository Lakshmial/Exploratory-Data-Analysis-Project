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
##group the total PM2.5_Emissions by year and assign it to variable summarized .year
summarized.year<-NEI[,list(totalPM2.5_Emissions=sum(Emissions)),by="year"]
## creating png file
png("plot1.png")
##creating barplot
barplot(summarized.year$totalPM2.5_Emissions,main="Total PM 2.5 emmissions in 1999,2002,2005 & 2008",xlab="year",ylab="total PM2.5 emmissions",names.arg=summarized.year$year,col=c("green","blue","yellow","orange"))
dev.off()