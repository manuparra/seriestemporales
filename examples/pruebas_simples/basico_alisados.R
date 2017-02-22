

################################ALISADO EXPONENCIAL SIMPLE####################################

plot(sunspotarea)

NAO <- read.table("http://www.escet.urjc.es/biodiversos/R/NAO.txt", header=T, sep="\t")
NAO.ts <- ts(data=NAO$NAO, start=min(NAO$year), end=max(NAO$year))


alisim1 <- HoltWinters(NAO.ts, gamma=FALSE, beta=FALSE)
alisim1
par(cex.axis=1.5, cex.lab=1.5, cex.main=1.5)
plot(alisim1, ylab="Indice NAO", xlab="", main="")
title("Valores observados frente a predichos")
labs <- c("Valores observados", "Valores predichos")
legend("bottomright", lty=c(1,1), col=c("black", "red"), legend=labs)

alism1 <- ses(NAO.ts)
plot(alisim1, ylab="Indice NAO", xlab="", main="")


################################ALISADO EXPONENCIAL HOLT####################################

par(cex.axis=1.5, cex.lab=1.5, cex.main=1.5)
aliholt <- HoltWinters(uspop, gamma=FALSE)
aliholt
plot(aliholt, ylab="Población (millones hbts)", xlab="", main="")
title("Población de los EEUU")
labs <- c("Valores observados", "Valores predichos")
legend("topleft", lty=c(1,1), col=c("black", "red"), legend=labs)
par(cex.axis=1.5, cex.lab=1.5, cex.main=1.5)
pred.aliholt <- predict(aliholt, n.ahead=5, prediction.interval=TRUE)
plot(aliholt, pred.aliholt, ylab="Población (millones habts)", xlab="", main="")
title("Predicciones de la población en EEUU")
labs <- c("Valores observados", "Valores predichos", "IC de las predicciones")
legend("topleft", lty=rep(1,3), col=c("black", "red", "blue"), legend=labs)

aliholt <- holt(uspop,h=5)
plot(aliholt, ylab="Indice NAO", xlab="", main="")

###########################ALISADO EXPONENCIAL HOLT-WINTERS####################################

data(co2, package="TSA")
aliHW <- HoltWinters(co2)
aliHW
par(cex.axis=1.5, cex.lab=1.5, cex.main=1.5)
plot(aliHW, ylab="Concentración de CO2 (ppm)", xlab="", main="")
labs <- c("Valores observados", "Valores predichos")
legend("topleft", lty=c(1,1), col=c("black", "red"), legend=labs)
par(cex.axis=1.5, cex.lab=1.5, cex.main=1.5)
pred.aliHW <- predict(aliHW, n.ahead=120, prediction.interval=TRUE)
plot(aliHW, pred.aliHW, ylab="Concentracion de CO2 (ppm)", xlab="", main="")
title("Predicciones de la concentración de CO2")
labs <- c("Valores observados", "Valores predichos", "IC de las predicciones")
legend("topleft", lty=rep(1,3), col=c("black", "red", "blue"), legend=labs)

aliHW <- hw(co2,h=120)
plot(aliHW, ylab="Indice NAO", xlab="", main="")

##--------------------------------------------------------------------------------------

aliHW2 <- HoltWinters(AirPassengers, seasonal = "mult")
aliHW2

par(cex.axis=1.5, cex.lab=1.5, cex.main=1.5)
plot(aliHW2, ylab="Número de pasajeros", xlab="", main="")
title(main="Número de pasajeros en líneas internacionales (1949-1960)")
labs <- c("Valores observados", "Valores predichos")
legend("topleft", lty=c(1,1), col=c("black", "red"), legend=labs)

par(cex.axis=1.5, cex.lab=1.5, cex.main=1.5)
pred.aliHW2 <- forecast(aliHW2, h=120)
plot(pred.aliHW2, ylab="Concentracion de CO2 (ppm)", xlab="", main="")
title("Predicciones de la concentración de CO2")
labs <- c("Valores observados", "Valores predichos", "IC de las predicciones")
legend("topleft", lty=rep(1,3), col=c("black", "red", "blue"), legend=labs)
