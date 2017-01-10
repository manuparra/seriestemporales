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

_¿PROCESOS ESTOCÁSTICOS?_
________________________________________________________________________

## Análisis de series temporales

**Enfoque clásico**

El análisis más clásico de las series temporales se basa en la idea de que los valores que toma la variable de observación son la consecuencia de las componentes anteriores (tendencia, estacionalidad, ciclo y aleatoriedad), aunque no siempre aparecen todas. Luego este enfoque descriptivo consiste en encontrar componentes que se correspondan a una tendencia a largo plazo, un comportamiento estacional y una parte aleatoria. 

El primer paso a seguir a la hora de realizar un análisis es determinar cómo se combinan los componentes de la serie. Para ello se consideran dos modelos habituales para relacionar los valores de la serie con los componentes anteriores:

- Modelo aditivo: donde cada componente contribuye al comportamiento de la variable de interés en forma aditiva (unidades).
- Modelo multiplicativo: donde cada componente contribuye al comportamiento de la variable de interés en forma multiplicativa (porcentaje).

Así pues, una serie temporal se puede descomponer y denotar en su manera aditiva como:

X<sub>t</sub> = T<sub>t</sub> + E<sub>t</sub> + I<sub>t</sub>

ó en su forma multiplicativa como:

X<sub>t</sub> = T<sub>t</sub> x E<sub>t</sub> x I<sub>t</sub>

donde T<sub>t</sub> es la tendencia, E<sub>t</sub> es la componente estacional, que constituyen la señal o parte
determinística, e I<sub>t</sub> es el ruido o parte aleatoria. 

Para conocer qué tipo se adapta mejor a la serie, se pueden seguir los siguientes procedimientos:

- De manera visual:
   - La tendencia y la estacionalidad se mantienen relativamente constantes -> modelo aditivo
   - La tendencia y la estacionalidad varian creciendo o decreciento -> modelo multiplicativo
- De forma matemática:
   - Calcular las series diferencia y cociente, D y C.
   - Calcular el coeficiente de variación para cada serie, CVD y CVC.
   - Comparar sendos coeficientes.
      - Si CVC < CVD -> modelo multiplicativo
      - Si CVC > CVD -> modelo aditivo

Una vez que se conoce la forma en que se relacionan los componentes, se descompone la serie estimando los componentes de tendencia y estacionalidad:

- Componente de tendencia: la forma de la tendencia se puede modelar mediante los siguientes métodos (es importante reseñar que como la finalidad del análisis no es solo describir la serie sino predecir, hay que tener en cuenta cómo continúa la tendencia estimada para valores futuros):
   - Modelos lineales
   - Modelos polinómicos
   - Filtrado (Médias móviles)(no se recomienda ya que no predice, solo describe)
   - Diferenciación
- Componente de estacionalidad: se pueden obtener los índices o coeficientes de estacionalidad que representan el valor promedio para cada elemento de la estación (si es anual para cada mes, si es trimestral cada trimestre, etc.). Además, también la componente estacional se puede eliminar directamente de la serie, desestacionalizando así la serie original.
   - Médias móviles centradas
   - Diferenciación

Y se eliminan para poder obtener la componente aleatoria:

I<sub>t</sub> = X<sub>t</sub> − T<sub>t</sub> − E<sub>t</sub>

ó

I<sub>t</sub> = X<sub>t</sub> / (T<sub>t</sub> * E<sub>t</sub>)

En este punto se tiene una descomposición de la serie en componentes que separan tendencia, estacionalidad y ruido, pero no predicciones. Para predecir se realiza un pronóstico futuro de la tendencia, y se le añade la predicción de la estacionalidad (índice de estacionalidad) correspondiente.

Los métodos clásicos de análisis de series temporales tienen la ventaja de no ser excesivamente complejos, aunque como contrapartida responden a preguntas menos ambiciosas. Se pueden emplear para realizar predicciones a corto plazo, pero no a medio o largo plazo.

_TIPOS_

**Enfoque Box-Jenkins**

La condición de estacionaridad es un requisito que debe
cumplirse para poder aplicar modelos paramétricos de análisis y
predicción de series de datos.

________________________________________________________________________

**Series temporales con R**

________________________________________________________________________

**Bibliografía**

Series temporales http://halweb.uc3m.es/esp/Personal/personas/jmmarin/esp/EDescrip/tema7.pdf <br>
Series temporales http://humanidades.cchs.csic.es/cchs/web_UAE/tutoriales/PDF/SeriesTemporales.pdf <br>
Introducción al análisis de series temporales http://halweb.uc3m.es/esp/Personal/personas/amalonso/esp/seriestemporales.pdf <br>
Introducción al análisis de series temporales https://www.ucm.es/data/cont/docs/518-2013-11-11-JAM-IAST-Libro.pdf <br>

Análisis de series temporales https://www.youtube.com/watch?v=NDOPKRAT3-E <br>
Análisis clásico de series temporales https://www.youtube.com/watch?v=cQxFPPIj7gc <br>
Series temporales https://www.youtube.com/watch?v=NRtgyq3MjAs <br>
Prácticas series temporales https://www.youtube.com/watch?v=XXu2Mbg5-Lg <br>
Predicción con series temporales https://www.youtube.com/watch?v=XXu2Mbg5-Lg <br>
