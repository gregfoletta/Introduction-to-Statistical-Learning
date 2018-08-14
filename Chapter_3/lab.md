# Chapter 3 - Lab

Load the required libraries, and convert the the Boston data to a tibble:

```r
library(tidyverse)
library(broom)
library(MASS)
library(ISLR)

boston <- as.tibble(Boston)
```

Calculate the linear regression of lstat (lower status of population) on to medv (median value of owner-occupied homes) and tidy it using broom:


```r
lm_boston <- lm(medv ~ lstat, boston) %>% tidy

lm_boston
```

```
## # A tibble: 2 x 5
##   term        estimate std.error statistic   p.value
##   <chr>          <dbl>     <dbl>     <dbl>     <dbl>
## 1 (Intercept)   34.6      0.563       61.4 3.74e-236
## 2 lstat         -0.950    0.0387     -24.5 5.08e- 88
```

```r
summary(lm_boston)
```

```
##      term              estimate        std.error         statistic      
##  Length:2           Min.   :-0.950   Min.   :0.03873   Min.   :-24.528  
##  Class :character   1st Qu.: 7.926   1st Qu.:0.16971   1st Qu.: -3.042  
##  Mode  :character   Median :16.802   Median :0.30068   Median : 18.444  
##                     Mean   :16.802   Mean   :0.30068   Mean   : 18.444  
##                     3rd Qu.:25.678   3rd Qu.:0.43165   3rd Qu.: 39.929  
##                     Max.   :34.554   Max.   :0.56263   Max.   : 61.415  
##     p.value         
##  Min.   :0.000e+00  
##  1st Qu.:1.270e-88  
##  Median :2.541e-88  
##  Mean   :2.541e-88  
##  3rd Qu.:3.811e-88  
##  Max.   :5.081e-88
```

```r
confint(lm_boston)
```

```
## Warning: Unknown or uninitialised column: 'coefficients'.
```

```
## Error in UseMethod("vcov"): no applicable method for 'vcov' applied to an object of class "c('tbl_df', 'tbl', 'data.frame')"
```

The `predict()` method is given the result of the linear regression and some predictors. It returns a data frame with the predicted response variable.

	> predict(lm_boston, data.frame( lstat = c(1,20,40) ))
	        1         2         3 
	33.603792 15.552854 -3.448133 

Not that the name of the predictor must match the name given in the linear regression.

Lets add the prediction and the residuals for each of our lstat observations:

	> boston <- boston %>% mutate(medv_lm = predict(lm_boston))
	> boston <- boston %>% mutate(medv_resid = residuals(lm_boston))

We now graph these:

	boston %>% ggplot(aes(lstat, medv)) + 
		geom_smooth(method = 'lm') + 
		geom_point(alpha = .4) + 
		geom_point(aes(lstat, medv_lm), shape = 1) + 
		geom_segment(aes(xend = lstat, yend = medv_lm), alpha = .5, colour = 'grey')

![medv ~ lstat lm with residuals](medv_regession_with_residuals.png)




	


