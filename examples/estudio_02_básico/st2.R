library("tseries") 


rm(list=ls()) # Eliminamos lo que haya en el espacio de trabajo


#Leemos la serie temporal
serie2 <- scan("serie2.dat")

#Mostramos la serie para ver que forma tiene
plot.ts(serie2)

#Dividida en 87 valores, que son 3 Trimestres de 1971, mas 84 Trimestres mas hasta 1992.

#Usamos como frecuencia 4, ya que los datos estan procesados en Trimestres
#Y ademas, como es el segundo Trimestre, indicamos que la serie empieza en 2 trimestre
serie2.ts <- ts(serie2, frequency = 1,start=c(1875,1))
print(serie2.ts)

plot.ts(serie2.ts)

#The estimated values of the seasonal, trend and irregular components are now stored here
decompose.serie2.ts <- decompose(serie2.ts)
#Print out the estimated values od seasonal component
decompose.serie2.ts$seasonal 
#Plot all components, seasonal, trend and irregular
plot(decompose.serie2.ts)

#Try STL
serie1.stl <- stl(serie1.ts,"per")
plot(serie1.stl)

serie1.log.ts <- log(serie1.ts)
serie1.log <- log(serie1)

#Datos de TRAIN
serie1.TR <- serie1.log[1:(length(serie1.log)-4)]
tiempo.serie1.TR <- 1:length(serie1.TR)
#Datos de TEST
serie1.TS <- serie1.log[(length(serie1.log)-4+1):length(serie1)]
tiempo.serie1.TS <- (tiempo.serie1.TR[length(tiempo.serie1.TR)]+1):(tiempo.serie1.TR[length(tiempo.serie1.TR)]+4)

plot.ts(tiempo.serie1.TR, xlim=c(1,tiempo.serie1.TS[length(tiempo.serie1.TS)]))
lines(tiempo.serie1.TS,serie1.TS,col="red")


#Hacemos regresion Linea
parametros.H1 <- lm (serie1.TR ~ tiempo.serie1.TR )

#tendencia
TendEstimadaTR.H1 <- parametros.H1$coefficients[1]+tiempo.serie1.TR*parametros.H1$coefficients[2]
TendEstimadaTS.H1 <- parametros.H1$coefficients[1]+tiempo.serie1.TS*parametros.H1$coefficients[2]

plot.ts(serie1.TR,xlim=c(1,tiempo.serie1.TS[length(tiempo.serie1.TS)]))
lines(tiempo.serie1.TR,TendEstimadaTR.H1,col="blue")
lines(tiempo.serie1.TS,serie1.TS,col="red")
plot(log(jj), type="o") 
#Dibujamos la Tendencia Estimada de Test en Green
lines(tiempo.serie1.TS,TendEstimadaTS.H1,col="green")



