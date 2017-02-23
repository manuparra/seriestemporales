######################FEED FORWARD NEURAL NETWORK - FORECAST PACKAGE#######################
###########################################################################################

library(fpp)
library(forecast)

plot(sunspotarea)

fit <- nnetar(sunspotarea)
#fit <- nnetar(sunspotarea,size=10,repeats=30)

f <- forecast(fit,h=20)
plot(f)


plot(sunspotarea, xlim=c(min(time(sunspotarea)),max(time(f$mean))))
lines(fit$fitted,col="red")
lines(f$mean,col="blue")


##---------------------------------------------------------------------------------------

plot(lynx)

fit <- nnetar(lynx)
plot(forecast(fit,h=20))


plot(lynx, xlim=c(min(time(lynx)),max(time(forecast(fit,h=20)$mean))))
lines(fit$fitted,col="red")
lines(forecast(fit,h=20)$mean,col="blue")

##----------------------------------------------------------------------------------------

t <- seq(0,20,length=200)                       # time stamps
y <- ts(1 + 3*cos(4*t+2) +.2*t^2 + rnorm(200))      # the time series we want to predict

plot(y)

fit <- nnetar(y)
plot(forecast(fit,h=20))



plot(y, xlim=c(min(time(y)),max(time(forecast(fit,h=20)$mean))))
lines(fit$fitted,col="red")
lines(forecast(fit,h=20)$mean,col="blue")


##########################################################################################
########################FEED FORWARD NEURAL NETWORK - NNET PACKAGE########################
##########################################################################################

library(fpp)
library(nnet)
library(quantmod)

plot(sunspotarea)

#sunspotarea <- ts(scale(sunspotarea[1:length(sunspotarea)]),start=c(start(sunspotarea)[1],start(sunspotarea)[2]),end=c(end(sunspotarea)[1],end(sunspotarea)[2]))
sunspotarea = (sunspotarea-min(sunspotarea))/(max(sunspotarea)-min(sunspotarea))

plot(sunspotarea)

# ar(sunspotarea)$order   # nos dice de orden 9, luego 9 rezagos

dat <- data.frame(sunspotarea, Lag(sunspotarea[1:length(sunspotarea)],1), Lag(sunspotarea[1:length(sunspotarea)],2),Lag(sunspotarea[1:length(sunspotarea)],3), Lag(sunspotarea[1:length(sunspotarea)],4), Lag(sunspotarea[1:length(sunspotarea)],5), Lag(sunspotarea[1:length(sunspotarea)],6), Lag(sunspotarea[1:length(sunspotarea)],7), Lag(sunspotarea[1:length(sunspotarea)],8), Lag(sunspotarea[1:length(sunspotarea)],9)) # create with lagged values
head(dat)

fit <- nnet(sunspotarea ~ Lag.1+Lag.2+Lag.3+Lag.4+Lag.5+Lag.6+Lag.7+Lag.8+Lag.9,data=dat,size=5,linout=T,decay=0.1)

ps <- predict(fit, dat)

#Examine results
plot(time(sunspotarea)[1:length(sunspotarea)],sunspotarea[1:length(sunspotarea)],type="l",col = 2)
lines(time(sunspotarea)[1:length(sunspotarea)],ps, col=3)


# Prediction
pred <- myPrediction(sunspotarea,fit,9,20,colnames(dat[2:length(dat)]),"nnet")

#Examine prediction
plot(time(sunspotarea)[1:length(sunspotarea)],sunspotarea[1:length(sunspotarea)],type="l",xlim=c(min(time(sunspotarea)),max(max(time(sunspotarea))+20)),ylim=c(min(sunspotarea,pred),max(sunspotarea,pred)))
lines(time(sunspotarea)[1:length(sunspotarea)],ps, col="red")
lines(seq(max(time(sunspotarea)),max(time(sunspotarea))+20,length=20), pred, col="blue")

##----------------------------------------------------------------------------------------

plot(lynx)

#lynx <- ts(scale(lynx[1:length(lynx)]),start=c(start(lynx)[1],start(lynx)[2]),end=c(end(lynx)[1],end(lynx)[2]))
lynx = (lynx-min(lynx))/(max(lynx)-min(lynx))

plot(lynx)

# ar(lynx)$order   # nos dice de orden 8, luego 8 rezagos

dat <- data.frame(lynx, Lag(lynx[1:length(lynx)],1), Lag(lynx[1:length(lynx)],2),Lag(lynx[1:length(lynx)],3), Lag(lynx[1:length(lynx)],4), Lag(lynx[1:length(lynx)],5), Lag(lynx[1:length(lynx)],6), Lag(lynx[1:length(lynx)],7), Lag(lynx[1:length(lynx)],8)) # create a triple with lagged values
head(dat)

fit <- nnet(lynx ~ Lag.1+Lag.2+Lag.3+Lag.4+Lag.5+Lag.6+Lag.7+Lag.8,data=dat,size=5,linout=T,decay=0.1)

ps <- predict(fit, dat)

#Examine results
plot(time(lynx)[1:length(lynx)],lynx[1:length(lynx)],type="l",col = 2)
lines(time(lynx)[1:length(lynx)],ps, col=3)


# Prediction
pred <- myPrediction(lynx,fit,8,20,colnames(dat[2:length(dat)]),"nnet")

#Examine prediction
plot(time(lynx)[1:length(lynx)],lynx[1:length(lynx)],type="l",xlim=c(min(time(lynx)),max(max(time(lynx))+20)),ylim=c(min(lynx,pred),max(lynx,pred)))
lines(time(lynx)[1:length(lynx)],ps, col="red")
lines(seq(max(time(lynx)),max(time(lynx))+20,length=20), pred, col="blue")

##----------------------------------------------------------------------------------------


t <- seq(0,20,length=200)                       # time stamps
y <- 1 + 3*cos(4*t+2) +.2*t^2 + rnorm(200)      # the time series we want to predict

y = (y-min(y))/(max(y)-min(y))

plot(t,y,type="l")

dat <- data.frame(y, x1=Lag(y,1), x2=Lag(y,2)) # create a triple with lagged values
names(dat) <- c('y','x1','x2')
head(dat)

fit <- nnet(y ~ x1+x2,data=dat,size=10,linout=T)

ps <- predict(fit, dat)

#Examine results
plot(t,y,type="l",col = 2)
lines(t,ps, col=3)

# Prediction
pred <- myPrediction(y,fit,9,20,colnames(dat[2:length(dat)]),"nnet")

#Examine prediction
plot(t,y,type="l",xlim=c(min(t),max(max(t)+20*(t[2]-t[1]))),ylim=c(min(y),max(pred)))
lines(t,ps, col="red")
lines(seq(t[length(t)],t[length(t)]+20*(t[2]-t[1]),length=20), pred, col="blue")


##########################################################################################
###################FEED FORWARD NEURAL NETWORK - NEURALNET PACKAGE########################
##########################################################################################

library(fpp)
library(neuralnet)
library(quantmod)

# NEURALNET no funciona con valores perdidos NA, luego para entrenar la red neuronal
# habría que imputar o no entrenar los valores lageados con NA

plot(sunspotarea)

#sunspotarea <- ts(scale(sunspotarea[1:length(sunspotarea)]),start=c(start(sunspotarea)[1],start(sunspotarea)[2]),end=c(end(sunspotarea)[1],end(sunspotarea)[2]))
sunspotarea = (sunspotarea-min(sunspotarea))/(max(sunspotarea)-min(sunspotarea))

plot(sunspotarea)

# ar(sunspotarea)$order   # nos dice de orden 9, luego 9 rezagos

dat <- data.frame(sunspotarea[10:length(sunspotarea)], Lag(sunspotarea[1:length(sunspotarea)],1)[10:length(sunspotarea)], Lag(sunspotarea[1:length(sunspotarea)],2)[10:length(sunspotarea)],Lag(sunspotarea[1:length(sunspotarea)],3)[10:length(sunspotarea)], Lag(sunspotarea[1:length(sunspotarea)],4)[10:length(sunspotarea)], Lag(sunspotarea[1:length(sunspotarea)],5)[10:length(sunspotarea)], Lag(sunspotarea[1:length(sunspotarea)],6)[10:length(sunspotarea)], Lag(sunspotarea[1:length(sunspotarea)],7)[10:length(sunspotarea)], Lag(sunspotarea[1:length(sunspotarea)],8)[10:length(sunspotarea)], Lag(sunspotarea[1:length(sunspotarea)],9)[10:length(sunspotarea)]) # create with lagged values
colnames(dat) <- c("y",paste0("Lag.", 1:(ncol(dat)-1)))
head(dat)

fit <- neuralnet(y ~ Lag.1+Lag.2+Lag.3+Lag.4+Lag.5+Lag.6+Lag.7+Lag.8+Lag.9,data=dat,hidden=5)

ps <- compute(fit,dat[2:length(dat)])

#Examine results
plot(time(sunspotarea)[1:length(sunspotarea)],sunspotarea[1:length(sunspotarea)],type="l",col = 2)
lines(time(sunspotarea)[10:length(sunspotarea)],ps$net.result, col=3)


# Prediction
pred <- myPrediction(sunspotarea,fit,9,20,colnames(dat[2:length(dat)]),"neuralnet")

#Examine prediction
plot(time(sunspotarea)[1:length(sunspotarea)],sunspotarea[1:length(sunspotarea)],type="l",xlim=c(min(time(sunspotarea)),max(max(time(sunspotarea))+20)),ylim=c(min(sunspotarea,pred),max(sunspotarea,pred)))
lines(time(sunspotarea)[10:length(sunspotarea)],ps$net.result, col="red")
lines(seq(max(time(sunspotarea)),max(time(sunspotarea))+20,length=20), pred, col="blue")


##----------------------------------------------------------------------------------------

plot(lynx)

#lynx <- ts(scale(lynx[1:length(lynx)]),start=c(start(lynx)[1],start(lynx)[2]),end=c(end(lynx)[1],end(lynx)[2]))
lynx = (lynx-min(lynx))/(max(lynx)-min(lynx))

plot(lynx)

# ar(lynx)$order   # nos dice de orden 8, luego 8 rezagos

dat <- data.frame(lynx[9:length(lynx)], Lag(lynx[1:length(lynx)],1)[9:length(lynx)], Lag(lynx[1:length(lynx)],2)[9:length(lynx)],Lag(lynx[1:length(lynx)],3)[9:length(lynx)], Lag(lynx[1:length(lynx)],4)[9:length(lynx)], Lag(lynx[1:length(lynx)],5)[9:length(lynx)], Lag(lynx[1:length(lynx)],6)[9:length(lynx)], Lag(lynx[1:length(lynx)],7)[9:length(lynx)], Lag(lynx[1:length(lynx)],8)[9:length(lynx)]) # create a triple with lagged values
colnames(dat) <- c("y",paste0("Lag.", 1:(ncol(dat)-1)))
head(dat)

fit <- neuralnet(y ~ Lag.1+Lag.2+Lag.3+Lag.4+Lag.5+Lag.6+Lag.7+Lag.8,data=dat,hidden=5)

ps <- compute(fit, dat[2:length(dat)])

#Examine results
plot(time(lynx)[1:length(lynx)],lynx[1:length(lynx)],type="l",col = 2)
lines(time(lynx)[9:length(lynx)],ps$net.result, col=3)


# Prediction
pred <- myPrediction(lynx,fit,8,20,colnames(dat[2:length(dat)]),"neuralnet")

#Examine prediction
plot(time(lynx)[1:length(lynx)],lynx[1:length(lynx)],type="l",xlim=c(min(time(lynx)),max(max(time(lynx))+20)),ylim=c(min(lynx,pred),max(lynx,pred)))
lines(time(lynx)[9:length(lynx)],ps$net.result, col="red")
lines(seq(max(time(lynx)),max(time(lynx))+20,length=20), pred, col="blue")

##----------------------------------------------------------------------------------------


t <- seq(0,20,length=200)                       # time stamps
y <- 1 + 3*cos(4*t+2) +.2*t^2 + rnorm(200)      # the time series we want to predict

y = (y-min(y))/(max(y)-min(y))

plot(t,y,type="l")

dat <- data.frame(y[3:length(y)], x1=Lag(y,1)[3:length(y)], x2=Lag(y,2)[3:length(y)]) # create a triple with lagged values
names(dat) <- c('y','x1','x2')
head(dat)

fit <- neuralnet(y ~ x1+x2,data=dat,hidden=3)

ps <- compute(fit, dat[2:length(dat)])

#Examine results
plot(t,y,type="l",col = 2)
lines(t[3:length(t)],ps$net.result, col=3)

# Prediction
pred <- myPrediction(y,fit,2,20,colnames(dat[2:length(dat)]),"neuralnet")

#Examine prediction
plot(t,y,type="l",xlim=c(min(t),max(max(t)+20*(t[2]-t[1]))),ylim=c(min(y),max(pred)))
lines(t[3:length(t)],ps$net.result, col="red")
lines(seq(t[length(t)],t[length(t)]+20*(t[2]-t[1]),length=20), pred, col="blue")


##########################################################################################
###################FEED FORWARD NEURAL NETWORK - RSNNS PACKAGE############################
##########################################################################################

# RSNNS no funciona con valores perdidos NA, luego para entrenar la red neuronal
# habría que imputar o no entrenar los valores lageados con NA

library(fpp)
library(RSNNS)
library(quantmod)

plot(sunspotarea)

#sunspotarea <- ts(scale(sunspotarea[1:length(sunspotarea)]),start=c(start(sunspotarea)[1],start(sunspotarea)[2]),end=c(end(sunspotarea)[1],end(sunspotarea)[2]))
#sunspotarea <- (sunspotarea-min(sunspotarea))/(max(sunspotarea)-min(sunspotarea))
sunspotarea <- ts(normalizeData(sunspotarea[1:length(sunspotarea)]),start=c(start(sunspotarea)[1],start(sunspotarea)[2]),end=c(end(sunspotarea)[1],end(sunspotarea)[2]))

plot(sunspotarea)

# ar(sunspotarea)$order   # nos dice de orden 9, luego 9 rezagos

dat <- data.frame(sunspotarea[10:length(sunspotarea)], Lag(sunspotarea[1:length(sunspotarea)],1)[10:length(sunspotarea)], Lag(sunspotarea[1:length(sunspotarea)],2)[10:length(sunspotarea)],Lag(sunspotarea[1:length(sunspotarea)],3)[10:length(sunspotarea)], Lag(sunspotarea[1:length(sunspotarea)],4)[10:length(sunspotarea)], Lag(sunspotarea[1:length(sunspotarea)],5)[10:length(sunspotarea)], Lag(sunspotarea[1:length(sunspotarea)],6)[10:length(sunspotarea)], Lag(sunspotarea[1:length(sunspotarea)],7)[10:length(sunspotarea)], Lag(sunspotarea[1:length(sunspotarea)],8)[10:length(sunspotarea)], Lag(sunspotarea[1:length(sunspotarea)],9)[10:length(sunspotarea)]) # create with lagged values
colnames(dat) <- c("y",paste0("Lag.", 1:(ncol(dat)-1)))
head(dat)

fit <- mlp(dat[2:length(dat)],dat[1],size=5,linOut=T)

ps <- predict(fit, dat[2:length(dat)])

#Examine results
plot(time(sunspotarea)[1:length(sunspotarea)],sunspotarea[1:length(sunspotarea)],type="l",col = 2)
lines(time(sunspotarea)[10:length(sunspotarea)],ps, col=3)


# Prediction
pred <- myPrediction(sunspotarea,fit,9,20,colnames(dat[2:length(dat)]),"rsnns")


#Examine prediction
plot(time(sunspotarea)[1:length(sunspotarea)],sunspotarea[1:length(sunspotarea)],type="l",xlim=c(min(time(sunspotarea)),max(max(time(sunspotarea))+20)),ylim=c(min(sunspotarea,pred),max(sunspotarea,pred)))
lines(time(sunspotarea)[10:length(sunspotarea)],ps, col="red")
lines(seq(max(time(sunspotarea)),max(time(sunspotarea))+20,length=20), pred, col="blue")



##----------------------------------------------------------------------------------------

plot(lynx)

#lynx <- ts(scale(lynx[1:length(lynx)]),start=c(start(lynx)[1],start(lynx)[2]),end=c(end(lynx)[1],end(lynx)[2]))
#lynx = (lynx-min(lynx))/(max(lynx)-min(lynx))
lynx <- ts(normalizeData(lynx[1:length(lynx)]),start=c(start(lynx)[1],start(lynx)[2]),end=c(end(lynx)[1],end(lynx)[2]))

plot(lynx)

# ar(lynx)$order   # nos dice de orden 8, luego 8 rezagos

dat <- data.frame(lynx[9:length(lynx)], Lag(lynx[1:length(lynx)],1)[9:length(lynx)], Lag(lynx[1:length(lynx)],2)[9:length(lynx)],Lag(lynx[1:length(lynx)],3)[9:length(lynx)], Lag(lynx[1:length(lynx)],4)[9:length(lynx)], Lag(lynx[1:length(lynx)],5)[9:length(lynx)], Lag(lynx[1:length(lynx)],6)[9:length(lynx)], Lag(lynx[1:length(lynx)],7)[9:length(lynx)], Lag(lynx[1:length(lynx)],8)[9:length(lynx)]) # create a triple with lagged values
colnames(dat) <- c("y",paste0("Lag.", 1:(ncol(dat)-1)))
head(dat)

fit <- mlp(dat[2:length(dat)],dat[1],size=5,linOut=T)

ps <- predict(fit, dat[2:length(dat)])

#Examine results
plot(time(lynx)[1:length(lynx)],lynx[1:length(lynx)],type="l",col = 2)
lines(time(lynx)[9:length(lynx)],ps, col=3)


# Prediction
pred <- myPrediction(lynx,fit,8,20,colnames(dat[2:length(dat)]),"rsnns")

#Examine prediction
plot(time(lynx)[1:length(lynx)],lynx[1:length(lynx)],type="l",xlim=c(min(time(lynx)),max(max(time(lynx))+20)),ylim=c(min(lynx,pred),max(lynx,pred)))
lines(time(lynx)[9:length(lynx)],ps, col="red")
lines(seq(max(time(lynx)),max(time(lynx))+20,length=20), pred, col="blue")



##########################################################################################
########################FEED FORWARD NEURAL NETWORK - CARET PACKAGE########################
##########################################################################################

library(caret)
library(quantmod) 
library(nnet)
library(RSNNS)
library(neuralnet)

t <- seq(0,20,length=200)                       # time stamps
y <- 1 + 3*cos(4*t+2) +.2*t^2 + rnorm(200)      # the time series we want to predict

plot(t,y,type="l")

dat <- data.frame(y[3:length(y)], x1=Lag(y,1)[3:length(y)], x2=Lag(y,2)[3:length(y)]) # create a triple with lagged values
names(dat) <- c('y','x1','x2')
head(dat)

#Fit model
model.nnet <- train(y ~ x1+x2, data=dat, method='nnet',linout=TRUE, trace = FALSE)
model.neuralnet <- train(y ~ x1+x2, data=dat, method='neuralnet' ,trace = FALSE)
model.rsnns <- train(y ~ x1+x2, data=dat, method='mlp', size=5, trace = FALSE)


###########################################################################################
###################PARTIAL RECURRENT NEURAL NETWORK - RSNNS PACKAGE########################
###########################################################################################

# RSNNS no funciona con valores perdidos NA, luego para entrenar la red neuronal
# habría que imputar o no entrenar los valores lageados con NA

library(fpp)
library(RSNNS)
library(quantmod)

plot(sunspotarea)

#sunspotarea <- ts(scale(sunspotarea[1:length(sunspotarea)]),start=c(start(sunspotarea)[1],start(sunspotarea)[2]),end=c(end(sunspotarea)[1],end(sunspotarea)[2]))
#sunspotarea <- (sunspotarea-min(sunspotarea))/(max(sunspotarea)-min(sunspotarea))
sunspotarea <- ts(normalizeData(sunspotarea[1:length(sunspotarea)]),start=c(start(sunspotarea)[1],start(sunspotarea)[2]),end=c(end(sunspotarea)[1],end(sunspotarea)[2]))

plot(sunspotarea)

# ar(sunspotarea)$order   # nos dice de orden 9, luego 9 rezagos

dat <- data.frame(sunspotarea[10:length(sunspotarea)], Lag(sunspotarea[1:length(sunspotarea)],1)[10:length(sunspotarea)], Lag(sunspotarea[1:length(sunspotarea)],2)[10:length(sunspotarea)],Lag(sunspotarea[1:length(sunspotarea)],3)[10:length(sunspotarea)], Lag(sunspotarea[1:length(sunspotarea)],4)[10:length(sunspotarea)], Lag(sunspotarea[1:length(sunspotarea)],5)[10:length(sunspotarea)], Lag(sunspotarea[1:length(sunspotarea)],6)[10:length(sunspotarea)], Lag(sunspotarea[1:length(sunspotarea)],7)[10:length(sunspotarea)], Lag(sunspotarea[1:length(sunspotarea)],8)[10:length(sunspotarea)], Lag(sunspotarea[1:length(sunspotarea)],9)[10:length(sunspotarea)]) # create with lagged values
colnames(dat) <- c("y",paste0("Lag.", 1:(ncol(dat)-1)))
head(dat)

fit.j <- jordan(dat[2:length(dat)],dat[1],size=5,linOut=T)
fit.e <- elman(dat[2:length(dat)],dat[1],size=5,linOut=T)

ps.j <- predict(fit.j, dat[2:length(dat)])
ps.e <- predict(fit.e, dat[2:length(dat)])

#Examine results
plot(time(sunspotarea)[1:length(sunspotarea)],sunspotarea[1:length(sunspotarea)],type="l",col = 2)
lines(time(sunspotarea)[10:length(sunspotarea)],ps.j, col=3)

plot(time(sunspotarea)[1:length(sunspotarea)],sunspotarea[1:length(sunspotarea)],type="l",col = 2)
lines(time(sunspotarea)[10:length(sunspotarea)],ps.e, col=3)


# Prediction
pred.j <- myPrediction(sunspotarea,fit.j,9,20,colnames(dat[2:length(dat)]),"rsnns")
pred.e <- myPrediction(sunspotarea,fit.e,9,20,colnames(dat[2:length(dat)]),"rsnns")

#Examine prediction
plot(time(sunspotarea)[1:length(sunspotarea)],sunspotarea[1:length(sunspotarea)],type="l",xlim=c(min(time(sunspotarea)),max(max(time(sunspotarea))+20)),ylim=c(min(sunspotarea,pred),max(sunspotarea,pred)))
lines(time(sunspotarea)[10:length(sunspotarea)],ps.j, col="red")
lines(seq(max(time(sunspotarea)),max(time(sunspotarea))+20,length=20), pred.j, col="blue")

plot(time(sunspotarea)[1:length(sunspotarea)],sunspotarea[1:length(sunspotarea)],type="l",xlim=c(min(time(sunspotarea)),max(max(time(sunspotarea))+20)),ylim=c(min(sunspotarea,pred),max(sunspotarea,pred)))
lines(time(sunspotarea)[10:length(sunspotarea)],ps.e, col="red")
lines(seq(max(time(sunspotarea)),max(time(sunspotarea))+20,length=20), pred.e, col="blue")

##----------------------------------------------------------------------------------------



###########################################################################################
#+++++++++++++++++++++COMPARACIÓN ENTRE LOS MODELOS ANTERIORES+++++++++++++++++++++++++++++
###########################################################################################

library(fpp)
library(quantmod) 
library(forecast) 
library(nnet)
library(neuralnet)
library(RSNNS)

plot(sunspotarea)

# Normalización con media 0 y desviación estándar 1
sunspotarea <- ts(scale(sunspotarea[1:length(sunspotarea)]),start=c(start(sunspotarea)[1],start(sunspotarea)[2]),end=c(end(sunspotarea)[1],end(sunspotarea)[2]))

plot(sunspotarea)

# ar(sunspotarea)$order   # nos dice de orden 9, luego 9 rezagos

# Se preparan los datos. Naturales para FORECAST, con rezagos y NA para NNET y con rezagos y sin NA para NEURALNET y RSNNS
dat1 <- data.frame(sunspotarea, Lag(sunspotarea[1:length(sunspotarea)],1), Lag(sunspotarea[1:length(sunspotarea)],2),Lag(sunspotarea[1:length(sunspotarea)],3), Lag(sunspotarea[1:length(sunspotarea)],4), Lag(sunspotarea[1:length(sunspotarea)],5), Lag(sunspotarea[1:length(sunspotarea)],6), Lag(sunspotarea[1:length(sunspotarea)],7), Lag(sunspotarea[1:length(sunspotarea)],8), Lag(sunspotarea[1:length(sunspotarea)],9)) # create with lagged values
colnames(dat1) <- c("y",paste0("Lag.", 1:(ncol(dat1)-1)))
head(dat1)
dat2 <- data.frame(sunspotarea[10:length(sunspotarea)], Lag(sunspotarea[1:length(sunspotarea)],1)[10:length(sunspotarea)], Lag(sunspotarea[1:length(sunspotarea)],2)[10:length(sunspotarea)],Lag(sunspotarea[1:length(sunspotarea)],3)[10:length(sunspotarea)], Lag(sunspotarea[1:length(sunspotarea)],4)[10:length(sunspotarea)], Lag(sunspotarea[1:length(sunspotarea)],5)[10:length(sunspotarea)], Lag(sunspotarea[1:length(sunspotarea)],6)[10:length(sunspotarea)], Lag(sunspotarea[1:length(sunspotarea)],7)[10:length(sunspotarea)], Lag(sunspotarea[1:length(sunspotarea)],8)[10:length(sunspotarea)], Lag(sunspotarea[1:length(sunspotarea)],9)[10:length(sunspotarea)]) # create with lagged values
colnames(dat2) <- c("y",paste0("Lag.", 1:(ncol(dat2)-1)))
head(dat2)

# Se ajustan los modelos, con 5 neuronas en la capa oculta para todos y resto de parámetros por defecto
fit.forecast <- nnetar(sunspotarea, size=5)
fit.nnet <- nnet(sunspotarea ~ Lag.1+Lag.2+Lag.3+Lag.4+Lag.5+Lag.6+Lag.7+Lag.8+Lag.9,data=dat1,size=5,linout=T)
fit.neuralnet <- neuralnet(y ~ Lag.1+Lag.2+Lag.3+Lag.4+Lag.5+Lag.6+Lag.7+Lag.8+Lag.9,data=dat2,hidden=5)
fit.rsnns <- mlp(dat2[2:length(dat2)],dat2[1],size=5,linOut=T)
fit.jordan <- jordan(dat2[2:length(dat2)],dat2[1],size=5,linOut=T)
fit.elman <- elman(dat2[2:length(dat2)],dat2[1],size=5,linOut=T)

par(mfrow=c(3,2))
plot(sunspotarea,main="Package Forecast FF",ylab="Sunspotarea",xlab="Time")
lines(fit.forecast$fitted,col="red")
plot(time(sunspotarea)[1:length(sunspotarea)],sunspotarea[1:length(sunspotarea)],type="l",main="Package NNET FF",ylab="Sunspotarea",xlab="Time")
lines(time(sunspotarea)[1:length(sunspotarea)],predict(fit.nnet, dat1), col="green")
plot(time(sunspotarea)[1:length(sunspotarea)],sunspotarea[1:length(sunspotarea)],type="l",main="Package NeuralNet FF",ylab="Sunspotarea",xlab="Time")
lines(time(sunspotarea)[10:length(sunspotarea)],compute(fit.neuralnet,dat2[2:length(dat2)])$net.result, col="purple")
plot(time(sunspotarea)[1:length(sunspotarea)],sunspotarea[1:length(sunspotarea)],type="l",main="Package RSNNS FF",ylab="Sunspotarea",xlab="Time")
lines(time(sunspotarea)[10:length(sunspotarea)],predict(fit.rsnns, dat2[2:length(dat2)]), col="blue")
plot(time(sunspotarea)[1:length(sunspotarea)],sunspotarea[1:length(sunspotarea)],type="l",main="Package RSNNS Jordan",ylab="Sunspotarea",xlab="Time")
lines(time(sunspotarea)[10:length(sunspotarea)],predict(fit.jordan, dat2[2:length(dat2)]), col="orange")
plot(time(sunspotarea)[1:length(sunspotarea)],sunspotarea[1:length(sunspotarea)],type="l",main="Package RSNNS Elman",ylab="Sunspotarea",xlab="Time")
lines(time(sunspotarea)[10:length(sunspotarea)],predict(fit.elman, dat2[2:length(dat2)]), col="brown")



med.forecast <- accuracy(sunspotarea[1:length(sunspotarea)],fit.forecast$fitted[1:length(fit.forecast$fitted)])
med.nnet <- accuracy(sunspotarea[1:length(sunspotarea)],predict(fit.nnet, dat1))
med.neuralnet <- accuracy(sunspotarea[10:length(sunspotarea)],compute(fit.neuralnet,dat2[2:length(dat2)])$net.result)
med.rsnnr <- accuracy(sunspotarea[10:length(sunspotarea)],predict(fit.rsnns, dat2[2:length(dat2)]))
med.rsnnr.jordan <- accuracy(sunspotarea[10:length(sunspotarea)],predict(fit.jordan, dat2[2:length(dat2)]))
med.rsnnr.elman <- accuracy(sunspotarea[10:length(sunspotarea)],predict(fit.elman, dat2[2:length(dat2)]))



plot(1:6,c(med.forecast[2],med.nnet[2],med.neuralnet[2],med.rsnnr[2],med.rsnnr.jordan[2],med.rsnnr.elman[2]),main="rmse")
plot(1:6,c(med.forecast[3],med.nnet[3],med.neuralnet[3],med.rsnnr[3],med.rsnnr.jordan[3],med.rsnnr.elman[3]),main="mae")














#################FUNCIÓN DE PREDICCIÓN EN SERIES TEMPORALES LAGEADAS#######################
###########################################################################################


myPrediction <- function(data, fit, lag, n.ahead, colnames,type){
  
  y <- data
  ahead <- n.ahead
  pred <- NULL
  
  # Un rezago por defecto
  imputs <- data.frame(y[length(y)])
  
  if(lag>1){
    for(i in 1:(lag-1)){
      imputs[i+1] <- data.frame(y[length(y)-i])    # Tantos como rezagos hayas incluido en el ajuste del modelo
    }
  }
  #colnames(imputs) <- paste0("x", 1:ncol(imputs))
  colnames(imputs) <- colnames
  
  for(i in 1:ahead){
    
    if(type=="neuralnet"){
      pred[i] <- compute(fit, imputs)$net.result
    }else{
      pred[i] <- predict(fit, imputs)
    }
    
    for(j in lag:1){
      if(j==1){
        imputs[j] <- pred[i]
      }else{
        imputs[j] <- imputs[j-1]
      }
    }

  }
  
  return(pred)
}