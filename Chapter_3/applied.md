# Chapter 3 - Applied

## 8) Auto data set



### a)
*Use the `lm()` function to perform a simple linear regression with `mpg` as the response and `horsepower` as the predictor. Print the results and comment on the output.*


```r
auto <- as_tibble(Auto)
lm_auto <- auto %>% lm(mpg ~ horsepower, .)
lm_auto %>% tidy()
```

```
## # A tibble: 2 x 5
##   term        estimate std.error statistic   p.value
##   <chr>          <dbl>     <dbl>     <dbl>     <dbl>
## 1 (Intercept)   39.9     0.717        55.7 1.22e-187
## 2 horsepower    -0.158   0.00645     -24.5 7.03e- 81
```

#### i) 
*Is there a relationship between the predictor and the response?*

To determine if there is a relationship, we need to look at two items: the p-values for the coefficients, the F-statistic, and the p-value for the F-statistic:

```r
lm_auto %>% tidy()
```

```
## # A tibble: 2 x 5
##   term        estimate std.error statistic   p.value
##   <chr>          <dbl>     <dbl>     <dbl>     <dbl>
## 1 (Intercept)   39.9     0.717        55.7 1.22e-187
## 2 horsepower    -0.158   0.00645     -24.5 7.03e- 81
```

```r
lm_auto %>% glance()
```

```
## # A tibble: 1 x 11
##   r.squared adj.r.squared sigma statistic  p.value    df logLik   AIC   BIC
## *     <dbl>         <dbl> <dbl>     <dbl>    <dbl> <int>  <dbl> <dbl> <dbl>
## 1     0.606         0.605  4.91      600. 7.03e-81     2 -1179. 2363. 2375.
## # ... with 2 more variables: deviance <dbl>, df.residual <int>
```

We in the `tidy()` output we can see the p-value for the intercept and the coefficient is very small, indicating a very low probability for the null hypothesis.A

In the `glance()` output, we see the `statistic` column (the F-statistic) is high at around 600, with a small p-value. This indicates that there is a relationship.

#### ii)
*How strong is the relationship*

To test how string the relationship is, we can look at the residual standard error (RSE) and the R^2 value.

We look at the `glance()` output again and see the R^2 value is .606. Recall that the R^2 is a value between 0 and 1 that is the 'proportion of the variance explained'. We can consider the relationship reasonably strong;

#### iii)
*Is the relationship positive or negative?*
There is a negative relationship between `mpg` and `horsepower`, thus miles per gallon goes down as horsepower goes up. This aligns with our conceptual idea.

#### iv) 
*What is the predicted `mpg` associated with a `horsepower` of 98? What are the associated 95% confidence and prediction intervals?*

We use the `interval` argument to the predict function. Note that the default `level` argument of `predict()` is 0.95 (95%).

```r
predict(lm_auto, tibble(horsepower = 98), interval = 'confidence')
```

```
##        fit      lwr      upr
## 1 24.46708 23.97308 24.96108
```

```r
predict(lm_auto, tibble(horsepower = 98), interval = 'predict')
```

```
##        fit     lwr      upr
## 1 24.46708 14.8094 34.12476
```

### b)
*Plot the response and the predictor. Display the least squares regression line.*


```r
auto %>% ggplot(aes(mpg, horsepower)) + geom_point() + geom_smooth(method = 'lm', formula = 'mpg ~ horsepower')
```

```
## Warning: Computation failed in `stat_smooth()`:
## object 'horsepower' not found
```

![plot of chunk applied_auto_mpg_hp](figure/applied_auto_mpg_hp-1.png)

### c) 
*Produce diagnostic plots (Resid v Leverage, Resid v Fitted, Fitted v Std Resid) and comment on any problems*

First off, lets have a look at the residuals versus the leverage:

```r
augment(lm_auto) %>% ggplot(aes(.hat, .resid)) + geom_point()
```

![plot of chunk applied_auto_resid_v_fitted](figure/applied_auto_resid_v_fitted-1.png)

Now we look at the fitted versus the residuals:

```r
augment(lm_auto) %>% ggplot(aes(.fitted, .resid)) + geom_point()
```

![plot of chunk applied_auto_fitted_v_residuals](figure/applied_auto_fitted_v_residuals-1.png)





