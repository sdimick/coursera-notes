library(dplyr)
library(ggplot2)
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
ttl.by.tp <- NEI %>% 
  filter(fips == "24510", year %in% c(1999,2008)) %>% 
  group_by(year, type) %>% 
  summarise(PM2.5 = sum(Emissions)) %>% 
  as.data.frame()

plot3 <- ggplot(ttl.by.tp, aes(year, PM2.5, color = type)) +
  facet_wrap(~type, ncol = 2, scales = "free") +
  geom_point() +
  geom_line() +
  ggtitle("Baltimore PM2.5 Emissions by Type") +
  xlab("Year") +
  ylab("PM2.5 (tons)") +
  scale_x_continuous(breaks = c(1999, 2008)) +
  theme(legend.position = "none")

png("plot3.png", width = 720)
print(plot3)
dev.off()
