## Reading the two data files in RDS format

SCC_PM25 <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## QUESTION 1
## Have total emissions from PM2.5 decreased in the United States from 
## 1999 to 2008? Using the base plotting system, make a plot showing the 
## total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.

## New vector containing the total emissions groupped by years 
TOTALPM25 <- aggregate(Emissions ~ year, SCC_PM25, sum)

## Plot histogram

png("Plot1.png", width=500, height=500)

barplot(
  (TOTALPM25$Emissions)/10^6,  names.arg=TOTALPM25$year, col = "blue", xlab="Year", ylab="PM2.5 Emissions [MTons]",
  ylim = c(0, 8), main="EEUU PM2.5 Total Emissions Trend")
dev.off()