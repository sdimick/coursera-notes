
## WEEK 4 QUIZ

# Question 1
# --------------------------------------------
library(ElemStatLearn)
data(vowel.train)
data(vowel.test)

vowel.train$y <- as.factor(vowel.train$y)
vowel.test$y <- as.factor(vowel.test$y)
set.seed(33833)
mod1 <- train(y~., data=vowel.train, method="rf")
mod2 <- train(y~., data=vowel.train, method="gbm", verbose=FALSE)

# Accuracy?
pred1 <- predict(mod1, newdata = vowel.test)
pred2 <- predict(mod2, newdata = vowel.test)
sum(pred1 == vowel.test$y)/nrow(vowel.test)
sum(pred2 == vowel.test$y)/nrow(vowel.test)
agree <- data.frame(pred1, pred2, y=vowel.test$y)
agree <- agree[agree$pred1==agree$pred2,]
sum(agree$pred1 == agree$y)/nrow(agree)


# Question 2
# --------------------------------------------
library(caret)
library(gbm)
set.seed(3433)
library(AppliedPredictiveModeling)
data(AlzheimerDisease)
adData = data.frame(diagnosis,predictors)
inTrain = createDataPartition(adData$diagnosis, p = 3/4)[[1]]
training = adData[ inTrain,]
testing = adData[-inTrain,]

set.seed(62433)
mod1 <- train(diagnosis~., data=training, method="rf")
mod2 <- train(diagnosis~., data=training, method="gbm", verbose=FALSE)
mod3 <- train(diagnosis~., data=training, method="lda")

stackdf <- data.frame(
  pred1 = predict(mod1, training),
  pred2 = predict(mod2, training),
  pred3 = predict(mod3, training),
  diagnosis = training$diagnosis
)

stackmod <- train(diagnosis~., data=stackdf, method="rf")

allpreds <- data.frame(
  pred1 = predict(mod1, testing),
  pred2 = predict(mod2, testing),
  pred3 = predict(mod3, testing),
  diagnosis = testing$diagnosis
)
allpreds$predstack <- predict(stackmod, allpreds)

accuracies <- list(
  pred1 = sum(allpreds$pred1==allpreds$diagnosis)/nrow(allpreds),
  pred2 = sum(allpreds$pred2==allpreds$diagnosis)/nrow(allpreds),
  pred3 = sum(allpreds$pred3==allpreds$diagnosis)/nrow(allpreds),
  predstack = sum(allpreds$predstack==allpreds$diagnosis)/nrow(allpreds)
)
accuracies


# Question 3
# --------------------------------------------
rm(list = ls())
set.seed(3523)
library(AppliedPredictiveModeling)
data(concrete)
inTrain = createDataPartition(concrete$CompressiveStrength, p = 3/4)[[1]]
training = concrete[ inTrain,]
testing = concrete[-inTrain,]

set.seed(233)
mod <- train(CompressiveStrength~., data=training, method="lasso")
library(elasticnet)
mod$finalModel
plot.enet(mod$finalModel, xvar = "penalty", use.color = TRUE)

# Question 4
# --------------------------------------------
rm(list = ls())
download.file("https://d396qusza40orc.cloudfront.net/predmachlearn/gaData.csv", "gaData.csv")
library(lubridate) # For year() function below
dat = read.csv("gaData.csv")
file.remove("gaData.csv")

training = dat[year(dat$date) < 2012,]
testing = dat[(year(dat$date)) > 2011,]
tstrain = ts(training$visitsTumblr)

library(forecast)
fit <- bats(tstrain)
fc <- forecast(fit, h = nrow(testing))
hi95 <- fc$upper[, 2]
lo95 <- fc$lower[, 2]
sum(lo95 < testing$visitsTumblr & testing$visitsTumblr < hi95) / nrow(testing)


# Question 5
# --------------------------------------------
rm(list = ls())
library(caret)
library(e1071)
set.seed(3523)
library(AppliedPredictiveModeling)
data(concrete)
inTrain = createDataPartition(concrete$CompressiveStrength, p = 3/4)[[1]]
training = concrete[ inTrain,]
testing = concrete[-inTrain,]
# -- train svm and find RMSE for testing
set.seed(325)
fit <- svm(CompressiveStrength ~ ., data = training)
predictions <- predict(fit, newdata = testing)
# -- RMSE
sqrt(mean((testing$CompressiveStrength - predictions)^2))
