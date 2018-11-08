# Statistical Inference

[Course Materials](https://github.com/bcaffo/courses/tree/master/06_StatisticalInference)

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

#CALCULATE POWER
```
alpha <- 0.05
mu0 <- 30
mua <- 32
sigma <- 4
n <- 16
z <- qnorm(1 - alpha)
pnorm(mu0 + z * sigma/sqrt(n), mean = mua, sd = sigma/sqrt(n), lower.tail = FALSE)


?power.t.test
#omit one of the arguments and it solves for you
#delta is difference of the means
power.t.test(n=16,delta=2,sd=4,type="one.sample",alt="one.sided")$power
power.t.test(power=0.8,delta=2,sd=4,type="one.sample",alt="one.sided")$n
```

#MULTIPLE TESTING
```
p.adjust(pValues,method="bonferroni") #FWER
p.adjust(pValues,method="BH") #FDR
```

#BOOTSTRAPPING
```
B <- 10000
# X <- vector of our sample
resamples <- matrix(sample(X, n * B, replace=TRUE), B, n)
medians <- apply(resamples, 1, median)
sd(medians)
quantile(medians, c(0.025, 0.975)) #95% confidence interval
ggplot(data.frame(medians=medians), aes(x=medians)) + geom_histogram(color="black",fill="lightblue",binwidth=0.05)
```
