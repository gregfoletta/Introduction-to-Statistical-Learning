# Chapter 5 - Lab - Cross-validation and the Bootstrap


```r
library(broom)
library(modelr)
library(tidyverse)
library(modelr)
library(ISLR)
```

## Validation Set

Let's first use the validation set approach. We use `resample_partition()` to generate a training set and a test set.

We can perform a linear regression with `lm()` on the training observations. We then run the prediction across the test set.


```r
set.seed(1)
auto <- as_tibble(Auto)
auto_sample <- auto %>% resample_partition(c(test = 0.5, train = 0.5))
auto.lm <- lm(mpg ~ horsepower, data = auto_sample$train)
as.tibble(auto_sample$test) %>% mse(auto.lm, data = .)
```

```
## [1] 23.37628
```

Let's now run across a number of polynomials and see how the MSE changes:


```r
auto.lms <- map(1:10, ~lm(mpg ~ poly(horsepower, .x), auto_sample$train))
map_df(1:10, 
    ~ auto %>% 
       slice(auto_sample$test$idx) %>% 
       mse(auto.lms[[.x]], .)
       mutate(poly = .x)
    ) %>% 
    ggplot(aes(poly,MSE)) + 
        geom_point() + 
        geom_line()
```

```
## Error: <text>:6:8: unexpected symbol
## 5:        mse(auto.lms[[.x]], .)
## 6:        mutate
##           ^
```

## Leave-one-out Cross Validation

We can use the `crossv_kfold()` function with an *k* parameter of the total number of observations. This the becomes the LOOCV. Let's see what the average MSE is for these observations. To do this, the `crossv_kfold()` function creates *k* train and *k* test resmaple objects. We perform a linear regression on each of the training samples. For each of these models, we calculate the MSE on the test sample, and then summarise the average MSE for each of the samples.


```r
auto %>% 
    crossv_kfold(k = nrow(.)) %>% 
    mutate(model = map(train, ~lm(mpg~horsepower, data = .))) %>% 
    mutate(mse = map2_dbl(model, test, ~mse(.x, .y))) %>% 
    summarise(mean_mse = mean(mse))
```

```
## # A tibble: 1 x 1
##   mean_mse
##      <dbl>
## 1     24.2
```

## k-fold Cross Validation

k-fold is the same as LOOCV, except we're reducing the number of folds using the *k* parameter.


```r
auto %>%
    crossv_kfold(k = 5) %>%
    mutate(model = map(train, ~lm(mpg~horsepower, data = .))) %>%
    mutate(mse = map2_dbl(model, test, ~mse(.x, .y))) %>%
    summarise(mean_mse = mean(mse))
```

```
## # A tibble: 1 x 1
##   mean_mse
##      <dbl>
## 1     24.1
```

## The Bootstrap

The advantage of a bootstrap is that it can be applied in almost all situations. Two steps are needed:
* Create a function that computes the statistic of interest.
* Repeatedly sample observations from the data with replacement.

Let's use the bootstrap to estimate the accuracy of a linear regression. In the pipeline below, we take the auto data set take 100 samples with replacement. On each of these samples we calculate the linear regression of mpg on to horsepower.

For each of the models we get the coefficient of the beta_1 value (using the `tidy()` function) and then calculate the standard error.


```r
set.seed(1)
auto %>% 
    bootstrap(n = 100) %>% 
    mutate(model = map(strap, ~lm(mpg~horsepower, .x))) %>% 
    mutate(coefs = map(model, ~tidy(.x)[2,])) %>% 
    unnest(coefs) %>% 
    summarise(stderr = sd(estimate)/sqrt(n()))
```

```
## # A tibble: 1 x 1
##     stderr
##      <dbl>
## 1 0.000762
```
