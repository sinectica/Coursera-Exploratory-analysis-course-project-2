## Reading the two data files in RDS format

SCC_PM25 <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Load libraries
library(dplyr)
library(ggplot2)

## QUESTION 4 Across the United States, how have emissions from 
## coal combustion-related sources changed from 1999–2008?

## Coal combustion related sources
## Filter short name by combustion and Four Level by coal

COAL_COMB_SHORTNAME <- SCC[grepl("coal|comb",SCC$Short.Name, ignore.case=TRUE),]
DATA_SET_COAL_COMB <- COAL_COMB_SHORTNAME[grepl("coal",COAL_COMB_SHORTNAME$SCC.Level.Four, ignore.case=TRUE),]

## Combine data filtered from SCC and SCC_PM25 to get a data.frame with the sum of required Emissions and years 

SCC_FILTERED <- SCC[DATA_SET_COAL_COMB$SCC,]$SCC
SCC_PM25_FILTERED <- SCC_PM25[SCC_PM25$SCC %in% SCC_FILTERED,]
SCC_PM25_FILTERED$year <- as.factor(SCC_PM25_FILTERED$year)
SUM_OF_PM25_COAL_EMISSIONS_BY_YEAR <- aggregate(Emissions~year, SCC_PM25_FILTERED, sum)

## Plot generation

ggplot(data=SUM_OF_PM25_COAL_EMISSIONS_BY_YEAR, aes(y=Emissions/10^6, x=year)) + 
  geom_bar(stat="identity") +
  ggtitle("EEUU - Total PM2.5 Emissions from Coal Combustion") +
  labs(x = "Year", y = "PM2.5 Emissions (MTons)")+
  scale_y_continuous(breaks=seq(0,0.6,by=0.1), limits=c(0,0.6)) 

ggsave("Plot4.png", device = "png", width = 7, height = 7)
