## Reading the two data files in RDS format

SCC_PM25 <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## QUESTION 2 
## Have total emissions from PM2.5 decreased in the Baltimore City, Maryland 
## (fips=="24510") from 1999 to 2008? Use the base plotting system to make a plot 
## answering this question. Plot only fips = “24510”, time on x axis

## Subset Baltimore City required data

BALTIMORE_CITY <- subset(SCC_PM25, fips=="24510")
TOTALPM25_BALTIMORE_CITY <- aggregate(Emissions ~ year, BALTIMORE_CITY, sum)

## Plot histogram with Baltimore City data

png("Plot2.png", width=500, height=500)

barplot(TOTALPM25_BALTIMORE_CITY$Emissions, names.arg=TOTALPM25_BALTIMORE_CITY$year,
  col = "red", xlab="Year", ylab="PM2.5 Emissions (Tons)", ylim=c(0,4000),
  main="Baltimore City, MD - PM2.5 Total Emissions Trend")

dev.off()