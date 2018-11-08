
# __Practical Machine Learning__

--------------------------------------------------------------------------------

## Week 1

### Intro

* Thorough Book: The Elements of Statistical Learning
* The `caret` package will be our go to
* Another good course is the Coursera "Machine Learning" course by Stanford
* Kaggle - organizes prediction competitions

### What is Prediction?

* Probability/Sampling for picking training set
* question > input data > features > algorithm > parameters > evaluation
* Can we identify if an email is SPAM?
  * `kernlab` package has `spam` data set
  * feature could be the number of times you see a certain word
* Features compress data for computation but retain relevant information
  * expert application knowledge vs automated feature selection
* Algorithms matter less than you think - diminishing returns 
  * Aims: Interpretable - Simple - Accurate - Fast - Scalable
  * Tradeoffs ^
  
### In Sample and Out of Sample Errors

* In Sample Error: using same data you used for training
  * Always optimistic
  * Sometimes called redistribution error
* Out of Sample Error: error rate on NEW data
  * Sometimes called generalization error
  * Always > In Sample Error
* Train too well for In Sample -> __Overfitting__

### Prediction Study Design

* Define Your Error Rate
* Split your data:
  * Training
  * Testing
  * Validation (optional)
* On training set pick Features
  * use cross-validation
* On training set pick prediction function
  * use cross-validation
* If no validation
  * Apply 1x to test set
* If Validation
  * apply to test set and refine
  * apply 1x to validation

* Know your prediction benchmarks
* Avoid small sample sizes - chance of 100% accuracy just by chance
* Large sample size?
  * 60% Training
  * 20% Testing
  * 20% Validation
* Medium sample size?
  * 60% Training
  * 40% Testing
* If small sample size
  * Do cross-validation
  * Report caveat of small sample size
* Usually randomize to select test/training/validation groups
* If over long period of time, sample time chunks - *backtesting in finance*
* All subsets should reflect as much diversity as possible
  * Random or try to balance by features, but tricky

### Types of Errors

* Basic Terms: True/False Positive/Negative
* Sensitivity > Pr(positive test | disease)
* Specificity > Pr(negative test | no disease)
* Positive Predictive Value > Pr(disease | positive test)
* Negative Predictive Value > Pr(no disease | negative test)
* Accuracy > Pr(correct outcome)

* For continuous data
  * Mean Sqared Error (MSE) - Average of squared errors
  * Root mean squared error (RMSE) - put MSE back in normal units

* Common errors used
  * Mean squared error
  * Median absolute deviation
  * Sensitivity
  * Specificity
  * accuracy
  * Concordance (i.e. kappa)

### Receiver Operating Characteristic (ROC) Curve

* Used for binary classification
* X-axis - Probability of false positive
* Y-axis - Probability of true positive
* AUC (area under the curve):
  * 0.5 is as good as random guessing
  * 1 is a perfect classifier
  * 0.8 is considered "good"

### Cross Validation

* Used For:
  * Picking variables to include in the model
  * Picking the type of prediction function to use
  * Picking parameters in the prediction function
  * Comparing different predictors
* Break our training data into sub-training and sub-test
* Build model on training and evaluate on test
* Repeat and average the estimated errors
* Methods:
  * Random subsampling
  * K-fold
  * Leave one out
* Sample without replacement or you're bootstrapping

### What data should you use?

* Unrelated data is the most common mistake

--------------------------------------------------------------------------------

## Week 2

### The `caret` Package

* The package allows us to use common function names for many modeling techniques from different packages
* Example

```r
library(caret)
library(kernlab)
data(spam)

# create training set with 75% of the data
inTrain <- createDataPartition(y=spam$type,
  p=0.75, list=FALSE)
training <- spam[inTrain,]
testing <- spam[-inTrain,]

# fit glm model to predict spam
set.seed(32343)
modelFit <- train(type ~., data=training, method="glm")
modelFit
modelFit$finalModel

# check out predictions/fit
predictions <- predict(modelFit, newdata=testing)
predictions
confusionMatrix(predictions, testing$type)
```

### Data Slicing

* Use for building training and testing set or for cross validation
* Example

```r
library(caret)
library(kernlab)
data(spam)

# create training set with 75% of the data
inTrain <- createDataPartition(y=spam$type,
  p=0.75, list=FALSE)
training <- spam[inTrain,]
testing <- spam[-inTrain,]

# create K-fold samples for cross-validation
set.seed(32323)
folds <- createFolds(y=spam$type, k=10,
  list=TRUE, returnTrain=TRUE)
# check out how big each fold is
sapply(folds, length)

# Resampling instead of K-folds
folds <- createResample(y=spam$type, times=10, list=TRUE)
sapply(folds, length)

# Get Time Slices
set.seed(32323)
tme <- 1:1000 #hypothetical observations
folds <- createTimeSlices(y=tme, initialWindow=20,
  horizon=10) #going to predict the next 10 from the previous 20
names(folds) #get train and test
folds$train[[1]] #get 1 to 20
folds$test[[1]] #get 21 to 30
# next group will be shifted over one
```

### Training Options with `caret` Package

* There are a bunch of arguments for the `train()` function you can tweak
* Check out defaults `?train`
* Other metric options...
  * Continuous default is "RMSE" but can use "Rsquared"
  * Discrete default is "Accuracy" but can use "Kappa"
* A bunch of options for `trControl = trainControl()`
  * `args(trainControl)`
* Some of the options...
* method
  * boot = bootstrapping
  * boot632 = bootstrapping with adjustment
  * cv = cross validation
  * repeatedcv = repeated cross validation
  * LOOCV = leave one out cross validation
* number
  * For boot/cross validation
  * Number of subsamples to take
* repeats
  * Number of times to repeat subsampling
  * If big this can slow things down
* Setting the Seed
  * Needed for reproducible results
  * Cross validation starts with a random draw
  * You can set the seed for each resample in trControl if running parallel

### Plotting Predictors

* Example with wage data
* Don't use the test set for exploration

```r
library(ISLR); library(ggplot2); library(caret);
data(Wage)
summary(Wage)

inTrain <- createDataPartition(y=Wage$wage,
  p=0.7, list=FALSE)
training <- Wage[inTrain,]
testing <- Wage[-inTrain,]

# a bunch of plotting here....
# featurePlot() from caret
# qplot() from ggplot2 - add colours and geom_smooth()

# Change continuous into groups!
cutWage <- cut2(training$wage, g=3)
table(cutWage)

# Tables useful for checking out groups
t1 <- table(cutWage, training$jobClass)
t1
prop.table(t1, 1) #gives proportions of rows, 2 would give prop of columns
```

### Basic Preprocessing

* Transform variables to make them more useful as predictors
* Standardize variables by subtracting mean then dividing by sd
  * Note: Use training mean and standard deviation for stdzng. test set
* `preProcess = c("center", "scale")`
  * another method "BoxCox"
* If you want to change before train set:

```r
preObj <- preProcess(training[,-58],method=c("center","scale"))
trainCapAveS <- predict(preObj,training[,-58])$capitalAve
```
* Missing Data?? Impute with k nearest neighbors

```r
set.seed(13343)

# so pretend we have some missing values
training$capAve <- training$capitalAve
selectNA <- rbinom(dim(training)[1], size=1, prob=0.5)==1
training$capAve[selectNA] <- NA

# then Impute and standardize our "missing" values with knn
preObj <- preProcess(training[,-58], method="knnImpute")
capAve <- predict(preObj, training[,-58])$capAve

# standardize based on TRUE values (not imputed ones)
capAveTruth <- training$capitalAve
capAveTruth <- (capAveTruth-mean(capAveTruth))/sd(capAveTruth)
```

### Covariate Creation

* Covariates: predictors or features
* Often need to transform raw data into features or covariates
* Balancing act between summarization vs. information loss
* Level 1: Raw Data to Tidy Covariates
* Level 2: Tidy Covariates to New Covariates

* Remove covariates with little or no variation
  * `nearZeroVar(training, saveMetrics=TRUE)`
* Create spline break points
  * `library(splines); bsBasis <- bs(training$age, df=3)`

### Preprocessing with Principal Component Analysis

* Outliers can really mess up PCA
  * Transform first with logs/Box Cox
* Can use to combine variable that are highly correlated into one transformed variable
* Check out some code on the spam data...

```r
smallSpam <- spam[,c(34, 32)]
prComp <- prcomp(smallSpam)
plot(prComp$x[,1],prComp$x[,2]) #plot first vs second pcs
# Check out the actual transforms
prComp$
# That was with two variables, check out with all variables
typeColor <- ((spam$type=="spam")*1 + 1) #give us colors for plotting
prComp <- prcomp(log10(spam[,-58]+1)) # do the pca but log transform + 1 first
plot(prComp$x[,1], prComp$x[,2], col=typeColor, xlab="PC1", ylab="PC2")

# can do that with preprocessing and then train
# OR
# just do it right in the training...
modelFit <- train(training$type ~ ., method="glm", preProcess="pca",
  data=training)
confusionMatrix(testing$type, predict(modelFit, testing))
# automatically does all the pca calcs on the test set from the training set
```

### Predicting with Regression

* Fit a model
* Plug in new data and multiply by coefficients
* Useful when linear model is (nearly) correct

* Get training set __AND__ test set errors
* RMSE (root mean squared error)

* Can be useful to __COMBINE__ with other machine learning models

### Predicting with Regression, Multiple Covariates

* Clever idea: color residual plot by variable not yet used in the model
  * Remember: Fitted value on the x-axis, residual on the y-axis
* Oooo.. plot Index (order of data) vs Residual to look for systematic problem

--------------------------------------------------------------------------------

## Week 3

### Predicting with Trees

* Basic Algorithm
  1. Start with all values in one group
  2. Find the variable/split that best separates the outcomes
  3. Divide the data into two groups ("leaves") on that split ("node")
  4. Within each split, find the best variable/split that separates the outcomes
  5. Continue until the groups are too small or sufficiently "pure"
* Misclassification Error
  * 1 - P(in most common group in leaf)
  * 0 = perfect purity
  * 0.5 = no purity
* Gini index
  * 1 - sum((probability in each of the classes)^2)
  * 0 = perfect purity
  * 0.5 = no purity
* Deviance/information gain
  * 1 - sum((probability in each of the classes) * log(probability in each of the classes))
  * Using log base e is deviance, base 2 is information gain
  * 0 = perfect purity
  * 1 = no purity
* Example with Iris Data:

```r
data(iris)
library(ggplot2)
#check out species
table(iris$Species)

# make training and test data
inTrain <- createDataPartition(y=iris$Species, p=0.7, list=FALSE)
training <- iris[inTrain,]
testing <- iris[-inTrain,]
dim(training); dim(testing)

# check out these groupings already
qplot(Petal.Width, Sepal.Width, colour=Species, data=training)

# train it with rpart
library(caret)
modFit <- train(Species ~ ., method="rpart", data=training)
print(modFit$finalModel)

# A couple ways to plot your tree
plot(modFit$finalModel, uniform=TRUE, main="Classification Tree")
text(modFit$finalModel, use.n=TRUE, all=TRUE, cex=0.8)

library(rattle)
fancyRpartPlot(modFit$finalModel)

# Predict on new data
predict(modFit, newdata=testing)
```

### Bagging (Bootstrap Aggregating)

* Most useful for non-linear models
* Resample data with replacement, train model again, then for your "*final*" model you either average predictions or take majority vote
* Similar bias, but less variability

### Random Forests

* Continuation of bagging: for decision trees
* Pros
  * Accuracy
* Cons
  * Slow to build
  * Interpretability
  * Overfitting
* Example with iris Data

```r
data(iris)
library(caret)
library(ggplot2)

inTrain <- createDataPartition(y=iris$Species, p=0.7, list=FALSE)
training <- iris[inTrain,]
testing <- iris[-inTrain,]

modFit <- train(Species ~ ., data=training, method="rf", prox=TRUE)
modFit

# look at specific tree - second one - each row is a split of the tree
getTree(modFit$finalModel, k=2)

# can get class "centers" for covariates
irisP <- classCenter(training[,c(3,4)], training$Species, modFit$finalModel$prox)

# and of course you can do predictions
```

### Boosting

* Basica idea..
  * Take lots of (possibly) weak predictors
  * Weight them and add them up
  * Get a stronger predictor
* Take all possible trees or regressions, etc and weight them by iteratively going through and minimizing error on the training set
* Most popular algorithm is adaboost
* Boosting libraries in R
  * `gbm` - for trees
  * `mboost` - model based boosting
  * `ada` - additive logistic regression
  * `gamBoost` - generalized additive models
* Example

```r
library(ISLR); data(Wage); library(ggplot2); library(caret);
Wage <- subset(Wage, select=-c(logwage))
inTrain <- createDataPartition(y=Wage$wage, p=0.7, list=FALSE)
training <- Wage[inTrain,]
testing <- Wage[-inTrain,]

modFit <- train(wage ~ ., method="gbm", data=training, verbose=FALSE)
print(modFit)

qplot(predict(modFit, testing), wage, data=testing)
```

### Model Based Prediction

* Basic idea...
  * Assume the data follow a probabilistic model
  * Use Bayes' theorem to identify optimal classifiers
* Bayes' theorem: P(A|B) = P(B|A)P(A)/P(B)
* Range of models use this approach
  * Linear discriminant analysis: assumes Gaussian with same covariances
  * Quadratic discriminant analysis: assumes Gaussian with different covariances
  * Model based prediction assumes more complicated versions for covariance
  * Naive Bayes assumes independence between features for model building
* Linear Discriminant
  * Use gaussian distributions for the predictors around classes
  * Draw lines between distributions where probability from being one class becomes greater than being in another class
  * Use those lines to predict classes
  * `modlda <- train(Species ~ ., data=taining, method="lda")`
* Niave Bayes
  * Assumes all predictors are independent
  * Works well for large number of binaries or categorical data
  * Comes up a lot in text classification
  * `modnb <- train(Species ~ ., data=taining, method="nb")`

--------------------------------------------------------------------------------

## Week 4

### Regularized Regression

* Methods in `caret`:
  * `ridge`
  * `lasso`
  * `relaxo`
* Penalize big coefficients to some extent (level chosen by lamda) to reduce total error by trading variance for some bias
* Lasso will take coefficients all the way to zero which will perform model selection for you

### Combining Predictors (Ensembling Methods)

* So we're combining separate models here
* Similar classifiers: Bagging, Boosting, Random Forests
* Different classifiers: Model stacking, Model ensembling
* Example with wage data:

```r
library(ISLR); data(Wage); library(ggplot2); library(caret);
Wage <- subset(Wage, select=-c(logwage)) #cheater predictor

# Create test/train/validation sets
inBuild <- createDataPartition(y=Wage$wage, p=0.7, list=FALSE)
validation <- Wage[-inBuild,]
buildData <- Wage[inBuild,]
inTrain <- createDataPartition(y=buildData$wage, p=0.7, list=FALSE)
training <- buildData[inTrain,]
testing <- buildData[-inTrain,]

# Build to different models for same data set
mod1 <- train(wage~., method="glm",data=training)
mod1 <- train(wage~., method="rf", data=training,
  trControl = trainControl(method="cv"),number=3
)

# Compare the two predictions
pred1 <- predict(mod1, testing)
pred2 <- predict(mod2, testing)
qplot(pred1, pred2, colour=wage, data=testing)

# Now build ANOTHER model based off the two predictions
predDF <- data.frame(pred1, pred2, wage=testing$wage)
combModFit <- train(wage~., method="gam", data=predDF)
combPred <- predict(combModFit, predDF)

# Check out results on validation data set
pred1V <- predict(mod1, validation)
pred2V <- predict(mod2, validation)
predVDF <- data.frame(pred1=pred1V, pred2=pred2V)
combPredV <- predict(combModFit, predVDF)

# Error from model 1 alone
sqrt(sum((pred1V-validation$wage)^2))

# Error from model 2 alone
sqrt(sum((pred2V-validation$wage)^2))

# Error from stacked model
sqrt(sum((combPredV-validation$wage)^2))

```
* Do the same thing for binary/factor data?
  * Build and ODD number of models
  * Predict with each model
  * Predict the class by the majority vote
* Scalability issues: Netflix competition winner never implemented because too computationally heavy

### Forecasting

* Have to sample with windowing
* Decompose into:
  * Trends - long term increases or decreases
  * Seasonal patterns - related to time of week/month/year
  * Cycles - periodic patterns that aren't seasonal
* Beware of spurious correlations (also common in geographic data)
* Example with Google Data:

```r
library(quantmod) #get financial data
library(forecast)
from.dat <- as.Date("01/01/08", format="%m/%d/%y")
to.dat <- as.Date("12/31/13", format="%m/%d/%y")
getSymbols("GOOG", src="google", from=from.dat, to=to.dat)

# Change data to monthly open
mGoog <- to.monthly(GOOG)
googOpen <- Op(mGoog)
ts1 <- ts(googOpen, frequency=12)
plot(ts1, xlab="Years+1", ylab="GOOG")

# Decompose
plot(decompose(ts1), xlab="Years+1")

# Training and Test Sets
ts1Train <- window(ts1, start=1, end=5)
ts1Test <- window(ts1, start=5, end=(7-0.01))
ts1Train

# Simple Moving Average
plot(ts1Train)
lines(ma(ts1Train, order=3),col="red")

# Exponential Smoothing
ets1 <- ets(ts1Train, model="MM")
fcast <- forecast(ets1)
plot(fcast)
lines(ts1Test, col="red")
accuracy(fcast, ts1Test)
```
* Be careful of how far you predict (extrapolation)

### Unsupervised Prediction

* We don't know the classes we're trying to predict
* We have to build the classes first with clustering
* This goes into recommendation engines


--------------------------------------------------------------------------------
