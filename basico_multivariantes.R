
######################################  VAR  ##########################################

library(fpp)
library(vars)

plot(usconsumption)

# Selecciona el nº de rezagos óptimos para el modelo var
VARselect(usconsumption, lag.max=8, type="const")$selection

# Probamos los modelos con los rezagos y chequeamos con el test de potmanteau
var1 <- VAR(usconsumption, p=1, type="const")
serial.test(var1, lags.pt=10, type="PT.asymptotic") # No se cumple 0.021

acf(residuals(var1)[,1])
acf(residuals(var1)[,2])
acf(residuals(var1))


var5 <- VAR(usconsumption, p=5, type="const")
serial.test(var5, lags.pt=10, type="PT.asymptotic") # Se cumple 0.8

acf(residuals(var5)[,1])
acf(residuals(var5)[,2])
acf(residuals(var5))


var4 <- VAR(usconsumption, p=4, type="const")
serial.test(var4, lags.pt=10, type="PT.asymptotic") # Se cumple 0.57

var3 <- VAR(usconsumption, p=3, type="const")
serial.test(var3, lags.pt=10, type="PT.asymptotic") # Se cumple 0.22

var2 <- VAR(usconsumption, p=2, type="const")
serial.test(var2, lags.pt=10, type="PT.asymptotic") # No se cumple 0.025

# Predecimos con el nº de rezagos al que el test da mayor fiabilidad
fcst <- forecast(var5)
plot(fcst, xlab="Year")

# O con el que el fiable y menos complejo
fcst <- forecast(var3)
plot(fcst, xlab="Year")

######################################  VEC  ##########################################

library(foreign)
library(fUnitRoots)
library(vars)
library(MTS)

# Leemos y transformamos los datos en serie temporal y los pintamos
txhprice <- read.dta("C:/Users/Kuko/Desktop/Series temporales/Pruebas R/txhprice.dta")
attach(txhprice)

txh<-data.frame(dallas,houston)
txhs<-ts(txh,frequency = 12,start = 1990)
plot.ts(txhs)

# Vemos que la serie tiene raices unitarias, luego no son estacionarias
adfTest(dallas, type="c") 
adfTest(houston, type="c")

# Y que con una diferenciación sí lo serían
adfTest(diff(dallas), type="c") 
adfTest(diff(houston), type="c") 

# Pero se testea si las series no estacionarias están cointegradas 
# Para ello selecciona el nº de rezagos óptimos para el modelo var
VARselect(txhs, lag.max=10, type="const")$selection
VARorder(txhs,maxp=10)

# Se aplica el método de Johansen
johansen<-ca.jo(txhs, type="eigen",spec="transitory",ecdet="none",K=2)
johansen 
summary(johansen) # Se rechaza la no cointegración (r=0)

# Ahora que sí hay cointegración, estimamos los parámetros
vecm1<-cajorls(johansen,r=1)
vecm1
summary(vecm1$rlm)

# Predecimos
fcst <- forecast(vecm1)
plot(fcst, xlab="Year")


###########################################################################################
