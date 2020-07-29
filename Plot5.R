## Reading the two data files in RDS format

SCC_PM25 <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Load libraries
library(dplyr)
library(ggplot2)

## QUESTION 5 How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

## Filter SCC by $Sector "mobile" and $Level.Two by "vehicle"

MOBILE_SECTOR <- SCC[grepl("mobile",SCC$EI.Sector, ignore.case=TRUE),]
VEHICLE_SOURCE_LIST <- MOBILE_SECTOR[grep("vehicle",MOBILE_SECTOR$SCC.Level.Two, ignore.case=TRUE),]

## Combine data filtered from SCC and SCC_PM25 to get a data.frame with the sum of required Emissions and years

SCC_FILTERED <- SCC[VEHICLE_SOURCE_LIST$SCC,]$SCC
SCC_PM25_FILTERED <- SCC_PM25[SCC_PM25$SCC %in% SCC_FILTERED,]
SCC_PM25_FILTERED$year <- as.factor(SCC_PM25_FILTERED$year)

BALTIMORE_CITY <- subset(SCC_PM25_FILTERED, fips=="24510")
SUM_OF_PM25_BALTIMORE_VEHICLE_EMISSIONS_BY_YEAR <- aggregate(Emissions~year, BALTIMORE_CITY, sum)

ggplot(data=SUM_OF_PM25_BALTIMORE_VEHICLE_EMISSIONS_BY_YEAR, aes(y=Emissions, x=year)) + 
  geom_bar(stat="identity") +
  ggtitle("Baltimore City, MD - Total PM2.5 Emissions from Motor Vehicles") +
  labs(x = "Year", y = "PM2.5 Emissions (Tons)")

ggsave("Plot5.png", device = "png", width = 7, height = 7)