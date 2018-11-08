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
predictions[1:10]
confusionMatrix(predictions, testing$type)
