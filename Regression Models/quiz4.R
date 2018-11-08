#problem 6
x <- -5:5
y <- c(5.12, 3.93, 2.67, 1.87, 0.52, 0.08, 0.93, 2.05, 2.54, 3.87, 4.97)
knots <- 0
splineTerms <- sapply(knots, function(knot) (x>knot)*(x-knot))
xMat <- cbind(1, x, splineTerms)
fit <- lm(y~xMat -1)
sum(fit$coefficients[2:3])

#problem 4
data("InsectSprays")
InsectSprays$spray <- relevel(InsectSprays$spray, ref = "B")
fit4 <- glm(count~spray,family = "poisson",data=InsectSprays)
summary(fit4)
exp(fit4$coefficients[2])

#problem 1
library(MASS)
data <- shuttle
data$use.bin <- ifelse(data$use=="auto",1,0)
data$wind <- relevel(data$wind, ref = "tail")
fit1 <- glm(use.bin ~ wind, family="binomial", data = data)
exp(fit1$coefficients)


#problem 2
fit2 <- glm(use.bin ~ wind + magn, family="binomial", data = data)
summary(fit2)
exp(fit2$coefficients)

#problem 3
glm(use.bin ~ wind, family="binomial", data = data)
glm(1-use.bin ~ wind, family="binomial", data = data)
