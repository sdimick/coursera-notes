
## Question 1
## ------------------------------------------------------------------
library(AppliedPredictiveModeling)
data(AlzheimerDisease)

adData = data.frame(diagnosis,predictors)
testIndex = createDataPartition(diagnosis, p = 0.50,list=FALSE)
training = adData[-testIndex,]
testing = adData[testIndex,]

## Question 2
## ------------------------------------------------------------------
library(AppliedPredictiveModeling)
data(concrete)
library(caret)
set.seed(1000)
inTrain = createDataPartition(mixtures$CompressiveStrength, p = 3/4)[[1]]
training = mixtures[ inTrain,]
testing = mixtures[-inTrain,]

library(ggplot2)
training$Index <- as.numeric(row.names(training))
class(training$Index)
ggplot(training, aes(x=Index, y=CompressiveStrength, color=Cement)) +
  geom_point()
ggplot(training, aes(x=Index, y=CompressiveStrength, color=BlastFurnaceSlag)) +
  geom_point()
ggplot(training, aes(x=Index, y=CompressiveStrength, color=FlyAsh)) +
  geom_point()
ggplot(training, aes(x=Index, y=CompressiveStrength, color=Water)) +
  geom_point()
ggplot(training, aes(x=Index, y=CompressiveStrength, color=Superplasticizer)) +
  geom_point()
ggplot(training, aes(x=Index, y=CompressiveStrength, color=CoarseAggregate)) +
  geom_point()
ggplot(training, aes(x=Index, y=CompressiveStrength, color=FineAggregate)) +
  geom_point()
ggplot(training, aes(x=Index, y=CompressiveStrength, color=Age)) +
  geom_point()


## Question 3
## ------------------------------------------------------------------
library(AppliedPredictiveModeling)
data(concrete)
library(caret)
set.seed(1000)
inTrain = createDataPartition(mixtures$CompressiveStrength, p = 3/4)[[1]]
training = mixtures[ inTrain,]
testing = mixtures[-inTrain,]

library(ggplot2)
ggplot(data=training, aes(x=Superplasticizer)) +
  geom_histogram(bins = 30)


## Question 4
## ------------------------------------------------------------------
library(caret)
library(AppliedPredictiveModeling)
set.seed(3433)
data(AlzheimerDisease)
adData = data.frame(diagnosis,predictors)
inTrain = createDataPartition(adData$diagnosis, p = 3/4)[[1]]
training = adData[ inTrain,]
testing = adData[-inTrain,]

keepcols <- grepl("^IL|diagnosis" ,colnames(training))
trainingIL <- training[,keepcols]
preProcess(trainingIL[,-1],method=c("pca"), thresh = 0.8)

## Question 5

modelFit1 <- train(diagnosis ~ ., method="glm", data=trainingIL)
confusionMatrix(testing$diagnosis, predict(modelFit1, testing))

modelFit2 <- train(diagnosis ~ ., method = "glm", preProcess = "pca", data = trainingIL, trControl = trainControl(preProcOptions = list(thresh = 0.8)))
confusionMatrix(testing$diagnosis, predict(modelFit2, testing))
