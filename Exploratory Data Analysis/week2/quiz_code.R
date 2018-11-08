library(nlme)
library(lattice)
xyplot(weight ~ Time | Diet, BodyWeight)



library(lattice)
library(datasets)
data(airquality)
p <- xyplot(Ozone ~ Wind | factor(Month), data = airquality)


library(ggplot2)
qplot(Wind, Ozone, data = airquality, facets = . ~ factor(Month))

airquality = transform(airquality, Month = factor(Month))
qplot(Wind, Ozone, data = airquality, facets = . ~ Month)

library(ggplot2movies)

qplot(votes, rating, data = movies) + geom_smooth()
