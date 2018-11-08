library(dplyr)
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
coal.codes <- SCC[grepl("Coal", SCC$EI.Sector),]
coal.by.yr <- inner_join(NEI, coal.codes, by="SCC") %>% 
  group_by(year) %>% 
  summarise(PM2.5 = sum(Emissions)) %>% 
  as.data.frame()
png("plot4.png")
plot(coal.by.yr$year, coal.by.yr$PM2.5,
     xlab = "Year", ylab = "Total PM2.5 (tons)",
     axes = FALSE, pch = 19)
title("US Coal Combustion PM2.5 Emissions")
box()
axis(1, at = coal.by.yr$year)
axis(2)
text(c(2006,2006,2006), c(500000,490000,480000),
     labels = c("PM2.5 from coal", "cumbustion has decreased", "from 1999 to 2008."))
dev.off()
