# Chapter 3 - Lab

Load the required libraries, and convert the the Boston data to a tibble:

```r
library(tidyverse)
library(broom)
library(MASS)
library(ISLR)

boston <- as.tibble(Boston)
```

Calculate the linear regression of lstat (lower status of population) on to medv (median value of owner-occupied homes).


```r
lm_boston <- lm(medv ~ lstat, boston)

lm_boston
```

```
## 
## Call:
## lm(formula = medv ~ lstat, data = boston)
## 
## Coefficients:
## (Intercept)        lstat  
##       34.55        -0.95
```

```r
summary(lm_boston)
```

```
## 
## Call:
## lm(formula = medv ~ lstat, data = boston)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -15.168  -3.990  -1.318   2.034  24.500 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept) 34.55384    0.56263   61.41   <2e-16 ***
## lstat       -0.95005    0.03873  -24.53   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 6.216 on 504 degrees of freedom
## Multiple R-squared:  0.5441,	Adjusted R-squared:  0.5432 
## F-statistic: 601.6 on 1 and 504 DF,  p-value: < 2.2e-16
```

```r
confint(lm_boston)
```

```
##                 2.5 %     97.5 %
## (Intercept) 33.448457 35.6592247
## lstat       -1.026148 -0.8739505
```

We can extract some of the key variables of the regression using the `augment()` function:

```r
augment(lm_boston)
```

```
## # A tibble: 506 x 9
##     medv lstat .fitted .se.fit  .resid    .hat .sigma   .cooksd .std.resid
##  * <dbl> <dbl>   <dbl>   <dbl>   <dbl>   <dbl>  <dbl>     <dbl>      <dbl>
##  1  24    4.98   29.8    0.406  -5.82  0.00426   6.22   1.89e-3    -0.939 
##  2  21.6  9.14   25.9    0.308  -4.27  0.00246   6.22   5.82e-4    -0.688 
##  3  34.7  4.03   30.7    0.433   3.97  0.00486   6.22   1.00e-3     0.641 
##  4  33.4  2.94   31.8    0.467   1.64  0.00564   6.22   1.98e-4     0.264 
##  5  36.2  5.33   29.5    0.396   6.71  0.00406   6.21   2.38e-3     1.08  
##  6  28.7  5.21   29.6    0.399  -0.904 0.00413   6.22   4.40e-5    -0.146 
##  7  22.9 12.4    22.7    0.276   0.155 0.00198   6.22   6.20e-7     0.0250
##  8  27.1 19.2    16.4    0.374  10.7   0.00362   6.20   5.44e-3     1.73  
##  9  16.5 29.9     6.12   0.724  10.4   0.0136    6.20   1.94e-2     1.68  
## 10  18.9 17.1    18.3    0.326   0.592 0.00274   6.22   1.25e-5     0.0954
## # ... with 496 more rows
```

Using this, we can generate a plot with:

    * The fitted line using `geom_smooth()`.
    * The (lstat, medv) x/y points.
    * The predicted value of medv given the linear regression.
    * Segments linking the actual and predicted values of medv.



```r
augment(lm_boston) %>% ggplot(aes(lstat, medv)) + 
    geom_smooth(method = 'lm') + 
    geom_point(alpha = .4) + 
    geom_point(aes(lstat, .fitted), shape = 1) + 
    geom_segment(aes(xend = lstat, yend = .fitted), alpha = .5, colour = 'grey')
```

![plot of chunk medv_lstat_plot](figure/medv_lstat_plot-1.png)

## Predicted versus Residuals

We plot the predited values versus the residuals to get an idea if the


```r
augment(lm_boston) %>% ggplot(aes(.fitted, .resid)) + geom_point() + geom_smooth()
```

```
## `geom_smooth()` using method = 'loess' and formula 'y ~ x'
```

![plot of chunk medv_lstat_predict_versus_residuals](figure/medv_lstat_predict_versus_residuals-1.png)

We can see a U shape, indicating non-linearity in the data.

## Leverage


```r
augment(lm_boston) %>% mutate(index = c(1:nrow(augment(lm_boston)))) %>% ggplot(aes(index, .hat)) + geom_point()
```

![plot of chunk medv_lstat_leverage](figure/medv_lstat_leverage-1.png)






	


