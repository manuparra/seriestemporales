

###############################Modelo aditivo prophet#####################################

library(prophet)

setwd("C:/Users/Kuko/Desktop/Series temporales/Pruebas R")

df <- read.csv('C:/Users/Kuko/Desktop/Series temporales/Pruebas R/example_wp_peyton_manning.csv')
plot(1:length(df$ds),df$y,type="l")
df$y <- log(df$y)
plot(1:length(df$ds),df$y,type="l")

m <- prophet(df)

future <- make_future_dataframe(m, periods = 365)
tail(future)

forecast <- predict(m, future)
tail(forecast[c('ds', 'yhat', 'yhat_lower', 'yhat_upper')])

plot(m, forecast)

prophet_plot_components(m, forecast)

plot(1:length(df$ds),df$y,type="l",xlim=c(min(time(forecast$ds)),max(time(forecast$ds))),ylim=c(min(df$y,forecast$yhat),max(df$y,forecast$yhat)))
lines(1:length(forecast$ds),forecast$yhat,type="l",col="red")


library(forecast)

accuracy(df$y,forecast$yhat[1:length(df$y)])

###########################Alisado exponencial doble stat###################################

df <- read.csv('C:/Users/Kuko/Desktop/Series temporales/Pruebas R/example_wp_peyton_manning.csv')
plot(1:length(df$ds),df$y,type="l")
df$y <- log(df$y)
plot(1:length(df$ds),df$y,type="l")

j <- ts(df$y,frequency=365)

aliHW <- HoltWinters(j)
pred.aliHW <- predict(aliHW, n.ahead=365, prediction.interval=FALSE)

#plot(aliHW, pred.aliHW)
plot(1:length(df$ds),df$y,type="l",xlim=c(min(time(df$ds)),max(time(df$ds))+365),ylim=c(min(df$y,aliHW$fitted[,1],pred.aliHW),max(df$y,aliHW$fitted[,1],pred.aliHW)))
lines(366:length(df$y),aliHW$fitted[,1],col="blue")
lines((length(df$ds)+1):(length(df$ds)+365),pred.aliHW,type="l",col="blue")

accuracy(df$y[366:length(df$y)],aliHW$fitted[,1])

#################################red neuronal forecast######################################

df <- read.csv('C:/Users/Kuko/Desktop/Series temporales/Pruebas R/example_wp_peyton_manning.csv')
plot(1:length(df$ds),df$y,type="l")
df$y <- log(df$y)
plot(1:length(df$ds),df$y,type="l")

#df$y = (df$y-min(df$y))/(max(df$y)-min(df$y))
df$y <- scale(df$y)
j <- ts(df$y,frequency=365)

fit <- nnetar(j)

f.nn <- forecast(fit,h=365)
plot(f.nn)

plot(1:length(df$ds),df$y,type="l",xlim=c(min(time(df$ds)),max(time(df$ds))+365),ylim=c(min(df$y,fit$fitted,f.nn$mean,na.rm=TRUE),max(df$y,fit$fitted,f.nn$mean,na.rm=TRUE)))
lines(1:length(df$y),fit$fitted,col="green")
lines((length(df$ds)+1):(length(df$ds)+365),f.nn$mean,col="green")

accuracy(df$y[366:length(df$y)],fit$fitted)

##########################################ARIMA forecast##################################

df <- read.csv('C:/Users/Kuko/Desktop/Series temporales/Pruebas R/example_wp_peyton_manning.csv')
plot(1:length(df$ds),df$y,type="l")
df$y <- log(df$y)
plot(1:length(df$ds),df$y,type="l")

j <- ts(df$y,frequency=365)

h <- auto.arima(j,stepwise=FALSE,approximation=FALSE)

arima <- Arima(j,model=h)

f <- forecast(arima,h=365)
plot(f)



plot(1:length(df$ds),df$y,type="l",xlim=c(min(time(df$ds)),max(time(df$ds))+365),ylim=c(min(df$y,f$fitted,f$mean,na.rm=TRUE),max(df$y,f$fitted,f$mean,na.rm=TRUE)))
lines(1:length(df$y),f$fitted,col="orange")
lines((length(df$ds)+1):(length(df$ds)+365),f$mean,col="orange")


accuracy(df$y,f$fitted)



par(mfrow=c(2,2))
plot(1:length(df$ds),df$y,type="l",xlim=c(min(time(forecast$ds)),max(time(forecast$ds))),ylim=c(min(df$y,forecast$yhat),max(df$y,forecast$yhat)),main="Prophet (MAE=0.33 RMSE=0.48)",xlab="time",ylab="y")
lines(1:length(forecast$ds),forecast$yhat,type="l",col="red")
plot(1:length(df$ds),df$y,type="l",xlim=c(min(time(df$ds)),max(time(df$ds))+365),ylim=c(min(df$y,aliHW$fitted[,1],pred.aliHW),max(df$y,aliHW$fitted[,1],pred.aliHW)),main="Holt Winter (MAE=0.37 RMSE=0.54",xlab="time",ylab="y")
lines(366:length(df$y),aliHW$fitted[,1],col="blue")
lines((length(df$ds)+1):(length(df$ds)+365),pred.aliHW,type="l",col="blue")
plot(1:length(df$ds),df$y,type="l",xlim=c(min(time(df$ds)),max(time(df$ds))+365),ylim=c(min(df$y,f$fitted,f$mean,na.rm=TRUE),max(df$y,f$fitted,f$mean,na.rm=TRUE)),main="auto.arima (MAE=0.28 RMSE=0.42)",xlab="time",ylab="y")
lines(1:length(df$y),f$fitted,col="orange")
lines((length(df$ds)+1):(length(df$ds)+365),f$mean,col="orange")
plot(1:length(df$ds),df$y,type="l",xlim=c(min(time(df$ds)),max(time(df$ds))+365),ylim=c(min(df$y,fit$fitted,f.nn$mean,na.rm=TRUE),max(df$y,fit$fitted,f.nn$mean,na.rm=TRUE)),main="nnetar (MAE=0.73 RMSE=1.01)",xlab="time",ylab="y")
lines(1:length(df$y),fit$fitted,col="green")
lines((length(df$ds)+1):(length(df$ds)+365),f.nn$mean,col="green")


#########################################COMPARACIÓN####################################################

library(forecast)
library(prophet)

plot(AirPassengers)

AirPassengers <- log(AirPassengers)

df <- data.frame(time(AirPassengers),AirPassengers[1:length(AirPassengers)])
colnames(df) <- c("ds","y")
y <- (AirPassengers-min(AirPassengers))/(max(AirPassengers)-min(AirPassengers))

m <- prophet(df)
aliHW <- HoltWinters(AirPassengers)
h <- auto.arima(AirPassengers,stepwise=FALSE,approximation=FALSE)
arima <- Arima(AirPassengers,model=h)
fit <- nnetar(y)

future <- make_future_dataframe(m, periods = 20, freq = 'm')
forecast <- predict(m, future)
pred.aliHW <- predict(aliHW, n.ahead=20, prediction.interval=FALSE)
f <- forecast(arima,h=20)
f.nn <- forecast(fit,h=20)




accuracy(df$y,forecast$yhat[1:length(df$y)])
accuracy(AirPassengers[13:length(AirPassengers)],aliHW$fitted[,1])
accuracy(AirPassengers[1:length(AirPassengers)],f$fitted)
accuracy(y[13:length(y)],fit$fitted[13:length(fit$fitted)])


par(mfrow=c(2,2))
plot(1:length(df$ds),df$y,type="l",xlim=c(min(time(forecast$ds)),max(time(forecast$ds))),ylim=c(min(df$y,forecast$yhat),max(df$y,forecast$yhat)),main="Prophet (MAE=0.026 RMSE=0.033)",xlab="time",ylab="y")
lines(1:length(forecast$ds),forecast$yhat,type="l",col="red")
plot(1:length(AirPassengers),AirPassengers[1:length(AirPassengers)],type="l",xlim=c(0,length(AirPassengers)+20),ylim=c(min(AirPassengers[1:length(AirPassengers)],aliHW$fitted[,1],pred.aliHW),max(AirPassengers[1:length(AirPassengers)],aliHW$fitted[,1],pred.aliHW)),main="Holt Winter (MAE=0.029 RMSE=0.039)",xlab="time",ylab="y")
lines(13:length(AirPassengers),aliHW$fitted[,1],col="blue")
lines((length(AirPassengers)+1):(length(AirPassengers)+20),pred.aliHW,type="l",col="blue")
plot(1:length(AirPassengers),AirPassengers[1:length(AirPassengers)],type="l",xlim=c(0,length(AirPassengers)+20),ylim=c(min(AirPassengers[1:length(AirPassengers)],f$fitted,f$mean),max(AirPassengers[1:length(AirPassengers)],f$fitted,f$mean)),main="auto.arima (MAE=0.026 RMSE=0.035)",xlab="time",ylab="y")
lines(1:length(df$y),f$fitted,col="orange")
lines((length(AirPassengers)+1):(length(AirPassengers)+20),f$mean,col="orange")
plot(1:length(y),y[1:length(y)],type="l",xlim=c(0,length(AirPassengers)+20),ylim=c(min(y[1:length(y)],fit$fitted,f.nn$mean,na.rm=TRUE),max(y[1:length(y)],fit$fitted,f.nn$mean,na.rm=TRUE)),main="nnetar (MAE=0.023 RMSE=0.029)",xlab="time",ylab="y")
lines(1:length(y),fit$fitted,col="green")
lines((length(y)+1):(length(y)+20),f.nn$mean,col="green")


