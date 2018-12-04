# Chapter 6 - Lab


```r
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
x <- model.matrix(Salary ~ ., hitters)
y <- hitters$Salary
y <- y[!is.na(y)]
```

The `glmnet()` function has an `alpha` parameter that determines what type of model is fit. If `alpha = 0` then a ridge regresion model is fit. If `alpha = 1` then a lasso is fit.

Let's fit a ridge regression model with an alpha between $10^10$ and $10^-2$:


```r
ridge.mod <- glmnet(x, y, alpha = 0, lambda = 10 ^ seq(10, -2, length = 100))
```

```
## Error in glmnet(x, y, alpha = 0, lambda = 10^seq(10, -2, length = 100)): could not find function "glmnet"
```

By default, the `glmnet()` function standardises the variables to the same scale.

Associated with each $\lambda$ is a vector of ridge regression coefficients, stored in a matrix and accessible using `coef()`.


```r
coef(ridge.mod)
```

```
## Error in coef(ridge.mod): object 'ridge.mod' not found
```

```r
dim(coef(ridge.mod))
```

```
## Error in coef(ridge.mod): object 'ridge.mod' not found
```

This is a 20 x 100 matrix with 20 rows (predictors + intercept) and 100 columns (one for each $\lambda$).

We expect the coefficient estimates to be much smaller in terms of their $\ell_2$ norm when a large value of $\lambda$ is used. Let's take a predictor (Runs) and graph it versus the $\lambda$ value:


```r
tibble(lambda = ridge.mod$lambda, Runs = coef(ridge.mod)[5,]) %>% 
    mutate(log_lambda = log(lambda)) %>% 
    ggplot(aes(x = log_lambda, y = Runs)) + 
    geom_point() + 
    geom_line()
```

```
## Error in eval_tidy(xs[[i]], unique_output): object 'ridge.mod' not found
```

The `predict()` function can be used for a number of purposes. We can obtain the ridge regression coefficients for a new value of $\lambda$, say 50:

```r
predict(ridge.mod, s = 50, type = 'coefficients')[1:10,]
```

```
## Error in predict(ridge.mod, s = 50, type = "coefficients"): object 'ridge.mod' not found
```



