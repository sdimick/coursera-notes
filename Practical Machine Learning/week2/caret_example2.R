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
