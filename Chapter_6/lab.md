# Chapter 6 - Lab


```r
library(broom)
library(ISLR)
library(leaps)
library(tidyverse)
```

## 6.5.1 - Best Subset Selection

We wish to predict a baseball player's salary on the bassis of various statistics associated with the performance in the previous year. Let's remove the players for which the salary is missing from the dataset.


```r
hitters <- as.tibble(Hitters)
hitters <- hitters %>% dplyr::filter(!is.na(Salary))
```

We use the `regsubsets()` function to perform a best subset selection by identifying the best model that contains a given number of predictors.


```r
hitter_regsub <- regsubsets(Salary ~ ., hitters)
summary(hitter_regsub)
```

```
## Subset selection object
## Call: regsubsets.formula(Salary ~ ., hitters)
## 19 Variables  (and intercept)
##            Forced in Forced out
## AtBat          FALSE      FALSE
## Hits           FALSE      FALSE
## HmRun          FALSE      FALSE
## Runs           FALSE      FALSE
## RBI            FALSE      FALSE
## Walks          FALSE      FALSE
## Years          FALSE      FALSE
## CAtBat         FALSE      FALSE
## CHits          FALSE      FALSE
## CHmRun         FALSE      FALSE
## CRuns          FALSE      FALSE
## CRBI           FALSE      FALSE
## CWalks         FALSE      FALSE
## LeagueN        FALSE      FALSE
## DivisionW      FALSE      FALSE
## PutOuts        FALSE      FALSE
## Assists        FALSE      FALSE
## Errors         FALSE      FALSE
## NewLeagueN     FALSE      FALSE
## 1 subsets of each size up to 8
## Selection Algorithm: exhaustive
##          AtBat Hits HmRun Runs RBI Walks Years CAtBat CHits CHmRun CRuns
## 1  ( 1 ) " "   " "  " "   " "  " " " "   " "   " "    " "   " "    " "  
## 2  ( 1 ) " "   "*"  " "   " "  " " " "   " "   " "    " "   " "    " "  
## 3  ( 1 ) " "   "*"  " "   " "  " " " "   " "   " "    " "   " "    " "  
## 4  ( 1 ) " "   "*"  " "   " "  " " " "   " "   " "    " "   " "    " "  
## 5  ( 1 ) "*"   "*"  " "   " "  " " " "   " "   " "    " "   " "    " "  
## 6  ( 1 ) "*"   "*"  " "   " "  " " "*"   " "   " "    " "   " "    " "  
## 7  ( 1 ) " "   "*"  " "   " "  " " "*"   " "   "*"    "*"   "*"    " "  
## 8  ( 1 ) "*"   "*"  " "   " "  " " "*"   " "   " "    " "   "*"    "*"  
##          CRBI CWalks LeagueN DivisionW PutOuts Assists Errors NewLeagueN
## 1  ( 1 ) "*"  " "    " "     " "       " "     " "     " "    " "       
## 2  ( 1 ) "*"  " "    " "     " "       " "     " "     " "    " "       
## 3  ( 1 ) "*"  " "    " "     " "       "*"     " "     " "    " "       
## 4  ( 1 ) "*"  " "    " "     "*"       "*"     " "     " "    " "       
## 5  ( 1 ) "*"  " "    " "     "*"       "*"     " "     " "    " "       
## 6  ( 1 ) "*"  " "    " "     "*"       "*"     " "     " "    " "       
## 7  ( 1 ) " "  " "    " "     "*"       "*"     " "     " "    " "       
## 8  ( 1 ) " "  "*"    " "     "*"       "*"     " "     " "    " "
```

The asterisk indicates a given variable is included in the model. By default it goes up to eight variables, `nvmax` can be used to increase/decrease this.

The summary function also returns the $R^2$, RSS, adjusted $R^2$, $C_p$ and BIC. Let's extract these values out as a tibble.


```r
(
hitters %>% 
    regsubsets(Salary ~ ., .) %>% 
    summary() %>% 
    rbind() %>% 
    as.tibble() %>% 
    dplyr::select(rsq, rss, adjr2, cp, bic) %>% 
    unnest() %>%
    mutate(nvar = row_number())
)
```

```
## # A tibble: 8 x 6
##     rsq       rss adjr2     cp    bic  nvar
##   <dbl>     <dbl> <dbl>  <dbl>  <dbl> <int>
## 1 0.321 36179679. 0.319 104.    -90.8     1
## 2 0.425 30646560. 0.421  50.7  -129.      2
## 3 0.451 29249297. 0.445  38.7  -136.      3
## 4 0.475 27970852. 0.467  27.9  -142.      4
## 5 0.491 27149899. 0.481  21.6  -144.      5
## 6 0.509 26194904. 0.497  14.0  -148.      6
## 7 0.514 25906548. 0.501  13.1  -145.      7
## 8 0.529 25136930. 0.514   7.40 -148.      8
```

Let's graph the RSS, adjusted $R^2$, $C_p$ and BIC to help us select a model. We'll also increase `nvmax` to all 19 variables other than `Salary`.


```r
hitters %>% 
    regsubsets(Salary ~ ., ., nvmax = 19) %>% 
    summary() %>% 
    rbind() %>% 
    as.tibble() %>% 
    dplyr::select(rsq, rss, adjr2, cp, bic) %>% 
    unnest() %>% 
    dplyr::mutate(nvar = row_number()) %>% 
    gather(func, 'value', -nvar) %>% 
    ggplot() + 
    geom_line(aes(nvar, value)) + 
    facet_wrap(~func, scales = 'free')
```

![plot of chunk 6.5.1_d](figure/6.5.1_d-1.png)


## 6.5.2 - Forward and Backward Stepwise Selection

The `regsubsets()` function can also be used for forward and backward stepwise.


```r
hitters %>%
    regsubsets(Salary ~ ., ., nvmax = 19, method = 'backward') %>%
    summary() %>%
    rbind() %>%
    as.tibble() %>%
    dplyr::select(rsq, rss, adjr2, cp, bic) %>%
    unnest() %>%
    dplyr::mutate(nvar = row_number()) %>%
    gather(func, 'value', -nvar) %>%
    ggplot() +
    geom_line(aes(nvar, value)) +
    facet_wrap(~func, scales = 'free')
```

![plot of chunk 6.5.2_a](figure/6.5.2_a-1.png)


```r
hitters %>%
    regsubsets(Salary ~ ., ., nvmax = 19, method = 'backward') %>%
    summary() %>%
    rbind() %>%
    as.tibble() %>%
    dplyr::select(rsq, rss, adjr2, cp, bic) %>%
    unnest() %>%
    dplyr::mutate(nvar = row_number()) %>%
    gather(func, 'value', -nvar) %>%
    ggplot() +
    geom_line(aes(nvar, value)) +
    facet_wrap(~func, scales = 'free')
```

![plot of chunk 6.5.2_b](figure/6.5.2_b-1.png)

## 6.5.3 - Chosing Among Models

We can use validation set and cross-validation to choose the correct model.

In order for the approaches to yield accurate estimates of the test error, we must use *only the training observations* to perform all aspects of model fitting, including variable selection. If the full data set is used for the best subset selection step, the validation set errors and cross-validation errors obtained will not be accurate estimates of the test error.

There is no built in `predict()` method for the `regsubsets` class, so we first write our own.

This takes the `regsubsets` object, the `data`, and the `ncoefs` or number of coefficients to predict on. 

TODO 

## 6.6 - Ridge Regression and Lasso

The `glmnet` package can be used to perform ridge regression and lasso. The main function is `glmnet()`. It is different to other model fitting methods, in particular we must pass an `x` matrix as well as a `y` vector. We don't use the `y ~ x` syntax.


```r
library(glmnet)
library(modelr)
```


```r
x <- na.omit(hitters) %>% model.matrix(Salary ~ ., .) 
y <- hitters$Salary
y <- y[!is.na(y)]
```

The `glmnet()` function has an `alpha` parameter that determines what type of model is fit. If `alpha = 0` then a ridge regresion model is fit. If `alpha = 1` then a lasso is fit.

Let's fit a ridge regression model with an alpha between $10^10$ and $10^-2$:


```r
ridge.mod <- glmnet(x, y, alpha = 0, lambda = 10 ^ seq(10, -2, length = 100))
```

By default, the `glmnet()` function standardises the variables to the same scale.

Associated with each $\lambda$ is a vector of ridge regression coefficients, stored in a matrix and accessible using `coef()`.

We can also tidy the model:

```r
ridge.mod %>% tidy()
```

```
## # A tibble: 2,000 x 5
##    term         step estimate      lambda   dev.ratio
##    <chr>       <dbl>    <dbl>       <dbl>       <dbl>
##  1 (Intercept)     1  5.36e+2 10000000000 0.000000276
##  2 AtBat           1  5.44e-8 10000000000 0.000000276
##  3 Hits            1  1.97e-7 10000000000 0.000000276
##  4 HmRun           1  7.96e-7 10000000000 0.000000276
##  5 Runs            1  3.34e-7 10000000000 0.000000276
##  6 RBI             1  3.53e-7 10000000000 0.000000276
##  7 Walks           1  4.15e-7 10000000000 0.000000276
##  8 Years           1  1.70e-6 10000000000 0.000000276
##  9 CAtBat          1  4.67e-9 10000000000 0.000000276
## 10 CHits           1  1.72e-8 10000000000 0.000000276
## # ... with 1,990 more rows
```

Let's take a look at some of the terms and how they change depending on the value of the lambda. We take the tidy model and filter out a few terms. We take the log of the lambda and use that as our x axis. The y axis is our coefficient estimate.


```r
ridge.mod %>% 
    tidy() %>% 
    dplyr::filter(term %in% c('AtBat', 'Hits', 'Walks', 'Years', 'Salary', 'Runs')) %>% 
    mutate(log_lambda = log(lambda)) %>% 
    ggplot(aes(x = log_lambda, y = estimate, colour = term)) + 
    geom_line()
```

![plot of chunk 6.6.1_c](figure/6.6.1_c-1.png)

The `predict()` function can be used for a number of purposes. We can obtain the ridge regression coefficients for a new value of $\lambda$, say 50:

```r
predict(ridge.mod, s = 50, type = 'coefficients')[1:10,]
```

```
##  (Intercept)  (Intercept)        AtBat         Hits        HmRun 
## 48.766103292  0.000000000 -0.358099859  1.969359286 -1.278247981 
##         Runs          RBI        Walks        Years       CAtBat 
##  1.145891632  0.803829228  2.716185796 -6.218319217  0.005447837
```

Let's create a training and a test set and extract out the `x` and `y` training model matrix and vector respectively.


```r
set.seed(1)
hitters.resample <- 
    hitters %>% 
    resample_partition(c('train' = .5, 'test' = .5))

x.train <- 
    hitters.resample$train %>% 
    as.tibble() %>% 
    na.omit() %>% 
    model.matrix(Salary ~ ., .)

y.train <- 
    hitters.resample$train %>% 
    as.tibble() %>% 
    na.omit() %>% .$Salary
```

We now fit the model to the training set and generate the predictions using `predict()` with a $\lambda = 4$.


```r
x.test <- hitters.resample$test %>% as.tibble() %>% na.omit() %>% model.matrix(Salary ~ ., .)
y.test <- as.tibble(hitters.resample$test) %>% na.omit() %>% .$Salary

y.prediction <- predict(ridge.mod, s = 4, newx = x.test)
mean((y.prediction - y.test)^2)
```

```
## [1] 113895.5
```

Let's try predicting with a very large $\lambda$, which should take all of the coefficients to zero so we're only fitting the intercept:


```r
y.prediction <- predict(ridge.mod, s = 1e10, newx = x.test)
mean((y.prediction - y.test)^2)
```

```
## [1] 238591.4
```

We see the MSE increase. Now we compare against a regular least squres to determine whether there is a benefit in using $\lambda = 4$. A normal least squares is the same as having a $\lambda = 0$. We have to add `exact = T` becuase (from the manual):

```
If exact=FALSE (default), then the predict function uses linear interpolation to make predictions for values of s (lambda) that do not coincide with those used in the fitting algorithm. While this is often a good approximation, it can sometimes be a bit coarse. 

With exact=TRUE, these different values of s are merged (and sorted) with object$lambda, and the model is refit before predictions are made. In this case, it is required to supply the original data x= and y= as additional named arguments to predict() or coef(). The workhorse predict.glmnet() needs to update the model, and so needs the data used to create it.
```


```r
y.prediction <- predict(ridge.mod, s = 0, newx = x.test, exact = TRUE, x = x.train, y = y.train)
mean((y.prediction - y.test)^2)
```

```
## [1] 153964.5
```

So fitting with a $\lambda = 4$ leads to a lower test MSE.

In general it would be better to use cross validation to determine the $\lambda$. We can use the `cv.glmnet()` to do this. By default is does ten folds.


```r
set.seed(1)
cv.out <- cv.glmnet(x.train, y.train, alpha = 0) 
cv.out %>% 
    tidy() %>%
    mutate(log_lambda = log(lambda)) %>% 
    ggplot(aes(x = log_lambda, y = estimate)) + 
    geom_line() + 
    geom_point()
```

![plot of chunk 6.6.1_h](figure/6.6.1_h-1.png)

```r
cv.out %>% 
    tidy() %>% 
    arrange(estimate) %>% 
    .$lambda %>% 
    .[1]
```

```
## [1] 27.11101
```












