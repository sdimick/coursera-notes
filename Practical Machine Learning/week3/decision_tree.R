data(iris)
library(ggplot2)
#check out species
table(iris$Species)

# make training and test data
library(caret)
inTrain <- createDataPartition(y=iris$Species, p=0.7, list=FALSE)
training <- iris[inTrain,]
testing <- iris[-inTrain,]
dim(training); dim(testing)

# check out these groupings already
qplot(Petal.Width, Sepal.Width, colour=Species, data=training)

# train it with rpart
modFit <- train(Species ~ ., method="rpart", data=training)
print(modFit$finalModel)

# A couple ways to plot your tree
plot(modFit$finalModel, uniform=TRUE, main="Classification Tree")
text(modFit$finalModel, use.n=TRUE, all=TRUE, cex=0.8)

# problem installing rattle package :(
# library(rattle)
# fancyRpartPlot(modFit$finalModel)

# Predict on new data
predict(modFit, newdata=testing)
predict(modFit, newdata = testing) == testing$Species
# Accuracy?
sum(predict(modFit, newdata = testing) == testing$Species)/nrow(testing)
