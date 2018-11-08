# Regression Models

[Course Materials](https://github.com/bcaffo/courses/tree/master/07_RegressionModels)

--------------------------------------------------------------------------------

## Week 1

--------------------------------------------------------------------------------

### Probability

### Conditional Probability

* Sensitivity: The probability it's true given positive
* Specificity: The probability it's false given negative


--------------------------------------------------------------------------------

## Week 4

--------------------------------------------------------------------------------

### Splines and Knot Points
```
#make some data on a sine curve with noise
n <- 500
x <- seq(0, 4*pi, length=n)
y <- sin(x) + rnorm(n, sd = 0.3)

#how can we model this??
knots <- seq(0, 8 * pi, length = 20)#could make just one kink
splineTerms <- sapply(knots, function(knot) (x>knot)*(x-knot))
xMat <- cbind(1, x, splineTerms)
yhat <- predict(lm(y~sMat -1))
plot(x, y, frame =FALSE, pch=21, bg="lightblue",cex=2)
lines(x,yhat, col="red",lwd=2)

#make it smooth?? add some squares
splineTerms <- sapply(knots, function(knot) (x>knot)*(x-knot)^2)
xMat <- cbind(1, x, x^2, splineTerms)
yhat <- predict(lm(y~sMat -1))
plot(x, y, frame =FALSE, pch=21, bg="lightblue",cex=2)
lines(x,yhat, col="red",lwd=2)
```
