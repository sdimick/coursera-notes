library(dplyr)
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
balt.by.yr <- NEI %>% 
  filter(fips == "24510") %>% 
  group_by(year) %>% 
  summarise(PM2.5 = sum(Emissions)) %>% 
  as.data.frame()
png("plot2.png")
plot(balt.by.yr$year, balt.by.yr$PM2.5,
     xlab = "Year", ylab = "Total PM2.5 (tons)",
     axes = FALSE, pch = 19)
title("Baltimore PM2.5 Emissions")
box()
axis(1, at = balt.by.yr$year)
axis(2)
text(c(2006,2006), c(3250,3175),
     labels = c("PM2.5 has decreased", "from 1999 to 2008."))
dev.off()
