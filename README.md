# Series Temporales

## Introducción

Una serie temporal es una colección de observaciones de una variable tomadas de forma secuencial en el tiempo (instantes
de tiempo equiespaciados). Las series pueden tener una periodicidad anual, semestral, trimestral, mensual, etc., según los periodos de tiempo en los que están recogidos los datos que la componen.

Algunos ejemplos de series temporales vienen de campos como la economía (producto interior bruto anual, tasa de inflación, tasa de desempleo, ...),  la demografía (nacimientos anuales, tasa de dependencia, ...), la meteorología (temperaturas máximas, medias o mínimas, precipitaciones diarias, ...), etc.

El objetivo de una serie temporal reside en estudiar los cambios en esa variable con respeto al tiempo (descripción), y en predecir sus valores futuros (predicción). Por lo tanto, el análisis de series temporales presenta un conjunto de técnicas estadísticas que permiten extraer las regularidades que se observan en el comportamiento pasado de la variable, para tratar de predecir el comportamiento futuro.

Una serie temporal se representa mediante un gráfico temporal, con el valor de la serie en el eje de ordenadas y los tiempos en el eje de abscisas. Esta es la forma más sencilla de comenzar el análisis de una serie temporal y permite detectar las características y componentes más importantes de una serie. 

Los componentes que forman una serie temporal son los siguientes:

- Tendencia: Se puede definir como un cambio a largo plazo que se produce en relación al nivel medio, o el cambio a largo plazo de la media. La tendencia se identifica con un movimiento suave de la serie a largo plazo.
- Estacionalidad: Se puede definir como cierta periodicidad de corto plazo, es decir, cuando se observa en la serie un patrón sistemático que se repite periódicamente (cada año, cada mes, etc., dependiendo de las unidades de tiempo en que vengan recogidos los datos). Por ejemplo, el paro laboral aumenta en general en invierno y disminuye en verano. 
- Ciclo: Similar a la estacionalidad, ya que se puede definir como una fluctuación alrededor de la tendencia, pero de una duración irregular (no estrictamente periódica).
- Irregular: Son factores que aparecen de forma aleatoria y que no responden a un comportamiento sistemático o regular y por tanto no pueden ser predecidos. No se corresponden a la tendencia ni a la estacionalidad ni a los ciclos.

Además, las series temporales se pueden dividir en:

- Estacionarias: es aquella en la que las propiedades estadísticas de la serie no varían con el tiempo, más en concreto su media y varianza se mantienen constantes a lo lardo del tiempo.
- No estacionarias: son aquellas en las que las propiedades estadísticas de la serie sí varían con el tiempo. Esta series pueden mostrar cambio de varianza, tendencia o efectos estacionales a lo largo del tiempo.

La importancia de esta división reside en que la estacionaridad es un requisito que debe cumplirse para poder aplicar modelos paramétricos de análisis y predicción de series de datos. Ya que con series estacionarias podemos obtener predicciones fácilmente, debido a que como la media es constante se puede estimar con todos los datos y utilizar este valor para predecir una nueva observación. Y también permite obtener intervalos de confianza para las predicciones.

Por otro lado, la variable que se observa en una serie temporal puede ser de tipo:

- Flujo: variable cuya cantidad es acumulada a lo largo del tiempo, por ejemplo: inversión, ahorro, etc.
- Stock: variable cuya cantidad se mide en un determinado momento del tiempo, por ejemplo: población, nº parados, etc.

________________________________________________________________________

## Análisis de series temporales

**Enfoque clásico**

El análisis más clásico de las series temporales se basa en la idea de que los valores que toma la variable de observación son la consecuencia de las componentes anteriores (tendencia, estacionalidad, ciclo y aleatoriedad), aunque no siempre aparecen todas. Luego este enfoque descriptivo consiste en encontrar componentes que correspondan a una tendencia a largo plazo, un comportamiento estacional y una parte aleatoria.

Así pues, una serie temporal se puede descomponer y denotar como:

X<sub>t</sub> = T<sub>t</sub> + E<sub>t</sub> + I<sub>t</sub>

donde T<sub>t</sub> es la tendencia, E<sub>t</sub> es la componente estacional, que constituyen la señal o parte
determinística, e I<sub>t</sub> es el ruido o parte aleatoria. 


Aditivas
Multiplicativas

Forma de medirlo

TIPOS

métodos de ajuste


Se estima Tt y Et y se obtiene It como
3
It = Xt − Tt − Et



 se pueden medir explícitamente o incluso se pueden eliminar del conjunto de los datos, desestacionalizando la serie original.

Una vez identificados los componentes anteriores y después de haberlos eliminado, persisten unos valores que son aleatorios. Se pretende estudiar qué tipo de comportamiento aleatorio presentan estos residuos, utilizando algún tipo de modelo probabilístico que los describa.

Como la finalidad no es solo describir sino predecir, hay que tener en cuanta como continua el modelado 

________________________________________________________________________

**Enfoque Box-Jenkins**

La condición de estacionaridad es un requisito que debe
cumplirse para poder aplicar modelos paramétricos de análisis y
predicción de series de datos.

¿Procesos estocásticos?

________________________________________________________________________

Series temporales con R

________________________________________________________________________

**Bibliografía**

Series temporales http://halweb.uc3m.es/esp/Personal/personas/jmmarin/esp/EDescrip/tema7.pdf
Series temporales http://humanidades.cchs.csic.es/cchs/web_UAE/tutoriales/PDF/SeriesTemporales.pdf
Introducción al análisis de series temporales http://halweb.uc3m.es/esp/Personal/personas/amalonso/esp/seriestemporales.pdf
Introducción al análisis de series temporales https://www.ucm.es/data/cont/docs/518-2013-11-11-JAM-IAST-Libro.pdf

Análisis de series temporales https://www.youtube.com/watch?v=NDOPKRAT3-E
Análisis clásico de series temporales https://www.youtube.com/watch?v=cQxFPPIj7gc
Series temporales https://www.youtube.com/watch?v=NRtgyq3MjAs
Prácticas series temporales https://www.youtube.com/watch?v=XXu2Mbg5-Lg
Predicción con series temporales https://www.youtube.com/watch?v=XXu2Mbg5-Lg
