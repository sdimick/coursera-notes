library(quantmod) #get financial data
library(forecast)
from.dat <- as.Date("01/01/08", format="%m/%d/%y")
to.dat <- as.Date("12/31/13", format="%m/%d/%y")
getSymbols("GOOG", src="google", from=from.dat, to=to.dat)

# Volume Missing??
GOOG <- GOOG[,1:4]

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
ets1 <- ets(ts1Train, model="MMM")
fcast <- forecast(ets1)
plot(fcast)
lines(ts1Test, col="red")
accuracy(fcast, ts1Test)
