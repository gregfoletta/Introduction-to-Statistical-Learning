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
auto %>% ggplot(aes(mpg, horsepower)) + geom_point() + geom_smooth(method = 'lm', formula = 'y ~ x')
```

![plot of chunk applied_auto_mpg_hp](figure/applied_auto_mpg_hp-1.png)

### c) 
*Produce diagnostic plots (Resid v Leverage, Resid v Fitted, Fitted v Std Resid) and comment on any problems*

First off, lets have a look at the residuals versus the leverage:

```r
augment(lm_auto) %>% ggplot(aes(.hat, .resid)) + geom_point()
```

![plot of chunk applied_auto_leverage_v_fitted](figure/applied_auto_leverage_v_fitted-1.png)

There are a few points up in the top right. We take a look at the Cook's distance for the observations.


```r
augment(lm_auto) %>% mutate(i = 1:n()) %>% ggplot(aes(i, .cooksd)) + geom_bar(stat = 'identity')
```

![plot of chunk applied_auto_cooks_distance](figure/applied_auto_cooks_distance-1.png)

A couple of high points but all below 1.

Now we look at the fitted versus the residuals, and also fit a quadratic regression. We see a bit of a U shape, indicating potential non-linearity in the data.

```r
augment(lm_auto) %>% ggplot(aes(.fitted, .resid)) + geom_point() + geom_smooth(method = 'lm', formula = 'y ~ poly(x,2)')
```

![plot of chunk applied_auto_fitted_v_residuals](figure/applied_auto_fitted_v_residuals-1.png)

## 9) Multiple Linear Regression - Auto Data Set


```r
library(GGally)
library(corrplot)
```

### a)
*Produce a scatterplot matrix which includes all the data in the data set*

```r
auto %>% select(-'name') %>% ggpairs()
```

![plot of chunk applied_mult_auto_pairs](figure/applied_mult_auto_pairs-1.png)

### b)
*Compute the matrix of correlations between the variables.*

```r
auto %>% select(-'name') %>% cor() %>% corrplot(method = 'color')
```

![plot of chunk applied_mult_auto_corr](figure/applied_mult_auto_corr-1.png)

### c)
*Perform a multiple linear regression with `mpg` as the response and all other variables except `name` as the predictors.*


```r
lin_reg_auto <- lm(mpg ~ . -name, auto)
tidy(lin_reg_auto)
```

```
## # A tibble: 8 x 5
##   term          estimate std.error statistic  p.value
##   <chr>            <dbl>     <dbl>     <dbl>    <dbl>
## 1 (Intercept)  -17.2      4.64        -3.71  2.40e- 4
## 2 cylinders     -0.493    0.323       -1.53  1.28e- 1
## 3 displacement   0.0199   0.00752      2.65  8.44e- 3
## 4 horsepower    -0.0170   0.0138      -1.23  2.20e- 1
## 5 weight        -0.00647  0.000652    -9.93  7.87e-21
## 6 acceleration   0.0806   0.0988       0.815 4.15e- 1
## 7 year           0.751    0.0510      14.7   3.06e-39
## 8 origin         1.43     0.278        5.13  4.67e- 7
```

```r
glance(lin_reg_auto)
```

```
## # A tibble: 1 x 11
##   r.squared adj.r.squared sigma statistic   p.value    df logLik   AIC
## *     <dbl>         <dbl> <dbl>     <dbl>     <dbl> <int>  <dbl> <dbl>
## 1     0.821         0.818  3.33      252. 2.04e-139     8 -1023. 2065.
## # ... with 3 more variables: BIC <dbl>, deviance <dbl>, df.residual <int>
```
#### i)
*Is there a relationship between the predictors and the response?*
We test the null hypothesis of "are all of the regression coefficients zero?". The F-statistic 252 (far greater than 1) and has a p-value of 2e-139, indicating a low probability that this is just by chance. We can therefore say there is a relationship between the predictors and the response.

#### ii)
We look at the p-values for each of the predictors. The predictors which have a high probability of having an effect on the `mpg`, holding all others constant, appear to be `weight`, `year`, `displacement` and `origin`.

#### iii)
*What does the coefficient for the `year` variable suggest?*
The year coefficient suggests that a cars `mpg` gets larger - and therefore better - the later a car was made.

### d)
*Plot the diagnostic plots of the regression and comment on any problems with the fit.*

We go through our usual plots - first off is looking at the residuals versus the leverage:

```r
augment(lin_reg_auto) %>% mutate(i = 1:n()) %>% ggplot(aes(i, .cooksd)) + geom_bar(stat = 'identity')
```

![plot of chunk applied_multi_auto_leverage](figure/applied_multi_auto_leverage-1.png)

We don't see values with a significant Cook's distance. We move on to the fitted versus the residuals:

```r
augment(lin_reg_auto) %>% ggplot(aes(.fitted, .resid)) + geom_point() + geom_smooth(method = 'lm', formula = 'y~poly(x,2)')
```

![plot of chunk applied_auto_fitted_resid](figure/applied_auto_fitted_resid-1.png)
There is some evidence of the non-linearity of the results.

### e) 
*Use the `*` and `:` symbols to fit linear regressions with interaction effects. Are any interactions statistically significant?*
A `*` adds the predictors and the interaction term, whereas the `:` only adds the interaction term. I.e. `x\*y == x + y + x:y`.

Let's have a think about potential interactions - I think weight and year could interact, given the changes in materials. There could also be an f,Let's have a think about potential interactions - I think weight and year could interact, given the changes in materials. There could also be and interaction between cylinders and displacement:


```r
lm(mpg ~ weight*year + cylinders*displacement, auto) %>% tidy()
```

```
## # A tibble: 7 x 5
##   term                     estimate  std.error statistic  p.value
##   <chr>                       <dbl>      <dbl>     <dbl>    <dbl>
## 1 (Intercept)            -81.3      13.9           -5.86 9.86e- 9
## 2 weight                   0.0202    0.00467        4.33 1.88e- 5
## 3 year                     1.75      0.176          9.99 4.84e-21
## 4 cylinders               -1.49      0.400         -3.71 2.34e- 4
## 5 displacement            -0.0698    0.0127        -5.50 6.97e- 8
## 6 weight:year             -0.000347  0.0000618     -5.61 3.82e- 8
## 7 cylinders:displacement   0.00902   0.00156        5.78 1.53e- 8
```

All of the values appear to be reasonably statistically significant. In fact, if we have a look at the fitted vs residuals, it looks much better than before:

```r
lm(mpg ~ weight*year + cylinders*displacement, auto) %>% augment() %>% ggplot(aes(.fitted, .resid)) + geom_point() + geom_smooth()A
```

```
## Error: <text>:1:131: unexpected symbol
## 1: lm(mpg ~ weight*year + cylinders*displacement, auto) %>% augment() %>% ggplot(aes(.fitted, .resid)) + geom_point() + geom_smooth()A
##                                                                                                                                       ^
```

### f)
*Try different transformations of the variables and comment ont the findings.*

We try a few different transformations and pipe them through to the fitted versus residuals graph:


```r
lm(mpg ~ sqrt(horsepower), auto) %>% augment() %>% ggplot() + geom_point(aes(.fitted, .resid))
```

![plot of chunk applied_auto_transformations](figure/applied_auto_transformations-1.png)

```r
lm(mpg ~ log(horsepower), auto) %>% augment() %>% ggplot() + geom_point(aes(.fitted, .resid))
```

![plot of chunk applied_auto_transformations](figure/applied_auto_transformations-2.png)

```r
lm(1/mpg ~ horsepower, auto) %>% augment() %>% ggplot() + geom_point(aes(.fitted, .resid))
```

![plot of chunk applied_auto_transformations](figure/applied_auto_transformations-3.png)

```r
lm(1/mpg ~ horsepower + weight*year, auto) %>% augment() %>% ggplot() + geom_point(aes(.fitted, .resid))
```

![plot of chunk applied_auto_transformations](figure/applied_auto_transformations-4.png)

```r
lm(1/mpg ~ horsepower + weight*year, auto) %>% glance()
```

```
## # A tibble: 1 x 11
##   r.squared adj.r.squared   sigma statistic   p.value    df logLik    AIC
## *     <dbl>         <dbl>   <dbl>     <dbl>     <dbl> <int>  <dbl>  <dbl>
## 1     0.883         0.882 0.00572      731. 7.39e-179     5  1471. -2929.
## # ... with 3 more variables: BIC <dbl>, deviance <dbl>, df.residual <int>
```

The last one looks quite good.


## 10) Carseats Data Set

### a) 
*Fit a multiple regression model to predict `Sales` using `Price`, `Urban`, and `US`.*


```r
carseats <- as_tibble(Carseats)
cs_regress <- lm(Sales ~ Price + Urban + US, carseats)
cs_regress %>% tidy()
```

```
## # A tibble: 4 x 5
##   term        estimate std.error statistic  p.value
##   <chr>          <dbl>     <dbl>     <dbl>    <dbl>
## 1 (Intercept)  13.0      0.651     20.0    3.63e-62
## 2 Price        -0.0545   0.00524  -10.4    1.61e-22
## 3 UrbanYes     -0.0219   0.272     -0.0807 9.36e- 1
## 4 USYes         1.20     0.259      4.63   4.86e- 6
```

### b)
*Provide an interpretation of each coefficient in the model.*
* (Intercept) - the average number of sales of carseats, ignoring all other factors. 
* Price - the regression indicates a relationship between price and sales, given the low p-value of the t-statistic. An increase in price of a dollar results in a decrease of 54 carseats solds. 
* UrbanYes - given the high p-value, there doesn't appear to be a relationship between sales and whether a store is urban.
* USYes - given the low p-value, the store bein in the US results in 1200 more carseats being sold.

### c)
*Write out the model in equation form, being careful to handle the qualitative variables properly.*
`Sales = x * Price + y * Urban + z * US, where [Urban = Yes => y = 1|Urban = No =>  y = 0] & [US = Yes => z = 1|US = No => z = 0]`

### d)
*For which of the predictors can you reject the null hypothesis H 0 : βj = 0?*
The null hypothesis can be rejected for `Price` and `US`.

### e)
*On the basis of your response to the previous question, fit a smaller model that only uses the predictors for which there is evidence of association with the outcome.*

```r
cs_regress_reduced <- lm(Sales ~ Price + US, carseats)
cs_regress_reduced %>% tidy()
```

```
## # A tibble: 3 x 5
##   term        estimate std.error statistic  p.value
##   <chr>          <dbl>     <dbl>     <dbl>    <dbl>
## 1 (Intercept)  13.0      0.631       20.7  7.00e-65
## 2 Price        -0.0545   0.00523    -10.4  1.27e-22
## 3 USYes         1.20     0.258        4.64 4.71e- 6
```

### f)
*How well do the models in (a) and (e) fit the data?*

We look at the F-statistic and its assoicated p-value to determine how well the models fit:

```r
cs_regress %>% glance()
```

```
## # A tibble: 1 x 11
##   r.squared adj.r.squared sigma statistic  p.value    df logLik   AIC   BIC
## *     <dbl>         <dbl> <dbl>     <dbl>    <dbl> <int>  <dbl> <dbl> <dbl>
## 1     0.239         0.234  2.47      41.5 2.39e-23     4  -928. 1865. 1885.
## # ... with 2 more variables: deviance <dbl>, df.residual <int>
```

```r
cs_regress_reduced %>% glance()
```

```
## # A tibble: 1 x 11
##   r.squared adj.r.squared sigma statistic  p.value    df logLik   AIC   BIC
## *     <dbl>         <dbl> <dbl>     <dbl>    <dbl> <int>  <dbl> <dbl> <dbl>
## 1     0.239         0.235  2.47      62.4 2.66e-24     3  -928. 1863. 1879.
## # ... with 2 more variables: deviance <dbl>, df.residual <int>
```

We see no increase in the R-sqaured value - but we do see an increase in the F-statistic, and a decrease in its p-value.

### g)
*Using the model from (e), obtain 95 % confidence intervals for the coefficient(s).*


```r
cs_regress_reduced %>% confint()
```

```
##                   2.5 %      97.5 %
## (Intercept) 11.79032020 14.27126531
## Price       -0.06475984 -0.04419543
## USYes        0.69151957  1.70776632
```

### h)
*Is there evidence of outliers or high leverage observations in the model from (e)?*


```r
cs_regress_reduced %>% augment() %>% ggplot(aes(.fitted, .resid)) + geom_point()
```

![plot of chunk applied_carseats_10_h](figure/applied_carseats_10_h-1.png)

```r
cs_regress_reduced %>% augment() %>% ggplot(aes(.hat, .resid)) + geom_point()
```

![plot of chunk applied_carseats_10_h](figure/applied_carseats_10_h-2.png)

There doesn't appear to be any non-linearity in the daata, and the high leverage points don't appear to affect the data substantially.




