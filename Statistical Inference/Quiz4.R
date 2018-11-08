
#Problem number 2
#95% confidence interval
m <- 1100 #mean
sd <- 30 #standard deviation
n <- 9 #sample size
m + c(-1,1) * qt(.975, n-1) * sd/sqrt(n)

#Problem number 3
pbinom(2, size = 4, prob = 0.5, lower.tail = FALSE)
#or
choose(4,3) * 0.5^4 + choose(4,4) * 0.5^4


#Problem number 4
ppois(10, lambda = 0.01 * 1787)


#Problem number 5
m1 <- -3
m2 <- 1
s1 <- 1.5
s2 <- 1.8
n1 <- 9
n2 <- 9
s <- sqrt(((n1 - 1) * s1^2 + (n2 - 1) * s2^2)/(n1 + n2 - 2))
tstat <- (m1 - m2)/(s * sqrt(1/n1 + 1/n2))
2 * pt(tstat, n1 + n2 -2)
