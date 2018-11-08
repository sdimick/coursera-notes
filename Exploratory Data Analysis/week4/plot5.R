library(dplyr)
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
vehicle.codes <- SCC[grepl("Vehicle", SCC$EI.Sector),]
balt.mv.by.yr <- inner_join(NEI, vehicle.codes, by="SCC") %>% 
  filter(fips == "24510") %>% 
  group_by(year) %>% 
  summarise(PM2.5 = sum(Emissions)) %>% 
  as.data.frame()
png("plot5.png")
plot(balt.mv.by.yr$year, balt.mv.by.yr$PM2.5,
     xlab = "Year", ylab = "Total PM2.5 (tons)",
     axes = FALSE, pch = 19)
title("Baltimore Motor Vehicle PM2.5 Emissions")
box()
axis(1, at = balt.mv.by.yr$year)
axis(2)
text(c(2006,2006,2006), c(330,315,300),
     labels = c("PM2.5 from motor", "vehicles has decreased", "from 1999 to 2008."))
dev.off()
