# Análisis gráfico de series

```
library(lessR) 
theme(colors="gray")
library(tidyverse)
```

# Plot Time Series


# Single Time Series

Plot a time series of values over a range of dates.

ggplot wants the date to be its own variable in the data table, so the data table contains a column of dates and at least one column of values that are to be plotted against the dates, one value for each date. date fields in the data file with values such as 2016-05-02 are initially read as a character strings, so need to interpret them as a date class, instead of character strings, integers, etc.

Data file for this example, ```PPStech.csv```, contains a date column and corresponding stock prices for Apple, IBM, Intel in this example, the name of the variable that contains the dates is date.

*Option 1*: read the dates in the data file as character strings, then convert

```
mydata <- Read("./PPStech.csv")
```

#' the R as.Date function converts from class character to class date
#' then save the result into the data table with lessR Transform function
#'   or base R transform function
#' As always, lessR functions default to data=mydata. To illustrate, the following leads to the same result as the above.

```
mydata <- Transform(date=as.Date(date), quiet=TRUE)
```
or

*Option 2*: use the R colClasses option to instruct R how to read the data values under the Date column directly as dates.

For large data sets, the use of the colClasses option can drastically speed up reading a data table because R does not have to do the work of examining all the data values to infer the corresponding class of each variable. Instead you inform R as how to read the data values for specified columns, as integer, numeric, factor, date, etc.

```
mydata <- Read("./PPStech.csv",
  colClasses=list(date="Date"))
```

After reading the data into the R data table mydata, the data table begins with the following.
head(mydata, n=3)
 
This data table is in what is called the *wide format*, as it has multiple (three) measurements per row. However, the data is *not* tidy data because the each of the three measurements represents a *different* observation.



## lessR

Standard time series plot with dates on the x-axis.

´´´
Plot(date, Apple)
´´´

lessR also accepts input as an R times series. First sort the data so as to have the data begin with the most distant date and end with the most recent date.

´´´
mydata <- Sort(date, quiet=TRUE)
Apple.ts <- ts(mydata$Apple, frequency=12, start=c(1980, 12))
Plot(Apple.ts) 
´´´


## ggplot2

ggplot time series of single variable in which the time series can be plotted as a line and/or an area, for which there are specific geoms.


ggplot requires tidy formatted data. To plot a single time series, just need two columns of the data table, the column of dates and one column of measurements. Although the data table is not tidy, de facto reading just the date and the stock prices for a single company acts as tidy data, ignoring the other measurements in each data row.

Plot line only.

´´´
ggplot(mydata, aes(date, Apple)) + geom_line()
´´´

Plot area only.

´´´
ggplot(mydata, aes(date, Apple)) + geom_area()
´´´

Plot customized area.

´´´
ggplot(mydata, aes(date, Apple)) + geom_area(fill="green", alpha=.2)
´´´

Plot customized line and area.

´´´
ggplot(mydata, aes(date, Apple)) +
  geom_area(fill=rgb(0,1,0), alpha=.2) +
  geom_line(color="darkgreen")
´´´

Can modify the format of the displayed dates with the ggplot scale_x_date function. The scales package is needed for the date_format function.

´´´
library(scales)
´´´


See ?strptime for date formats, e.g., %b is the abbreviated month name.

´´´
ggplot(mydata, aes(date, Apple)) + geom_line() +
  scale_x_date(labels=date_format("%b-%Y"))
´´´


## Multiple Time Series on the Same Graph

The data table as read is in *wide format*, multiple measurements per row. *Not* in tidy format because multiple observations, that is, measurements from different companies, appear in the same row.

## lessR 

For lessR, specify the multiple variables as a vector. lessR accepts the data in this non-tidy wide format.

´´´
Plot(date, c(Apple, IBM, Intel))
´´´

An alternate format for the different plots is to successively stack the plots on top of each other, according to the parameter stack. By default the area under each plot is filled according to a lighter color than its stroke (border). (Currently no way to specify the area fill color.)
Plot(date, c(Apple, IBM, Intel), stack=TRUE)

Go to a black background. Can also invoke colors orange.black or gray.black with the lessR theme function.

´´´
Plot(date, c(Apple, IBM, Intel), stack=TRUE, bg="black", grid="off")
´´´


Turn off the area fill by setting area to FALSE.

´´´
Plot(date, c(Apple, IBM, Intel), stack=TRUE, area=FALSE)
´´´

Turn off the border by setting line.width=0.

´´´
Plot(date, c(Apple, IBM, Intel), stack=TRUE, line.width=0)
´´´

Can easily change the order of the plots by changing the order of the variables in the input vector.

´´´
Plot(date, c(Intel, Apple, IBM))  # new order
´´´

lessR also accepts the data from a multivariate R time series. However, to create the time series the data must be ordered from oldest to most recent. To do so, use the lessR Sort function, as base R does not have a function for sorting a data frame.

´´´
mydata <- Sort(date, quiet=TRUE) 
´´´

To create the multivariate time series, first create an R matrix form of the stock prices for the three companies. Then apply the ts function.

´´´
a <- as.matrix(mydata[, c("Apple", "IBM", "Intel")], nrow=nrow(mydata), ncol=3)
a.ts <- ts(a, frequency=12, start=c(1980, 12))
´´´

Feed the multivariate time series directly into the lessR Plot function.

´´´
Plot(a.ts)
´´´

As before, can also stack the time series plots.

´´´
Plot(a.ts, stack=TRUE)
´´´

## ggplot2

Consistent with Hadley Wickham's tidyverse that emphasizes tidy data, ggplot2 requires input data to be tidy. To plot multiple time series on the same graph, here by company, tidy format dictates one observation per row.

Tidy the data table to *long format*, with one observation per row. To reshape to tidy data, use the melt function from Hadley Wickham's reshape2 package. That is, melt the wide form of the data table with multiple observations per row to the long form, i.e., tidy form.

´´´
library(reshape2)
´´´

The *melt* function refers to three different types of variables.

* id.vars: x-axis variable, here the dates to be plotted against

* value.name: y-axis variable, the measured values plotted against the dates

* variable.name: the grouping variable Company

The variable Company is created from the variables in the existing wide form of the data table: Apple, IBM, and Intel.


Function melt presumes by default that after the ID variable and variable names, all remaining variables are measured variables, here Apple, IBM and Intel. melt then takes the measurements for these variables and puts them under the variable specified as the value.name, and takes the name of each of the original variables and defines these names as values of the corresponding grouping variable Company.


Here leave the original wide form of the data in data frame mydata alone and instead create a new data frame in long format called myd.

´´´
myd <- melt(mydata, id.vars="date", variable.name="Company", value.name="Price") 
´´´

The newly created variable Company has three values:  Apple, IBM, Intel.

´´´
head(myd, n=3)
´´´

Now can plot each time series in a different color.

´´´
ggplot(myd, aes(date, Price, color=Company)) + geom_line()
´´´

Or, differentiate the plots from each other by the type of plotting line.

´´´
ggplot(myd, aes(date, Price, linetype=Company)) + geom_line()
´´´


Stacked area plot, each area (region) plotted separately.

´´´
ggplot(myd, aes(date, Price, fill=Company)) + geom_area()
´´´

Change the order of the stacking by using the R factor function to re-order the levels of the grouping variable Company, a factor, which defines the stack order.

´´´
myd <- Transform(Company=factor(Company, levels=c("Intel", "Apple", "IBM")), data=myd, quiet=TRUE)
´´´

Then reorder the data frame according to this order. General specification is myd[rows,columns], so myd[rows, ] means no change to the columns.

´´´
myd <- myd[order(myd$Company), ]
´´´

Plot with new order.

´´´
ggplot(myd, aes(date, Price, fill=Company)) + geom_area()
´´´


## ggplot2 Faceted Time Series

With ggplot2, can plot each time series separately in its own graph, stacked vertically for comparison.

´´´
ggplot(myd, aes(date, Price, fill=Company)) + geom_area() + facet_grid(Company ~ .)
´´´

Retain the gray scale, with a narrow black border at top of each graph.

´´´
ggplot(myd, aes(date, Price, fill=Company)) +
  geom_area(color="black", size=.25, fill="darkgray") +
  facet_grid(Company ~ .)
´´´

## ggplot2 Customization 

PACKAGE RColorBrewer has functions that generate gradients of colors. But to see all the scales, need a RColorBrewer function, so load the library.

´´´
library(RColorBrewer)
´´´

Display built-in color scales from the RColorBrewer library that are synchronized with ggplot via special ggplot functions. 

´´´
display.brewer.all()
´´´

Use ggplot functions scale_fill_brewer or scale_color_brewer, the distinction between filling in the interior of a region and the border of the region.

Use the default brewer scale, "Blues".

´´´
ggplot(myd, aes(date, Price, fill=Company)) + geom_area() +
  scale_fill_brewer()
´´´

Specify the gray brewer scale.

´´´
ggplot(myd, aes(date, Price, fill=Company)) + geom_area() +
  scale_fill_brewer(palette="Greys")
´´´

An explicit gray scale function, from which can specify start and end points of grayness, where 0 is black, 1 is white.

´´´
ggplot(myd, aes(date, Price, fill=Company)) + geom_area() +
  scale_fill_grey(start=.4, end=.8)
´´´

Can also manually specify discrete color ranges, here toned down a bit with some alpha transparency.

´´´
ggplot(myd, aes(date, Price, fill=Company)) + geom_area(alpha=.7) +
  scale_fill_manual(values=c(Apple="blue", IBM="red", Intel="green"))
´´´

The ggplot scales are based on the hls (or hsl) color model: hue lightness (luminance) saturation.

HSL Color Picker: http://www.workwithcolor.com/hsl-color-picker-01.htm

Darken colors: changed default luminosity from 65 down to 45.

´´´
ggplot(myd, aes(date, Price, fill=Company)) + geom_area() +
  scale_fill_hue(l=45)
´´´

Can modify virtually every detail of a ggplot graph with the theme function. Here modify the labels, title and theme.

´´´
ggplot(myd, aes(date, Price, fill=Company)) + geom_area(alpha=.8) +
  labs(y="Adjusted Closing Price") +
  ggtitle("Stock Market Data") + 
  theme_bw() +
  theme(panel.grid.major.y=element_line(color="grey50"),
        panel.grid.major.x=element_blank(),
        panel.grid.minor=element_blank(),
        plot.title=element_text(size=rel(1.1), face="bold"),
        legend.position="top",
        legend.title=element_blank(),
        legend.key=element_blank())
´´´


## Forecasting with Time Series

Get the data.

´´´
mydata <- Read("./PPStech.csv", colClasses=list(date="Date"))
´´´

First use R functions to get forecast. Need to get data re-ordered from earliest to latest for R and lessR. R has no single function to sort a data frame, here use lessR Sort.

´´´
mydata <- Sort(date)
´´´

In base R, to work with time series data convert the vector of values to an R class specifically called ts for time series. Create the time series object with R function ts. The dates are calculated as specified by the ts function, not read from the data. ts is an R function, so need to specify the relevant data frame for each specified variable.

´´´
A <- ts(mydata$Apple, start=c(1980,12), frequency=12)
´´´

## Interlude: How R works.

View the time series, monthly data from Dec 1980 until May 2016.

´´´
A
´´´

Use the R class function to know what is the corresponding class, such as integer, Date, ts, etc. We created an R object of class ts.

´´´
class(A)
´´´


Plot is what R calls a generic function, each method is a version of the function adapted to different classes of input. View all different plot methods with the R methods function.

´´´
methods(plot)
´´´

Standard R plot function, here for class ts.

´´´
plot(A)
´´´

Same as explicitly indicating ts method for plot.

´´´
plot.ts(A)
´´´

lessR function Plot also plots a time series object. Note that lessR graphics may require first deleting the R graph.

´´´
Plot(A)   
´´´

## Holt-Winters Exponential Smoothing Forecast

Exponential smoothing models the current value as a weighted average of all past observations with exponentially decreasing weights over time. One of the most widely used exponential smoothing forecasting methods is Holt-Winters, which models trend and seasonal components, called triple exponential smoothing.

R provides the corresponding function, HoltWinters. Here save the results into an R object named Ahw.

´´´
Ahw <- HoltWinters(A)
´´´

The result is a class of hw.

´´´
class(Ahw)
´´´

Holt-Winters estimates the trend (a and b) and seasonality (s). Display the output by listing the name of the created R object.

´´´
Ahw
´´´

Obtain the forecasts with the R generic predict function, here the method adapted for the hw class, predict.HoltWinters.

´´´
Ahw.p <- predict(Ahw, n.ahead=24) 
Ahw.p
´´´

Plot data in the time series object A. Accommodate room for plot beyond actual data for the forecasted values.

´´´
plot(A, xlim=c(1980, 2018))
´´´

Plot the forecasts in Ahw.p into the future. lines(Ahw.p, col="red")

Include error bands for the forecasts from package/function forecast.

´´´
library(forecast)
´´´

Create object of class forecast. Forecast 24 months into the future. Obtain the forecast plus the .80 and .95 confidence bands.

´´´
fhw <- forecast(Ahw, h=24)
´´´

Print (i.e., display) the contents of fhw, i.e., print.forecast.

´´´
fhw
´´´

Again, check the class just to know.

´´´
class(fhw)
´´´

Plot the forecast object fhw, i.e., plot.forecast.

´´´
plot(fhw)
´´´

Equivalent to ggplot.

´´´
autoplot(fhw)
´´´

Use R unclass function to see what is in fhw. Not the print view, but the actual contents. Stat output of R functions is in the form of an R list.

´´´
unclass(fhw)
´´´


## ggplot2 Forecast

The autoplot function from the forecast library is all we need, but for pedagogy, set up the plot directly from ggplot.


Optional, set up a custom range of dates to provide for the x-axis based on the R class of date. R internal date storage is the number of days since the origin of "1970-01-01". For pedagogy, to see how it works.

´´´
d1 <- as.Date(3987)  # "1980-12-01"
d2 <- as.Date(18993) # "2022-01-01"
´´´

In practice usually easier to convert a character string to an object of class Date. Still not needed, but can set up optional specified range of dates for plot.

´´´
d1 <- as.Date("1980-12-01")
d2 <- as.Date("2022-01-01")
´´´

now begin the work of what is needed in ggplot and get sequence of dates for the forecast with R seq function

´´´
date <- seq(as.Date("2016-06-01"), as.Date("2018-05-01"), by="month")
´´´

Look at the output of unclass(fhw) to see what is in fhw. Second column of fhw$lower and fhw$upper are the .95 confidence bounds. fhw$mean contains the predictions. Use this information to create a new data frame, called df.

´´´
df <- data.frame(date, as.numeric(fhw$mean), fhw$lower[,2], fhw$upper[,2])
names(df) <- c("date", "Apple", "lower95", "upper95")
´´´


´´´
head(df, n=3)
´´´

Now the structure of the df data frame matches the mydata data frame. 

´´´
head(mydata, n=3)
´´´

Can optionally add the xlim specification to plot a wider x-axis. Just plot the .95 confidence interval here, using geom_smooth. Plot the data from data frame mydata. Plot the forecasts from data frame df.

´´´
ggplot(mydata, aes(date, Apple)) + geom_line(color="black") +
  #xlim(d1, d2) +
  geom_line(data=df, aes(date, Apple, color="red")) +
  geom_smooth(data=df, mapping=aes(ymin=lower95, ymax=upper95), stat="identity") +
  theme(legend.position="none")
´´´