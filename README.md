# Series Temporales

## Introducción

Una serie temporal es una colección de observaciones de una variable tomadas de forma secuencial y ordenada en el tiempo (instantes de tiempo equiespaciados). Las series pueden tener una periodicidad anual, semestral, trimestral, mensual, etc., según los periodos de tiempo en los que están recogidos los datos que la componen. Las series temporales se pueden definir como un caso particular de los procesos estocásticos, ya que un proceso estocástico es una secuencia de variables aleatorias, ordenadas y equidistantes cronológicamente referidas a una característica observable en diferentes momentos.

Algunos ejemplos de series temporales vienen de campos como la economía (producto interior bruto anual, tasa de inflación, tasa de desempleo, ...),  la demografía (nacimientos anuales, tasa de dependencia, ...), la meteorología (temperaturas máximas, medias o mínimas, precipitaciones diarias, ...), etc.

El objetivo de una serie temporal reside en estudiar los cambios en esa variable con respeto al tiempo (descripción), y en predecir sus valores futuros (predicción). Por lo tanto, el análisis de series temporales presenta un conjunto de técnicas estadísticas que permiten extraer las regularidades que se observan en el comportamiento pasado de la variable, para tratar de predecir el comportamiento futuro.

Una serie temporal se representa mediante un gráfico temporal, con el valor de la serie en el eje de ordenadas y los tiempos en el eje de abscisas. Esta es la forma más sencilla de comenzar el análisis de una serie temporal y permite detectar las características y componentes más importantes de una serie. 

Los componentes que forman una serie temporal son los siguientes:

- Tendencia: Se puede definir como un cambio a largo plazo que se produce en relación al nivel medio, o el cambio a largo plazo de la media. La tendencia se identifica con un movimiento suave de la serie a largo plazo.
- Estacionalidad: Se puede definir como cierta periodicidad de corto plazo, es decir, cuando se observa en la serie un patrón sistemático que se repite periódicamente (cada año, cada mes, etc., dependiendo de las unidades de tiempo en que vengan recogidos los datos). Por ejemplo, el paro laboral aumenta en general en invierno y disminuye en verano. 
- Ciclo: Similar a la estacionalidad, ya que se puede definir como una fluctuación alrededor de la tendencia, pero de una duración irregular (no estrictamente periódica).
- Irregular: Son factores que aparecen de forma aleatoria y que no responden a un comportamiento sistemático o regular y por tanto no pueden ser predecidos. No se corresponden a la tendencia ni a la estacionalidad ni a los ciclos.

Además, las series temporales se pueden dividir en:

- Estacionarias: es aquella en la que las propiedades estadísticas de la serie son estables, no varían con el tiempo, más en concreto su media y varianza se mantienen constantes a lo lardo del tiempo.
- No estacionarias: son aquellas en las que las propiedades estadísticas de la serie sí varían con el tiempo. Esta series pueden mostrar cambio de varianza, tendencia o efectos estacionales a lo largo del tiempo.

La importancia de esta división reside en que la estacionaridad es un requisito que debe cumplirse para poder aplicar modelos paramétricos de análisis y predicción de series de datos. Ya que con series estacionarias podemos obtener predicciones fácilmente, debido a que como la media es constante se puede estimar con todos los datos y utilizar este valor para predecir una nueva observación. Y también permite obtener intervalos de confianza para las predicciones. Un tipo especial de serie estacionaria es la serie denominada ruido blanco. Un ruido blanco es una serie estacionaria tal que ninguna observación influye sobre las siguientes, es decir, donde los valores son independientes e idénticamente distribuidos a lo largo del tiempo con media y covarianza cero e igual varianza.

Las series temporales también se pueden dividir según cuántas variables se observan o según su variabilidad:

- Univariante: la serie temporal es un conjunto de observaciones sobre una única caracteristica o variable.
- Multivariante: (o vectorial): la serie temporal es un conjunto de observaciones de varias variables. <br>
<br>
- Homocedástica: una serie es homocedástica si su variabilidad se mantiene constante a lo largo de la serie.
- Heterocedástica: una serie es heterocedástica cuando la variabilidad de la serie aumenta o disminuye a lo largo del tiempo.

Por otro lado, la variable que se observa en una serie temporal puede ser de tipo:

- Flujo: variable cuya cantidad es acumulada a lo largo del tiempo, por ejemplo: inversión, ahorro, etc.
- Stock: variable cuya cantidad se mide en un determinado momento del tiempo, por ejemplo: población, nº parados, etc.

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
- Componente de estacionalidad: para estimar el efecto estacional se pueden obtener los índices o coeficientes de estacionalidad que representan el valor promedio para cada elemento de la estación (si es anual para cada mes, si es trimestral cada trimestre, esto es, el periodo de la serie)(la suma de los índices estacionales debe de ser igual al número de periodos). Además, la serie original se puede desestacionalizar también mediante una diferenciación estacional de la serie.
   - Médias móviles centradas
   - Diferenciación

Y estos se pueden eliminar para obtener la componente aleatoria:

I<sub>t</sub> = X<sub>t</sub> − T<sub>t</sub> − E<sub>t</sub>

ó

I<sub>t</sub> = X<sub>t</sub> / (T<sub>t</sub> * E<sub>t</sub>)

En este punto se tiene una descomposición de la serie en componentes que separan tendencia, estacionalidad y ruido. Estos componentes obtenidos de la serie la describen, pero no la predicen. Las predicciones de valores futuros se consiguen usando las componentes T<sub>t</sub> y E<sub>t</sub> con valores de tiempo t+1, t+2, etc. Para ello se realiza un pronóstico futuro de la tendencia, y se le añade la predicción de la estacionalidad (índice de estacionalidad) correspondiente a cada periodo (la componente irregular o aleatorio no es predecible y por lo tanto no se considera).

Los métodos clásicos de análisis de series temporales tienen la ventaja de no ser excesivamente complejos, aunque como contrapartida responden a preguntas menos ambiciosas. Se pueden emplear para realizar predicciones a corto plazo, pero no a medio o largo plazo.

_METODOS DE SUAVIZADO?_
_SERIES SIN TENDENCIA NI ESTACIONALIDAD?_ _naibe?_
_SERIES CON TENDENCIA SIN ESTACIONALIDAD?_ _holt?_
_SERIES SIN TENDENCIA CON ESTACIONALIDAD?_ _holtwinters?_

**Enfoque Box-Jenkins**

Hasta ahora se han analizado las series temporales desde un punto de vista determinista o clásico, sin tener en cuenta cuál es el mecanismo que genera la serie. Pero ahora con este nuevo enfoque se analizan desde un punto de vista estocástico, por lo que el punto de partida para elaborar un modelo a partir de una serie temporal consiste en considerar que dicha serie está generada y es una realización particular de un proceso estocástico.

Pero para poder efectuar inferencias sobre los parámetros de un proceso estocástico, es preciso imponer restricciones a este último. Las restricciones que se imponen habitualmente son que sea estacionario y ergódico. Ya se ha visto cuándo un proceso es estacionario, pero ¿cúando es ergódico?. Antes de explicar un proceso ergódico necesitamos definir la autocorrelación. Se denomina autocorrelación de orden k, a la correlación (dependencia) de cualesquiera dos variables aleatorias del proceso estocástico (serie temporal), distanciadas k instantes de tiempo. La autocorrelación se puede medir mediante:

- Función de autocorrelación (ACF): esta función mide la correlación entre dos variables separadas por k periodos.
- Función de autocorrelación parcial (PACF): esta función mide la correlación entre dos variables separadas por k periodos cuando no se considera la dependencia creada por los retardos intermedios existentes entre ambas.

Las funciones de autocorrelación simple y parcial constituyen uno de los instrumentos clave para ajustar el modelo que genera una serie temporal. Así pues, un proceso es ergódico cuando conforme k se hace más grande, a autocorrelación se hace más pequeña. Es decir, que la dependencia entre variables tiene menos importancia pasado más tiempo.

Box y Jenkins desarrollaron modelos estadísticos para series temporales que tienen en cuenta la dependencia existente entre los datos, esto es, cada observación en un momento dado es modelada en función de los valores anteriores. Los modelos se conocen con el nombre genérico de ARIMA (AutoRegresive Integrated Moving Average)(ARIMA para procesos estocásticos no estacionarios y ARMA para procesos estocásticos estacionarios), que deriva de sus tres componentes Autoregresivo, Integrado y Medias Móviles:

- _Procesos Autoregresivos AR(p)_<br> Los modelos autoregresivos se basan en la idea de que el valor actual de la serie, X<sub>t</sub>, puede explicarse o predecirse en función de _p_ valores pasados X<sub>t-1</sub>, ... X<sub>t-p</sub> más un término de error, donde _p_ determina el número de valores pasados necesarios para pronosticar un valor actual. El orden del modelo expresa el número de observaciones retrasadas de la serie temporal que intervienen en la ecuación, así pues, un modelo autoregresivo de orden 1 AR(1), la variable X<sub>t</sub> está determinada únicamente por un valor pasado, esto es X<sub>t-1</sub> y así sucesivamente. Todos los procesos autorregresivos son procesos invertibles. 

- _Procesos de Medias Móviles MA(q)_<br> Un modelo de medias móviles es aquel que explica el valor de una determinada variable en un período _t_ en función de un término independiente y una sucesión de errores correspondientes a períodos precedentes, ponderados convenientemente. Estos modelos se denotan normalmente con las siglas MA, seguidos del orden entre paréntesis. Todos los procesos de medias móviles son procesos estacionarios. No todos los procesos de medias móviles son invertibles.

- _Proceso Autoregresivo de Medias Móviles ARMA(p,q)_ <br> Una extensión natural de los modelos AR(p) y MA(q) es un tipo de modelos que incluyen tanto términos autorregresivos como de medias móviles. Los modelos autorregresivos de medias móviles, ARMA(p,q), son la suma de un proceso autorregresivo de orden _p_ y uno de medias móviles de orden _q_. Es muy probable que una serie de tiempo tenga características de AR y de MA a la vez y, por consiguiente, sea ARMA. Un proceso ARMA(p, q) es estacionario si lo es su componente autorregresiva, y es invertible si lo es su componente de medias móviles.

- _Proceso Integrado I(d)_ <br> No todas las series temporales son estacionarias, algunas presentan cambios de nivel en el tiempo o la varianza no es constante, por lo que la serie se diferencia _d_ veces para hacerla estacionaria. A este tipo de procesos se les considera procesos integrados, y se puede aplicar a esta serie diferenciada un modelo ARMA(p,q) para dar lugar a un modelo ARIMA(p,d,q).

Luego un Proceso Autoregresivo Integrado y de Media Móvil, ARIMA (p,d,q), es una serie de tiempo autoregresiva integrada de media móvil. Donde denota _p_ el número de términos autoregresivos, _d_ el número de veces que la serie debe ser diferenciada para hacerla estacionaria y _q_ el número de términos de la media móvil invertible. La metodología Box-Jenkins para la construcción de los modelos ARIMA(p,d,q) se realiza de manera iterativa mediante un proceso en el que se puede distinguir cuatro etapas:

- Identificación: esta primera fase consiste en identificar el posible modelo ARIMA(p,d,q) que sigue la serie (es posible identificar más de un modelo candidato que pueda describir la serie), lo que requiere:

      - Decidir qué transformaciones aplicar para convertir la serie observada en una serie estacionaria.
      - Determinar un modelo ARMA para la serie estacionaria, es decir, los órdenes p y q de su estructura autorregresiva y de media móvil.





xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx


Representar gráficamente la serie, además de su función de autocorrelación simple (ACF) y función de autocorrelación parcial (PACF). La gráfica de la serie nos indica si la serie es estacionaria o no. Según los motivos por los que la serie no es estacionaria, tendremos que aplicar los siguientes procedimientos hasta hacerla estacionaria.
- Si tiene tendencia: Tomaremos diferencias regulares hasta que desaparezca. Normalmente el orden de la diferencia es 1, y raramente será mayor a 3.
- Si la serie tiene estacionalidad: Tomaremos diferencias estacionales hasta que desaparezca el patrón estacional. En la práctica es muy raro tener que aplicar más de una diferencia estacional.
- Si es heterocedástica, es decir, no tiene varianza constante, habrá que transformar la serie. Con tomar el logaritmo en muchos casos es suficiente, aunque existen algunas transformaciones más sofisticadas, como las de Box-Cox.
Una vez que el gráfico de la nueva serie (transformación de la original) indica que es estacionaria, podemos intentar deducir la estructura de la serie (¡no la de la serie original!) observando su ACF y PACF.



Identificar un modelo significa utilizar los datos recogidos, así como cualquier información de cómo se
general la serie temporal objeto de estudio, para sugerir un conjunto reducido de posibles modelos, que
tengan muchas posibilidades de ajustarse a los datos. Ante una serie temporal empírica, se deben
encontrar los valores (p, d, q) más apropiados.
􀂃 Si la serie temporal presenta una tendencia, lo primero que debe de hacerse es convertirla en
estacionaria mediante una diferenciación de orden d. Una vez diferenciada la serie, una buena
estrategia consiste en comparar los correlogramas de la función de autocorrelación (ACF) y la función
de autocorrelación parcial (ACFP), proceso que suele ofrecer una orientación para la formulación del
modelo orientativo.
♣ Los procesos autorregresivos presentan función de autocorrelación parcial (ACFP) con un número
finito de valores distinto de cero. Un proceso AR(p) tiene los primeros p términos de la función de
autocorrelación parcial distintos de cero y los demás son nulos.
Esta afirmación es muy fuerte, y en la práctica se considera que una muestra dada proviene de un
proceso autorregresivo de orden p si los términos de la función de autocorrelación parcial son casi
cero a partir del que ocupa el lugar p.
Un valor se considera casi cero cuando su módulo es inferior a 2/ T . Los programas de ordenador
constituyen la franja (−2/ T , 2/ T ) y detectan los valores de la ACFP que caen fuera de ella.




La metodología Box-Jenkins para series temporales consiste en estimar los componentes de tendencia y estacionalidad de la serie y eliminarlos de la misma, X'<sub>t</sub> = X<sub>t</sub>-T<sub>t</sub>-E<sub>t</sub> (ya se ha explicado anteriormente cómo se estiman y modelan ambas). Una vez esto hecho se comprueba la estacionariedad, si aún no lo es se diferencia hasta que lo sea, para posteriormente aplicar los métodos paramétricos. La condición de estacionaridad es un requisito que debe cumplirse para poder aplicar modelos paramétricos de análisis y predicción de series de datos. 

Pero ¿cómo saber si una serie es estacionaria?

- Gráficamente: Observando las gráficas de autocorrelación (ACF) y autocorrelación parcial (PACF). Si el ACF tiende “rápidamente” a 0 entonces es estacionaria, en caso contrario, no es esatacionaria
- Test estadísticos: Dickey-Fuller Ampliado (Test ADF). Si el valor resultante, pvalue, es menor de 0.05 indica que la serie es estacionaria con un nivel de confianza del 95%

Una vez que tenemos que la serie es estacionaria, ¿cómo saber si el modelo que tenemos que elegir? ¿AR o MA? ¿ARMA? ¿ARIMA? ¿Y el orden?


Como norma general:

- Los modelos AR tienen un ACF que decrece a 0 (con diferentes posibles formas: regulares, sinusoidales, anternando +/-). El número del orden “p” (AR(p)) es tantos valores “distintos de 0 como haya en el PACF”.

- Los modelos MA tiene un PACF que decrece a 0 (con diferentes posibles formas: regulares, sinusoidales, anternando +/-). El número del orden “q” (MA(q)) es tantos “valores distintos de 0” como haya en el ACF.

Un valor se considera “distinto de cero” si no está en el rango (-2/sqrt(N), 2/sqrt(N)), con N=longitud de la serie.

Como norma general:

Cuando la serie no es estacionaria, el ACF decrece lentamente a 0.

La parte integrada es necesaria normalmente para corregir la estacionaridad en la varianza.

Si la serie presenta tendencia lineal, normalmente con d=1 es suficiente. Si la tendencia es no lineal, puede ser necesario usar
d>1. 
Si la serie presenta estacionalidad, puede ser necesario un d=periodo de estacionalidad.





Modelo arima y manual


- Estimación. Considerando el modelo apropiado para la serie de tiempo se realiza inferencia sobre los parámetros.
- Validación. Se realizan contraste de diagnostico para validar si el modelo seleccionado se ajusta a los datos, so no es así, escoger el próximo modelo candidato y repetir los pasos anteriores.
- Predicción. Una vez seleccionado el mejor modelo candidato ARIMA(p,d,q) se pueden hacer pronósticos en términos probabilísticos de los valores futuros.





¿QUÉ QUEDA?




   LECTURA CORRELOGRAMAS

   DEMOSTRAR ESTACIONARIEDAD

¿estacionaria en varianze, media...?




El doble -> de manual



¿no es estacionaria en varianza -> transformación logaritmica?

¿transformación logaritmica?

________________________________________________________________________

**Series temporales con R**

Para que R trate a un conjunto de datos como serie temporal:

	ts(data, start, end, frequency)

		- data: vector o matrix con las observaciones
		- start: tiempo de la primera observación
		- end: tiempo de la última observación
		- frequency: número de observaciones por unidad de tiempo

Representación gráfica de la serie:

	plot(serie temporal)

Representación numérica de la serie:

	print(serie temporal)
   
Unidad de tiempo a la que pertenece cada observación de la serie:

	cycle(serie temporal)
   
Descomposición de una serie temporal en Tendencia + Efecto estacional + Residuos:

	decompose(serie temporal, type)

		- type: tipo de serie, aditiva o multiplicativa
		
	stl(serie temporal)
		
Cómputo de las estimaciones de las funciones de autocorrelación y autocorrelación parcial:

	acf(serie temporal)

	pacf(serie temporal)

Test de Dickey-Fuller Ampliado (Test ADF):

adf.test(serie temporal)

________________________________________________________________________

**Bibliografía**

Series temporales http://halweb.uc3m.es/esp/Personal/personas/jmmarin/esp/EDescrip/tema7.pdf <br>
Series temporales http://humanidades.cchs.csic.es/cchs/web_UAE/tutoriales/PDF/SeriesTemporales.pdf <br>
Introducción al análisis de series temporales http://halweb.uc3m.es/esp/Personal/personas/amalonso/esp/seriestemporales.pdf <br>
Introducción al análisis de series temporales https://www.ucm.es/data/cont/docs/518-2013-11-11-JAM-IAST-Libro.pdf <br>
Introducción a series de tiempo http://www.estadisticas.gobierno.pr/iepr/LinkClick.aspx?fileticket=4_BxecUaZmg%3D <br>
Series temporales: Modelo ARIMA http://www.estadistica.net/ECONOMETRIA/SERIES-TEMPORALES/modelo-arima.pdf <br>
Modelo ARIMA https://www.uam.es/personal_pdi/economicas/anadelsur/pdf/Box-Jenkins.PDF <br>

Análisis descriptivo de series temporales con R https://www.uam.es/personal_pdi/ciencias/acuevas/docencia/doct/Series-temporales-con-R.pdf
Análisis básico de series temporales con R https://rpubs.com/joser/SeriesTemporalesBasicas

Análisis de series temporales https://www.youtube.com/watch?v=NDOPKRAT3-E <br>
Análisis clásico de series temporales https://www.youtube.com/watch?v=cQxFPPIj7gc <br>
Series temporales https://www.youtube.com/watch?v=NRtgyq3MjAs <br>
Prácticas series temporales https://www.youtube.com/watch?v=XXu2Mbg5-Lg <br>
Predicción con series temporales https://www.youtube.com/watch?v=XXu2Mbg5-Lg <br>
