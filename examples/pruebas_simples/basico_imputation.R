library(imputeTS)
library(forecast)


# tsAirgap is a example time series with missing data included in imputeTS package
x <- tsAirgap

plot(x)

#Replace missing data using na.kalman method from imputeTS
x <- na.kalman(x)

plot(x)

x <- na.interpolation(x)

plot(x)

#Perform a forecast using ets method from forecast
# The h parameter specifies how far in the future to forecast
result <- forecast(ets(x),h=10)

#This is the result
result$mean

plot(result)


##############################################

library(zoo)

j <- c(0,-1,-2,-1.1,0.1,0.9,2.1,1,-0.1,-1.1,-1.9,-1,0.1,NaN,NaN,NaN,0,-1,-2,-1,0,1.1,2,1.2,0.1)
j <- c(0.1,1,1.9,0.9,0,-1,-2,-1.1,0.1,0.9,2.1,1,-0.1,-1.1,-1.9,-1,0.1,NaN,NaN,NaN,0,-1,-2,-1,0,1.1,2,1.2,0.1,-0.9,-1.8,-0.8,0.1,1,2,1.1,0.1,NaN,NaN,NaN,NaN,NaN,NaN,NaN,0.1,-1,-2.1,-1.3,-0.2,0.9,1.9,1,0)

ts <- ts(j)
plot(ts)

x <- na.mean(ts)
plot(x)
x <- na.ma(ts)
plot(x)
x <- na.ma(ts,2)
plot(x)
x <- na.ma(ts,9)
plot(x)
x <- na.interpolation(ts,"linear")
plot(x)
x <- na.interp(ts, lambda = NULL)
plot(x)
x <- na.interpolation(ts,"spline")
plot(x)
x <- na.interpolation(ts,"stine")
plot(x)
x <- na.kalman(ts) # model="StructTS"
plot(x)
x <- na.kalman(ts,model="auto.arima")
plot(x)


x <- na.locf(ts)
plot(x)
x <- na.seadec(ts, algorithm = "kalman")
plot(x)
x <- na.seasplit(ts, algorithm = "kalman")
plot(x)


x <- na.aggregate(ts,2)
plot(x)
x <- na.approx(ts)
plot(x)
x <- na.StructTS(ts)
plot(x)

##############################################

library(mice)

data <- airquality
data[4:10,3] <- rep(NA,7)
data[1:5,4] <- NA

pMiss <- function(x){sum(is.na(x))/length(x)*100}
apply(data,2,pMiss)
apply(data,1,pMiss)

md.pattern(data)
data <- data[-c(5,6)]
summary(data)

tempData <- mice(data,m=5,maxit=50,meth='pmm',seed=500)
summary(tempData)

ts <- ts(data[1])
plot(ts)
tempData <- mice(data[1],m=5,maxit=50)

ts <- ts(data[2])
plot(ts)

###########################################################

# Perform imputation with auto.arima and Kalman filter
library(forecast)

## Airpass used as an example
data <-  AirPassengers
plot(data)

## Set missing values
data[c(10,13,15,50,51,52,53,54,55,60)] <-  NA
plot(data)

## Fit arima model
fit <- auto.arima(data)

## Use Kalman filter
kal <-  KalmanRun(data,fit$model)

tmp <-  which(fit$model$Z == 1)
id <- ifelse (length(tmp) == 1, tmp[1],tmp[2])

## Fill in the values
id.na <-which(is.na(data))
data[id.na] <- kal$states[id.na,id]
print(data)

##################################################################################

#' Transform a univariate time series to a matrix with lags as columns.
#' @param data The time series.
#' @param lags The maxi mum amount of lags to be created.
#' @return A data frame with the lags in the columns.
create.lags <-  function(data, lags = 0){
    if (lags < 1){
      warning("No lags introduced.")
      return(data)
    }
    data.new <-  data.frame(data[(lags+1):length(data)])
    cnames <-"x"
    for(i.lag in 1:lags)    {
      ind <-(lags + 1 - i.lag) : (length(data) - i.lag)
      data.new <- cbind(data.new,data[ind])
      cnames <- c(cnames, paste("lag", as.character(i.lag), sep = "_"))
    }
    colnames(data.new) <- cnames
    return(data.new)
  }


j <- c(0.1,1,1.9,0.9,0,-1,-2,-1.1,0.1,0.9,2.1,1,-0.1,-1.1,-1.9,-1,0.1,NaN,NaN,NaN,0,-1,-2,-1,0,1.1,2,1.2,0.1,-0.9,-1.8,-0.8,0.1,1,2,1.1,0.1,NaN,NaN,NaN,NaN,NaN,NaN,NaN,0.1,-1,-2.1,-1.3,-0.2,0.9,1.9,1,0)

ts <- ts(j)
plot(ts)

j2 <- create.lags(ts, lags = 1)
j3 <- create.lags(ts, lags = 5)

library(VIM)

res <- kNN(j3,variable="x",k=5)
plot(ts(res[1]))
     
library(mice)

res <- mice(j3,m=5,maxit=50,meth='pmm',seed=500)
plot(ts(complete(res,1)[1]))
