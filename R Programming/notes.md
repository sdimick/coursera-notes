
# __R Programming__

--------------------------------------------------------------------------------

## Week 2

### Control Structures and Scoping

* Control Structures
  * if, else: `if (condition) {this} else if (cond.) {that} else {the other}`
  * for: `for (i in 1:10) { print(i) }`
  * while
  * repeat: immediately enter an infinite loop
  * break: exit a loop
  * next: skip iteration of a loop
  * return
* Lexical vs. Dynamic Scoping
  * Dynamic looks for free variables where the function was defined
  * Lexical looks for free variables where the function was called
* Coding Standards
  1. Always use text files
  2. Indent your code
  3. Limit the width of your code, usually 80 columns
  4. Limit the length of individual functions

### Dates and Times

* Dates represented as `Date` class
* Times represented as `POSIXct` or  `POSIXlt` class
* Dates are stored as days since 1970-01-01
* Times are stored as seconds since 1970-01-01
* `as.Date("1970-01-01")`
* POSIXct stores time as a very large integer
* POSIXlt is a list that stores day of the week, day of the year, etc
* Some generic functions
  * `weekdays`: gives the day of the week
  * `months`: gives the month name
  * `quarters`: gives the quarter number, i.e. "Q1"
* Turn character strings into times:
  * `?strptime`

--------------------------------------------------------------------------------

## Week 3

### Loop functions

__lapply__

* loop over a list and evaluate a function on each element
* `sapply` does the same but tries to simplify the result
* `lapply(list, function, arguments of function to apply)`
* ALWAYS returns a list
* heavy use with *anonymous* functions - functions you don't name
* `lapply(matrices, function(etl) etl[,1])` - return first column of each matrix
* `sapply` will simplify to vector or matrix if it can figure it out, or just list

__apply__

* apply a function over the margins of an array
* not faster than a loop, it's just less typing
* `apply(array, margin, function, arguments of function)`
```
x <- matrix(rnorm(200), 20, 10)
apply(x, 2, mean) #by column
apply(x, 1, mean) #by row
apply(x, 1, quantile, probs = c(0.25, 0.75))
```
* highly optimized functions for sums and means
  * rowSums = apply(x, 1, sum)
  * rowMeans = apply(x, 1, mean)
  * colSums = apply(x, 2, sum)
  * colMeans = apply(x, 2, mean)
* More dimensions
```
a <- array(rnorm(2 * 2 * 10), c(2, 2, 10))
apply(a, c(1, 2), mean)
rowMeans(a, dims = 2)
```

__mapply__

* multivariate version of `lapply`
* `mapply(function to apply, arguments to apply over, MoreArgs = list of other arguments for the function, SIMPLIFY = T/F if results should be simplified)`
* `mapply(rep, 1:4, 4:1)` = `list(rep(1,4),rep(2,3),rep(3,2),rep(4,1))`
* `mapply(noise, 1:5, 1:5, 2)`

__tapply__

* apply a function over subsets of a vector
* `tapply(vector, index, function, ..., simplify = TRUE)`
* index is a factor or list of factors that identifies which group each observation of the vector are in
```
x <- c(rnorm(10), runif(10), rnorm(10,1))
f <- gl(3, 10)
tapply(x, f, mean)
```
* if you set `simplify = FALSE` then you get a list back

__split__

* auxiliary function particularly useful in conjunction with `lapply`
* `split(x, f, drop = FALSE, ...)`
* split is used to break up a vector into groups, kind of like tapply but you don't apply a function to the groups
* `x` is a vectory, list, or data frame
* `f` is a factor or list of factors
* `drop` indicates whether empty factor levels should be dropped
```
x <- c(rnorm(10), runif(10), rnorm(10,1))
f <- gl(3, 10)
split(x, f)
```
* always returns a list - so you can use it in conjunction with lapply after you split, and you can use it to split up data in more complicated ways than you would with tapply
```
library(datasets)
s <- split(airquality, airquality$Month)
lapply(s, function(x) colMeans(x[, c("Ozone", "Solar.R", "Wind")])) #returns list
sapply(s, function(x) colMeans(x[, c("Ozone", "Solar.R", "Wind")])) #returns matrix
#take care of missing values
sapply(s, function(x) colMeans(x[, c("Ozone", "Solar.R", "Wind")], na.rm = TRUE))
```
* multilevel factors
```
x <- rnorm(10)
f1 <- gl(2, 5)
f2 <- gl(5, 2)
interaction(f1, f1) #gives you the combinations
str(split(x, list(f1, f2))) #show structure of this split - some levels don't have elements
str(split(x, list(f1, f2), drop = TRUE)) #remove empty levels
```

### Debugging

* Useful for figuring out what's wrong, after you know there's a problem
  * `message`: generic message produced by message function
  * `warning`: indication that something is wrong but not necessarily fatal, produced by warning function
  * `error`: indication that a fatal problem has occurred, produced by stop function
  * `condition`: generic concept for indicating something unexpected can occur
* *side note*: you can return and object from a function without printing with `invisible()`
* Primary tools for debugging:
  * `traceback`: prints out the function call stack after an error occurs
  * `debug`: flags a function for "debug" mode which allows you to step through the function one line at a time
  * `browser`: suspends the execution of a function wherever it is called and puts the function in debug mode
  * `trace`: allows you to insert debugging code into a function at specific places
  * `recover`: allows you to modify the error behavior so that you can browse the function call stack
* Invoke `traceback()` right after you see an error in your console
  * Will show you exactly which step the error occurred
* to use debugger, set it for a specific function `debug(lm)`
  * this with prompt you with the browser when you hit an error
  * type `n` and enter to go execute the next line of code
  * go to `?browser` to look at how to navigate around, `c` to exit the browser
* To use recover `options(error = recover)` and that is set for your session
  * gives you the steps like in traceback, but you browse the environment of each step

--------------------------------------------------------------------------------

## Week 4: Simulation and Profiling

### The str function

* Display the internal structure of an R object
* Very versatile alternative for `summary`
* Good for lists (potentially nested)
* Basically what you get when you expand an object in the environment panel in rstudio
* "Most useful function in all of R."

### Generating Random Numbers

* Generate random Normal variates from mean and SD: `rnorm`
* Evaluate Normal probability density: `dnorm`
* Evaluate cumulative dist. fun. for Normal: `pnorm`
* Generate random Poisson variates given rate: `rpois`
* In general, `d` for density, `r` for random numbers, `p` for cumulative distribution, and `q` for quantile function
* `set.seed` so you can reproduce "random" numbers
* Cumulative Distribution: _probability that random number is less than or equal to X_

### Simulating a Linear Model

__X Has Normal Distribution__
```
set.seed(20)
x <- rnorm(100)
e <- rnorm(100, 0, 2) #add noise
y <- 0.5 + 2*x + e #intercept = 0.5 and beta1 = 2
plot(x,y)
```

__X Has Binomial Distribution__
```
set.seed(10)
x <- rbinom(100, 1, 0.5)
e <- rnorm(100, 0, 2) #add noise
y <- 0.5 + 2*x + e #intercept = 0.5 and beta1 = 2
plot(x,y)
```

__Number from Generalized Linear Model__
* Say `y` has a Poisson Distribution
* log(mu) has a linear relationship beta0 plus beta1*x
* beta0 = 0.5
* beta1 = 0.3
```
set.seed(1)
x <- rnorm(100)
log.mu <- 0.5 + 0.3*x
y <- rpois(100, exp(log.mu))
plot(x,y)
```

### Random Sampling

* `sample` function allows you draw a random sample from vector
```
set.seed(1)
sample(1:10, 4) #sample 4 out of vector 1:10 w/o replacement
sample(letters, 5) #sample 5 letters w/0 replacement
sample(1:10) #gives you permutation (random order of vector)
sample(1:10, replace = TRUE) #sample with replacement (length of vector)
```

* Standard Distributions to know: Normal, Poisson, Binomial, Exponential, Gamma, etc.

### R Profiler

* Code that's running long? R Profiler - optimization
* Don't think about code optimization FIRST -
  * First get it working, readable, understand it, etc.
  * Then figure out where it's taking too long
  * "Premature optimization is the root of all evil"
* `system.time()`
  * "user time" - CPU time
  * "elapsed time" - "wall clock" time
  * user time CAN be longer than elapsed time if your code is waiting on external processes (like reading a webpage)
  * Time multi-step process?
  * `system.time({...multiple expressions...})`
* `Rprof()` - Starts the profiler in R
  * Use `summaryRprof()` to summarize the output
  * Do __NOT__ use `system.time()` with `Rprof()`
  * Measures how long each part of the call stack takes at 0.02 second intervals
  * `$by.total` - includes all child functions
  * `$by.self` - subtracts out all child functions
