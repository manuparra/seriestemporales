library(fpp) # To load the data set a10
plot(a10, ylab="$ million", xlab="Year", main="Antidiabetic drug sales")
plot(log(a10), ylab="", xlab="Year", main="Log Antidiabetic drug sales")


# plot(acf(diff(diff(log(a10),lag=12)),lag.max = frequency(a10)*20))
# plot(pacf(diff(diff(log(a10),lag=12)),lag.max = frequency(a10)*20))


k <- 60 # minimum data length for fitting a model
n <- length(a10)
mae1 <- matrix(NA,n-k,12)
mae2 <- matrix(NA,n-k,12)
st <- tsp(a10)[1]+(k-2)/12

for(i in 1:(n-k)){
  xshort <- window(a10, end=st + i/12)
  #xshort <- window(a10, start=st+(i-k+1)/12, end=st+i/12)
  xnext <- window(a10, start=st + (i+1)/12, end=st + (i+12)/12)

  fit1 <- Arima(xshort, order=c(3,0,1), seasonal=list(order=c(0,1,1), period=12), 
                include.drift=TRUE, lambda=0, method="ML")
  fcast1 <- forecast(fit1, h=12)

  mae1[i,1:length(xnext)] <- abs(fcast1[['mean']]-xnext)

  fit2 <- Arima(xshort, order=c(1,0,1), seasonal=list(order=c(0,0,1), period=12), 
                include.drift=TRUE, lambda=0, method="ML")
  fcast2 <- forecast(fit2, h=12)
  
  mae2[i,1:length(xnext)] <- abs(fcast2[['mean']]-xnext)  
}

plot(1:12, colMeans(mae1,na.rm=TRUE), type="l", col=2, xlab="horizon", ylab="MAE",ylim=c(0.65,1.25))
lines(1:12, colMeans(mae2,na.rm=TRUE), type="l",col=3)
legend("topleft",legend=c("ARIMA(3,0,1)(0,1,1)","ARIMA(1,0,1)(0,01)"),col=2:4,lty=1)


###################### One-step forecasts without re-estimation ############################

library(fpp)
plot(hsales)
train <- window(hsales,end=1989.99)
fit <- auto.arima(train)
refit <- Arima(hsales, model=fit)
fc <- window(fitted(refit), start=1990)
abs(fc-window(hsales, start=1990))
