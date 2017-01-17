library(tseries)
library(psych)
library(forecast)


#Limpio la broza
rm(list=ls()) 

#Leemos la serie
serie <-scan("serie2.dat")
#Convertimos la serie a TS datatype y parametrizamos 
#el tiempo de inicio y frecuencia.
serie.ts <- ts(serie, start=c(1875,1))
serie.ts <- log(serie.ts)


#Dibujamos la serie completa
png(file="serie2_inicial.png", bg="transparent",width = 800, height = 350)
plot(serie.ts,xlab="Trimestre",ylab="Población")
dev.off()

#Hacemos la descomposicion en componentes.
png(file="serie2_descompose.png", bg="transparent",width = 800, height = 350)
serie.decompose <- decompose (serie.ts,type="mult")
plot( serie.decompose)
dev.off()

#Hacemos la descomposicion en componentes con STL
png(file="serie2_stl.png", bg="transparent",width = 800, height = 350)
serie.stl <- stl (serie.ts,s.window="periodic")
plot( serie.stl)
dev.off()

#Estadistica básica sobre los datos.
describe (serie)

#Superposicion de la tendencia y el componente estacional
#trend <- serie.decompose$trend
#seasonal <- serie.decompose$seasonal
#ts.plot(cbind(trend,trend*seasonal),lty=1:2)

#png(file="serie2_logged_diffed.png", bg="transparent",width = 800, height = 400)
#par(mfrow=c(1,2))
#plot(serie.ts, type="o", col="blue", lty="dashed")
#plot(diff(serie.ts), main="logged and diffed") 
#dev.off()

#Usamos  el test KPSS para comprobar si es o no estacionaria
kpss_test <- kpss.test(serie.ts, null = "Trend")
#P-value = 0.01, 

#Verificamos ACF y PACF para comprobar si hay o no Tend/Estac.
png(file="serie2_acf_pacf.png", bg="transparent",width = 800, height = 400)
par(mfrow=c(1,2))
acf(serie.ts)
pacf(serie.ts)
dev.off()
result <- adf.test(serie.ts, alternative = "stationary")
cat("Test devuelve Dickey-Fuller con un p-value=", result$p.value, "\n")


#Ajustamos los datos al modelo lineal
tiempo <- 1:length(serie)
parametros <- lm (serie ~ tiempo)
TendEstimada<-parametros$coefficients[1]+tiempo*parametros$coefficients[2] 
series<-matrix(c(t(serie), t(TendEstimada)), ncol=2); # Mostramos resultado
png(file="serie2_lm.png", bg="transparent",width = 800, height = 400)
par(mfrow=c(1,1))
matplot(series, pch=1, type= "l")
dev.off()


#Descartamos el modelo lineal
JBtr <- jarque.bera.test(parametros$residuals)
TT <- t.test(c(parametros$residuals,TendEstimada-serie))

#Como no usamos el modelo de tendencia, pues usamos la serie en si
SerSinTend<-serie;

plot.ts(SerSinTend)



# #Probamos con Filtro de medias moviles:
# for (k in 3:5) {
#   filtro<-rep(1/k, k); # Creamos el filtro
#   # Filtramos señal
#   SerFiltrada<-filter(serie,filter=filtro,sides=2,method="convolution")
#   # Mostramos en la misma figura la serie y la tendencia estimada
#   series<-matrix(c(t(serie), t(SerFiltrada)), ncol=2);
#   matplot(series, pch=1, type= "l")
#   
#   cat("Calculo tendencia con filtro de orden k=", k, "\n")
#   print("Pulse una tecla para continuar...")
#   pause<-readline(); # para pausar la ejecución
# }
# 
# SerSinTend2<-serie-SerFiltrada;
# #Mostramos ambas aproximaciones diferenciadas
# series<-matrix(c(t(SerSinTend), t(SerSinTend2)), ncol=2);
# matplot(series, pch=1, type= "l")
# 
# series<-matrix(c(t(SerSinTend), t(ser)), ncol=2);
# matplot(series, pch=1, type= "l")


#Como el filtro quita los valores iniciales y finales (2), quitamos los NA
#aux_filter<- SerSinTend2[!is.na(SerSinTend2)];

#Vemos los resultados de ACF y PACF para cada modelo de aprox.
acf(SerSinTend)
adf.test(SerSinTend)
pacf(SerSinTend)



#Buscamos si hay Estacionalidad.
tiempo <- 1:length(serie)
parametros <- lm (log(serie) ~ tiempo)
plot(parametros)
jarque.bera.test(parametros$residuals)


#Eliminamos la estacionalidad y la tendencia.
# Calculamos estacionalidad, con periodo k=43
k<- 10;
estacionalidad<-matrix(nrow=1, ncol=k);
estacionalidad[,]<- 0
for (i in 1:k) {
  secuencia<-seq(i, length(SerSinTend), by=k);
  for (j in secuencia) {
    estacionalidad[1,i]<- estacionalidad[1,i] + SerSinTend[j];
  }
  
  estacionalidad[1,i]<-estacionalidad[1,i]/length(secuencia);
}

plot.ts(as.numeric(estacionalidad))

# Mostramos la estacionalidad, repetida por toda la serie
#estacionalidad<-as.numeric(estacionalidad[1:43])
aux<-rep(estacionalidad,10);
auxTotal<- aux[1:86]
aux<- aux[1:12]

plot.ts(aux)
png(file="serie2_serie_estacion.png", bg="transparent",width = 800, height = 400)
series<-matrix(c(t(SerSinTend), t(aux)), ncol=2); 
matplot(series, pch=1, type= "l")
dev.off()

#Nos quedamos con la serie sin tendencia, ni estacionalidad.
SerSinTendEst<- SerSinTend-aux;
#Trazamos para ver como se ve la cosa
plot.ts(SerSinTendEst)

#Aplicamos el TEST Dickey-Fuller 
adf.test(diff(SerSinTendEst))
png(file="serie2_diff_acf.png", bg="transparent",width = 800, height = 400)
par(mfrow=c(1,2))
acf(diff(SerSinTendEst))
pacf(diff(SerSinTendEst))
dev.off()
#No obteneimos un p-value <=0.01

#Aplicamos dos diferenciaciones hasta que pase el test.
#Se aplican 2 diferenciaciones
#a.diff <- diff(SerSinTendEst)
#a.diff <- diff(a.diff)
#adf.test(a.diff)
#acf(a.diff)
#pacf(a.diff)
#Ya podemos entrever el modelo pues el test ha bajado de 0.01


#Modelo y prediccion
fit <- auto.arima(SerSinTendEst)
plot(forecast(fit))
modArima<-auto.arima(SerSinTendEst,D=5,max.P = 5, max.Q = 5)
#Nos da una idea de como podria ser.
modArima <- fit

fit = arima(SerSinTendEst, order = c(2,0,0))
modArima <- fit

#Elegimos un modelo probando varios prometedores
modelo321<- arima(SerSinTendEst, order=c(3, 2, 1)); # Ajustamos modelo
modelo320<- arima(SerSinTendEst, order=c(3, 2, 0)); # Ajustamos modelo
#Este parece el mejor, aunque 222 parece ser mas prometedor.
Acf(residuals(modelo320))
modelo330<- arima(SerSinTendEst, order=c(3, 3, 0)); # Ajustamos modelo
modelo430<- arima(SerSinTendEst, order=c(4, 3, 0)); # Ajustamos modelo
modelo222<- arima(SerSinTendEst, order=c(2, 2, 2)); # Ajustamos modelo

#Ajustamos los valores
valoresAjustados.H1 <- SerSinTendEst+modArima$residuals

#Extraemos las predicciones
Predicciones.H1 <- predict(modArima,n.ahead=12)
valoresPredichos.H1<- Predicciones.H1$pred

#Dibujamos la serie, los valores ajustados y los predichos.
plot.ts(SerSinTendEst)
lines(valoresAjustados.H1, col="blue")
lines(valoresPredichos.H1, col="red")

#Tests sobre el modelo
boxtestM1 <- Box.test(modArima$residuals)
JB.H1 <- jarque.bera.test(modArima$residuals)
SW.H1 <- shapiro.test(modArima$residuals)
#JB y SW tienen p-value <0.01 , luego se acepta el modelo.

#Reconstruimos el modelo:


tiempo <- 1:length(serie)
parametros <- glm (serie ~ tiempo)
TendEstimada<-parametros$coefficients[1]+tiempo*parametros$coefficients[2] 

tiempoPredicho<- (tiempo[length(tiempo)]+1):(tiempo[length(tiempo)]+3);
TendPredicha<-parametros$coefficients[1]+tiempoPredicho*parametros$coefficients[2]



plot.ts(SerSinTendEst)
lines(valoresAjustados.H1, col="blue")
lines(valoresPredichos.H1, col="red")

vvP <- valoresPredichos.H1 + aux
vvA <- valoresAjustados.H1 + auxTotal


#valoresAjustados <- valoresAjustados.H1 + aux
valoresPredichos <- valoresPredichos.H1 + TendPredicha
valoresAjustados <- valoresAjustados.H1 + TendEstimada

#Mostramos los datos.
png(file="serie2_predict.png", bg="transparent",width = 800, height = 400)
plot.ts(serie)
lines(vvP,col="red")
lines(vvA,col="blue")
dev.off()

#Imprimimos los resultados de 12 valores:
print ("VALORES PREDICHOS:")
print (valoresPredichos)

