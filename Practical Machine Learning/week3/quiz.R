library(AppliedPredictiveModeling)
data(segmentationOriginal)
library(caret)

# Question 1
# -------------------------------------------------
training <- segmentationOriginal[segmentationOriginal$Case=="Train",]
testing <- segmentationOriginal[segmentationOriginal$Case=="Test",]

set.seed(125)
mdl <- train(Class ~ ., method="rpart", data=training)
mdl$finalModel
plot(mdl$finalModel, uniform=TRUE, main="Classification Tree")
text(mdl$finalModel, use.n=TRUE, all=TRUE, cex=0.8)

# How does the model predict the following?
# 
# a. TotalIntench2 = 23,000; FiberWidthCh1 = 10; PerimStatusCh1=2
# --PS
# b. TotalIntench2 = 50,000; FiberWidthCh1 = 10;VarIntenCh4 = 100
# --WS
# c. TotalIntench2 = 57,000; FiberWidthCh1 = 8;VarIntenCh4 = 100
# --PS
# d. FiberWidthCh1 = 8;VarIntenCh4 = 100; PerimStatusCh1=2
# --Can't predict

# Question 3
# -------------------------------------------------
load("week3/olive")
olive = olive[,-1]

mdl2 <- train(Area ~ ., method="rpart", data=olive)

newdata = as.data.frame(t(colMeans(olive)))

predict(mdl2, newdata = newdata)

# Question 4
# -------------------------------------------------
library(ElemStatLearn)
data(SAheart)
set.seed(8484)
train = sample(1:dim(SAheart)[1],size=dim(SAheart)[1]/2,replace=F)
trainSA = SAheart[train,]
testSA = SAheart[-train,]

set.seed(13234)
mdl <- train(chd ~ age + alcohol + obesity + tobacco + typea + ldl,
             method="glm", data=trainSA, family="binomial")

missClass = function(values,prediction){sum(((prediction > 0.5)*1) != values)/length(values)}

# what are the misclassifications on the test and training sets?
missClass(testSA$chd, predict(mdl, newdata = testSA))
missClass(trainSA$chd, predict(mdl, newdata = trainSA))


# Question 5
# -------------------------------------------------
library(ElemStatLearn)
data(vowel.train)
data(vowel.test)
vowel.test$y <- as.factor(vowel.test$y)
vowel.train$y <- as.factor(vowel.train$y)

set.seed(33833)
modFit <- train(y ~ ., data=vowel.train, method="rf", prox=TRUE)
varImp(modFit)
