#Cargamos librerias
library(tseries)
library(psych)
library(forecast)


#Liberamos los datos.
rm(list=ls()) 

#Leemos la serie
serie <-scan("serie1.dat")


#Convertimos la serie a TS datatype y parametrizamos 
#el tiempo de inicio y frecuencia.
serie.ts <- ts(serie, start=c(1971,2),frequency=4)

#Almacenamos la serie tal.
png(file="serie1_inicial.png", bg="transparent",width = 800, height = 350)
plot(serie.ts,xlab="Trimestre",ylab="Población")
dev.off()

#Hacemos la descomposicion en componentes.
png(file="serie1_descompose.png", bg="transparent",width = 800, height = 350)
serie.decompose <- decompose (serie.ts,type="mult")
plot( serie.decompose)
dev.off()

#Hacemos la descomposicion en componentes con STL
png(file="serie1_stl.png", bg="transparent",width = 800, height = 350)
serie.stl <- stl (serie.ts,s.window="periodic")
plot( serie.stl)
dev.off()

#Estadistica básica sobre los datos.
describe (serie)

#Superposicion de la tendencia y el componente estacional
trend <- serie.decompose$trend
seasonal <- serie.decompose$seasonal
ts.plot(cbind(trend,trend*seasonal),lty=1:2)

#Mostramos la diferencia y el log de la serie.
par(mfrow=c(1,2))
plot(serie.ts, type="o", col="blue", lty="dashed")
plot(diff(log(serie.ts)), main="logged and diffed") 


#Usamos  el test KPSS para comprobar si es o no estacionaria
kpps_test <- kpss.test(serie.ts, null = "Trend")
#P-value = 0.01, 

#Verificamos ACF y PACF para comprobar si hay o no Tend/Estac.
png(file="serie1_acf_pacf.png", bg="transparent",width = 800, height = 400)
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
png(file="serie1_lm.png", bg="transparent",width = 800, height = 400)
par(mfrow=c(1,1))
matplot(series, pch=1, type= "l")
grid(10,10,col=1)
dev.off()


#Realizamos unos test para comprobar la validez del modelo
JBtr <- jarque.bera.test(parametros$residuals)
TT <- t.test(c(parametros$residuals,TendEstimada-serie))


#Eliminamos la tendencia a partir de la regresion linea hecha.
SerSinTend<-serie-TendEstimada;



#Probamos con Filtro de medias moviles:
for (k in 3:5) {
  filtro<-rep(1/k, k); # Creamos el filtro
  # Filtramos señal
  SerFiltrada<-filter(serie,filter=filtro,sides=2,method="convolution")
  # Mostramos en la misma figura la serie y la tendencia estimada
  series<-matrix(c(t(serie), t(SerFiltrada)), ncol=2);
  matplot(series, pch=1, type= "l")
  
  cat("Calculo tendencia con filtro de orden k=", k, "\n")
  print("Pulse una tecla para continuar...")
  pause<-readline(); # para pausar la ejecución
}

SerSinTend2<-serie-SerFiltrada;
#Mostramos ambas aproximaciones diferenciadas para ver que tal se ve
series<-matrix(c(t(SerSinTend), t(SerSinTend2)), ncol=2);
matplot(series, pch=1, type= "l")
grid(50,50,col=2) #


#Como el filtro quita los valores iniciales y finales (2), quitamos los NA
aux_filter<- SerSinTend2[!is.na(SerSinTend2)];

#Vemos los resultados de ACF y PACF para cada modelo de aprox.
acf(SerSinTend)
adf.test(SerSinTend)
acf(aux_filter)
adf.test(aux_filter)
pacf(SerSinTend)
pacf(aux_filter)


#Buscamos si hay Estacionalidad.
tiempo <- 1:length(serie)
parametros <- lm (log(serie) ~ tiempo)
plot(parametros)
jarque.bera.test(parametros$residuals)


# #Eliminamos la estacionalidad y la tendencia.
# k<- ?;
# estacionalidad<-matrix(nrow=1, ncol=k);
# estacionalidad[,]<- 0
# for (i in 1:k) {
#   secuencia<-seq(i, length(SerSinTend), by=k);
#   for (j in secuencia) {
#     estacionalidad[1,i]<- estacionalidad[1,i] + SerSinTend[j];
#   }
#   
#   estacionalidad[1,i]<-estacionalidad[1,i]/length(secuencia);
# }
# 
# plot.ts(as.numeric(estacionalidad))
# 
# # Mostramos la estacionalidad, repetida por toda la serie
# #estacionalidad<-as.numeric(estacionalidad[1:43])
# aux<-rep(estacionalidad,length(SerSinTend)/length(estacionalidad));
# plot.ts(aux)
# series<-matrix(c(t(SerSinTend), t(aux)), ncol=2); 
# matplot(series, pch=1, type= "l")
# 
# #Nos quedamos con la serie sin tendencia, ni estacionalidad.
# SerSinTendEst<- SerSinTend[1:length(SerSinTend)-1]-aux;
# #Trazamos para ver como se ve la cosa
# plot.ts(SerSinTendEst)

#Se recalcula esta variables para sobreescribir los valroes.
SerSinTendEst <- SerSinTend

#Aplicamos el TEST Dickey-Fuller 
adf.test(diff(SerSinTendEst))
acf(SerSinTendEst)
pacf(SerSinTendEst)
#No obteneimos un p-value <=0.01

#Aplicamos dos diferenciaciones hasta que pase el test.
#Se aplican 2 diferenciaciones
a.diff <- diff(SerSinTendEst)
a.diff <- diff(a.diff)
adf.test(a.diff)
png(file="serie1_acf_pacf_diff.png", bg="transparent",width = 800, height = 400)
par(mfrow=c(1,2))
acf(a.diff)
pacf(a.diff)
dev.off()

#Ya podemos entrever el modelo pues el test ha bajado de 0.01


#Modelo y prediccion
fit <- auto.arima(SerSinTendEst)
plot(forecast(fit))
modArima<-auto.arima(SerSinTendEst,D=5,max.P = 5, max.Q = 5)

#Nos da una idea de como podria ser.



#Elegimos un modelo
modelo321<- arima(SerSinTendEst, order=c(3, 2, 1)); # Ajustamos modelo
modelo320<- arima(SerSinTendEst, order=c(3, 2, 0)); # Ajustamos modelo
#Este parece el mejor, aunque 222 parece ser mas prometedor.
Acf(residuals(modelo320))
modelo330<- arima(SerSinTendEst, order=c(3, 3, 0)); # Ajustamos modelo
modelo430<- arima(SerSinTendEst, order=c(4, 3, 0)); # Ajustamos modelo
modelo222<- arima(SerSinTendEst, order=c(2, 2, 2)); # Ajustamos modelo

#nos quedamos con el modelo Arima inicial propuesto.
modelo222 <- modArima

#Ajustamos los valores
valoresAjustados.H1 <- SerSinTendEst+modelo222$residuals

#Extraermos las predicciones
Predicciones.H1 <- predict(modelo222,n.ahead=3)
valoresPredichos.H1<- Predicciones.H1$pred

#Dibujamos la serie, los valores ajustados y los predichos.
plot.ts(SerSinTendEst)
lines(valoresAjustados.H1, col="blue")
lines(valoresPredichos.H1, col="red")

#Tests sobre el modelo
boxtestM1 <- Box.test(modelo222$residuals)
JB.H1 <- jarque.bera.test(modelo222$residuals)
SW.H1 <- shapiro.test(modelo222$residuals)
#JB y SW tienen p-value <0.01 , luego se acepta el modelo.

#Reconstruimos el modelo:
tiempo <- 1:length(serie)
parametros <- lm (serie ~ tiempo)
TendEstimada<-parametros$coefficients[1]+tiempo*parametros$coefficients[2] 

tiempoPredicho<- (tiempo[length(tiempo)]+1):(tiempo[length(tiempo)]+3);
TendPredicha<-parametros$coefficients[1]+tiempoPredicho*parametros$coefficients[2]

#Pintamos para ver como vamos.
plot.ts(SerSinTendEst)
lines(valoresAjustados.H1, col="blue")
lines(valoresPredichos.H1, col="red")


#valoresAjustados <- valoresAjustados.H1 + aux
valoresPredichos <- valoresPredichos.H1 + TendPredicha
valoresAjustados <- valoresAjustados.H1 + TendEstimada

valoresPredichos <- valoresPredichos
valoresAjustados <- valoresAjustados

#Mostramos los datos con todas las series, ajustada, datos y prediccion
png(file="serie1_final.png", bg="transparent",width = 800, height = 400)
plot.ts(serie)
lines(valoresAjustados,col="blue")
lines(valoresPredichos,col="red")
dev.off()


# Imprimimos por pantalla los valores solicitados de la prediccion
print ("VALORES PREDICHOS:")
print (valoresPredichos)



