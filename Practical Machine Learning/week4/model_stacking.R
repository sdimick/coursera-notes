
# EXAMPLE WITH WAGE DATA

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
mod2 <- train(wage~., method="rf", data=training,
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
