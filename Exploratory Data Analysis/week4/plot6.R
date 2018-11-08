library(dplyr)
library(ggplot2)
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
vehicle.codes <- SCC[grepl("Vehicle", SCC$EI.Sector),]
comp.mv.by.yr <- inner_join(NEI, vehicle.codes, by="SCC") %>% 
  filter(fips %in% c("24510", "06037")) %>%
  mutate(city=ifelse(fips=="24510","Baltimore","Los Angeles")) %>% 
  group_by(year, city) %>% 
  summarise(PM2.5 = sum(Emissions)) %>% 
  as.data.frame()

#check out percent change
pct.chng <- numeric(length = nrow(comp.mv.by.yr))
for(i in 1:nrow(comp.mv.by.yr)){
  pct.chng[i] <- 
    ifelse(comp.mv.by.yr$year[i]==1999,NA,
           (comp.mv.by.yr$PM2.5[i] -
              comp.mv.by.yr[comp.mv.by.yr$year==comp.mv.by.yr$year[i]-3&
                              comp.mv.by.yr$city==comp.mv.by.yr$city[i],]$PM2.5)/
             comp.mv.by.yr[comp.mv.by.yr$year==comp.mv.by.yr$year[i]-3&
                             comp.mv.by.yr$city==comp.mv.by.yr$city[i],]$PM2.5
  )
}
pct.chng <- round(pct.chng*10,2)
comp.mv.by.yr$Pct.Change <- pct.chng
comp.mv.by.yr$Pct.Change.Label <- paste0(comp.mv.by.yr$Pct.Change, "%")

plot6 <- ggplot(comp.mv.by.yr, aes(year, PM2.5, color = city, label = Pct.Change.Label)) +
  geom_point() +
  geom_line() + 
  geom_text(vjust = -0.4) +
  ggtitle("Vehicle Emissions in Baltimore and Los Angeles") +
  xlab("Year") +
  ylab("Total PM2.5 (tons)") +
  scale_x_continuous(breaks = unique(comp.mv.by.yr$year)) +
  annotate("text", x = 2003.5, y = 3000, 
           label = "Based on the annotated, \"year over year\"") +
  annotate("text", x = 2003.5, y = 2750, 
           label = "style percentage change, Baltimore has seen") +
  annotate("text", x = 2003.5, y = 2500, 
           label = "greater changes over time than Los Angeles.")

png("plot6.png", width = 720)
print(plot6)
dev.off()
