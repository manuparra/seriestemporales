#Nombre: Manuel Parra Royón -- 50600285D
#Email: manuelparra@ugr.es
#Ejercicio Guiado. Curso 2014-2015


#Constantes
NTest=12
NPred=12

rm(list=ls()) # Eliminamos lo que haya en el espacio de trabajo

library("tseries") # para el test ADF



#Carga de los datos
serie <- scan("pasajeros_1949_1959.dat")
#Mostramos la serie para ver que forma tiene
plot.ts(serie)
# Mostramos ACF
serie.ts <- ts(serie, frequency = 12)
#Mostramos la serie descompuesta en diferentes partes:
# tendencia, etc.
plot(decompose(serie.ts))


#Convertimos la serie a logaritmica
serie.ts <- log(serie.ts)
serie.log <- log(serie)
#Volvemos a dibujarla para ver el aspecto que tiene
plot(decompose(serie.ts))


#Dividimos la serie en TEST y TRAIN
#TRAIN
serieTr <- serie.log[1:(length(serie.log)-NTest)]
tiempoTr <- 1:length(serieTr)
#TEST
serieTs <- serie.log[(length(serie.log)-NTest+1):length(serie)]
tiempoTs <- (tiempoTr[length(tiempoTr)]+1):(tiempoTr[length(tiempoTr)]+NTest)

#Visualizmos la parte de Test (se muestra la serie completa mas el anadido)
plot.ts(serieTr, xlim=c(1,tiempoTs[length(tiempoTs)]))
lines(tiempoTs,serieTs,col="red")


#Aplicamos regresion lineal
parametros.H1 <- lm (serieTr ~ tiempoTr )
#Calculamos la estimacion de la tendecia


#Calculamos la tendencia estimada para TEST y TRAIN
#Calculamos la tendencia estimada en el TRAIN
TendEstimadaTrH1 <- parametros.H1$coefficients[1]+tiempoTr*parametros.H1$coefficients[2]
#Calculamos la tendencia estimada en el Test
TendEstimadaTsH1 <- parametros.H1$coefficients[1]+tiempoTs*parametros.H1$coefficients[2]


#Mostramos las graficas de la serie de Entrenamiento
plot.ts(serieTr,xlim=c(1,tiempoTs[length(tiempoTs)]))
#Dibujamos la Tendencia Estimada de Train en Azul
lines(tiempoTr,TendEstimadaTrH1,col="blue")
lines(tiempoTs,serieTs,col="red")
#Dibujamos la Tendencia Estimada de Test en Green
lines(tiempoTs,TendEstimadaTsH1,col="green")



#Validacion del modelo. Comprobamos que los errores a lo largo de la serie
#son errores se distribuyen uniformemente (NORMAL) a lo largo del tiempo
#Test de JarqueBera para Train
JBtr <- jarque.bera.test(parametros.H1$residuals)
#Obtenemos 0.41 , luego podemos decir que los datos siguen una 
#Distribucion normal.

#Test de JarqueBera para Test
JBts <- jarque.bera.test((TendEstimadaTsH1-serieTs))
#Obtenemos > 0.05 , luego podemos decir que los datos siguen una 
#Distribucion normal.

#Comparamos la media del error para Test y Train
#Aplicamos la T-student
TT <- t.test(c(parametros.H1$residuals,TendEstimadaTsH1-serieTs))
#El resultado es de media 0, y por tanto el modelo lineal es posible




#Eliminamos la tendencia tanto en Train como en Test
serieTr.SinTend.H1 <- serieTr-TendEstimadaTrH1
serieTs.SinTend.H1 <- serieTs-TendEstimadaTsH1
#Mostramos la serie sin tendencia
plot.ts(serieTr.SinTend.H1,xlim=c(1,tiempoTs[length(tiempoTs)]))
lines(tiempoTs,serieTs.SinTend.H1,col="red")

#Ahora le quitamos la estacionalidad

#Como vimos cada doce valores tenemos una estacionalidad
k <- 12
#Extraemos la estacionalidad
estacionalidad.H1 <- decompose(serie.ts)$seasonal[1:k]
#Tenemos 12 valores de estacionalidad



#Calculamos la serie sin la tendencia ni la estacionalidad.
aux <- rep (estacionalidad.H1, length(serieTr)/length(estacionalidad.H1))
serieTr.SinTendEst.H1 <- serieTr.SinTend.H1-aux
serieTs.SinTendEst.H1 <- serieTs.SinTend.H1-estacionalidad.H1
#Representamos el resultado.
plot.ts(serieTr.SinTendEst.H1, xlim=c(1,tiempoTs[length(tiempoTs)]))
lines(tiempoTs,serieTs.SinTendEst.H1,col="red")



#Test de ADF de la serie de Entrenamiento
adftest.H1 <- adf.test(serieTr.SinTendEst.H1)
#Comprueba la no estacionalidad, luego si es valor >0.05, 
# luego no es estacionaria
serieTr.SinTendEstDiff.H1 <- diff(serieTr.SinTendEst.H1)
serieTs.SinTendEstDiff.H1 <- diff(serieTs.SinTendEst.H1)

#Probamos de nuevo con los datos y comprobamos que es estacionaria
adftest.H1 <- adf.test(serieTr.SinTendEstDiff.H1)
#Obtenemos un p-value < 0.05

#Compromamos PACF y ACF graficamente
acf(serieTr.SinTendEstDiff.H1)
pacf(serieTr.SinTendEstDiff.H1)
#Luego son graficas tipicas de modelos autoregresivos
#Si contamos las lineas, podemos extraer que se trata
#de un modelo ARIMA de orden 4.



#Arima: 4,  Modelo de diferenciacion=1, medias moviles =0
modelo.H1 <- arima(serieTr.SinTendEst.H1,order=c(4,1,0))
#Valores ajustados del modelo como residuos + la serie sin tendencia
valoresAjustados.H1 <- serieTr.SinTendEst.H1+modelo.H1$residuals

#Llamamos a la funcion predict para tener los valores de 12 elementos
Predicciones.H1 <- predict(modelo.H1,n.ahead=NPred)
valoresPredichos.H1<- Predicciones.H1$pred
#Valores predichos en una lista (12 valores)


#Calculamos el error del ajuste, para ver como de buena es 
# nuestra prediccion (error cuadratico)
errorTr.H1 <- sum((modelo.H1$residuals)^2)
errorTs.H1 <- sum((valoresPredichos.H1-serieTs.SinTendEst.H1)^2)




#Mas resultados
#Vamos dibujar la serie de Entrenamiendo son la Estacionalidad ni la tendencia
plot.ts(serieTr.SinTendEst.H1,xlim=c(1,tiempoTs[length(tiempoTs)]))
lines(valoresAjustados.H1, col="blue")
#Dibujamos la recosntruccion de la serie, parece bastante precisa.
#Para la predicción el ajuste no es muy bueno
lines(tiempoTs,serieTs.SinTendEst.H1, col="red")
lines(tiempoTs,valoresPredichos.H1, col="blue")


#Validacion con test estadisticos
#Box Test,para comprobar que los residuos son aleatorios.
boxtestM1 <- Box.test(modelo.H1$residuals)
#Luego obtenemos que son residous son aleaotrios
#Si esto es así los errores son aleaotrios, el modelo es valido con
#respecto a los residuos

#Aplicamos los test siguientes:
JB.H1 <- jarque.bera.test(modelo.H1$residuals)
SW.H1 <- shapiro.test(modelo.H1$residuals)
#Verificamos los p-values:
#Todos son > 0.05, luego correctas las hipotesis.
# jarque.bera =>Normalidad de residuos

#Vemos el histograma de los residuos (y densidad)
hist(modelo.H1$residuals,col="blue",prob=T, ylim=c(0,20),xlim=c(-0.2,0.2))
lines(density(modelo.H1$residuals))
#Con esto anterior hemos validado el modelo
#de prediccion ARIMA(4,1) y el modelo es valido.



#Ya se ha validado el modelo, luego ahora
#Seguimos los pasos iniciales sin realizar la division de la serie en ajuste y test.
serieEntera <- serie.log
tiempo <- 1:length(serieEntera)
parametros <- lm(serieEntera~tiempo)
TendEstimada <- parametros$coefficients[1]+tiempo*parametros$coefficients[2]
serieSinTend <- serieEntera-TendEstimada

aux <- ts(serieEntera,frequency=12)
aux <- decompose(aux)$seasonal
estacionalidad<-as.numeric(aux[1:12])
aux <- rep(estacionalidad,length(serieSinTend)/length(estacionalidad))

serieSinTendEst <- serieSinTend - aux
modelo <- arima (serieSinTendEst, order=c(4,1,0))
valoresAjustados <- serieSinTendEst + modelo$residuals
#Realizmos la prediccion de los valores para NPred valores
#con la funcion predict
Predicciones <- predict (modelo,n.ahead=NPred)
#Almacenamos en valoresPredichos el valor
valoresPredichos <- Predicciones$pred


#Ahora deshacemos los cambios para tener las predicciones reales.
valoresAjustados <- valoresAjustados + aux
valoresPredichos <- valoresPredichos + estacionalidad

valoresAjustados <- valoresAjustados + TendEstimada
tiempoPred <- (tiempo[length(tiempo)]+(1:NPred))
TendEstimadaPred <- parametros$coefficients[1]+tiempoPred*parametros$coefficients[2]
valoresPredichos <- valoresPredichos+TendEstimadaPred

#Le damos la vuelta (antes hemos usado log)
valoresAjustados<-exp(valoresAjustados)
valoresPredichos<-exp(valoresPredichos)

#Pintamos la serie
plot.ts(serie,xlim=c(1,max(tiempoPred)),ylim=c(100,650))
lines(valoresAjustados, col="blue")
lines(valoresPredichos, col="red")

write.csv(valoresPredichos,file = "valores_predichos.csv")



