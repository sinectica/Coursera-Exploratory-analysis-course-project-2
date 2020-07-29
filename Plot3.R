## Reading the two data files in RDS format

SCC_PM25 <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Load ggplot Library

library(ggplot2)

## QUESTION 3 Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) 
## variable, which of these four sources have seen decreases in emissions from 1999–2008 for 
## Baltimore City? Which have seen increases in emissions from 1999–2008? Use the ggplot2.
## similar to 1, plot each type with time on x axis

# Subset Baltimore City required data

BALTIMORE_CITY <- subset(SCC_PM25, fips=="24510")
BALTIMORE_CITY$year <- as.factor(BALTIMORE_CITY$year)
TOTALPM25_BALTIMORE_CITY <- aggregate(Emissions~(year+type), BALTIMORE_CITY, sum)

## 2x2 plotting are, with 4 barplots in it, one for each source type with ggplot2 package tool

ggplot(data=TOTALPM25_BALTIMORE_CITY, aes(fill = type, y=Emissions, x=year)) + 
  geom_bar(stat="identity") + facet_wrap(~type) +
  ggtitle("Baltimore City, MD - PM2.5 Emissions Trend by Source type") +
  labs(x = "Year", y = "PM2.5 Emissions [Tons]")

ggsave("Plot3.png", device = "png", width = 7, height = 7)
