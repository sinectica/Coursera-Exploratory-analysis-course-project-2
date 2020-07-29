## Reading the two data files in RDS format

SCC_PM25 <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Load libraries
library(dplyr)
library(ggplot2)

## QUESTION 6 Compare emissions from motor vehicle sources in Baltimore City with emissions from 
## motor vehicle sources in Los Angeles County, California (fips=="06037"). Which city has 
## seen greater changes over time in motor vehicle emissions?

## Filter SCC by $Sector "mobile" and $Level.Two by "vehicle"

MOBILE_SECTOR <- SCC[grepl("mobile",SCC$EI.Sector, ignore.case=TRUE),]
VEHICLE_SOURCE_LIST <- MOBILE_SECTOR[grep("vehicle",MOBILE_SECTOR$SCC.Level.Two, ignore.case=TRUE),]

## Combine data filtered from SCC and SCC_PM25 to get a data.frame with the sum of Emissions 
## for both cities and each year

SCC_FILTERED <- SCC[VEHICLE_SOURCE_LIST$SCC,]$SCC
SCC_PM25_FILTERED <- SCC_PM25[SCC_PM25$SCC %in% SCC_FILTERED,]
SCC_PM25_FILTERED <- SCC_PM25[SCC_PM25$SCC %in% SCC_FILTERED & SCC_PM25$fips %in% c("06037", "24510"),]
SCC_PM25_FILTERED$year <- as.factor(SCC_PM25_FILTERED$year)

## Add column with State name. Sum of the vehicle emissions of each City and year
SCC_PM25_FILTERED_COMBINED <- mutate(SCC_PM25_FILTERED, City = ifelse(fips == "06037", "Los Angeles, CA", ifelse(fips == "24510", "Baltimore City, MD", 0)))
SUM_PM25_VEHICLE_EMISSIONS_LA_BALTIMORE <- aggregate(Emissions~(City+year), SCC_PM25_FILTERED_COMBINED, sum)

## Plot the result

ggplot(data=SUM_PM25_VEHICLE_EMISSIONS_LA_BALTIMORE, aes(y=Emissions, x=year, fill = City)) + 
  geom_bar(stat="identity", position = "dodge") +
  scale_y_continuous(breaks = round(seq(500, 7500, by = 500),1)) +
  ggtitle("Total PM2.5 Emissions - Motor Vehicles", subtitle = "Baltimore City and Los Angeles") +
  labs(x = "Year", y = "PM2.5 Emissions (Tons)")

ggsave("Plot6.png", device = "png", width = 7, height = 7)