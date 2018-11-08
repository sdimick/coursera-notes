data(iris)
library(caret)
library(randomForest)
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
# and you could plot them among the other data.. blah blah

# and you can run your predictions with predict
