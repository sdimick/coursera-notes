library(dplyr)
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
ttl.by.yr <- NEI %>% 
  group_by(year) %>% 
  summarise(PM2.5 = sum(Emissions)) %>% 
  as.data.frame()
png("plot1.png")
plot(ttl.by.yr$year, ttl.by.yr$PM2.5,
     xlab = "Year", ylab = "Total PM2.5 (tons)",
     axes = FALSE, pch = 19)
title("US PM2.5 Emissions")
box()
axis(1, at = ttl.by.yr$year)
axis(2)
text(c(2006,2006), c(7000000,6800000),
     labels = c("PM2.5 has decreased", "from 1999 to 2008."))
dev.off()
