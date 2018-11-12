# Chapter 5 - Applied


```r
library(ISLR)
library(broom)
library(modelr)
library(tidyverse)
```


## 5)

*In Chapter 4, we used logistic regression to predict the probability of default using income and balance on the Default data set. We will now estimate the test error of this logistic regression model using the validation set approach. Do not forget to set a random seed before beginning your analysis.*

### a)
*Fit a logistic regression model that uses income and balance to predict default.*


```r
default <- as.tibble(Default)
default.log <- glm(default~balance, data = default, family = binomial)
```

### b)
*Using the validation set approach, estimate the test error of this model. In order to do this, you must perform the following steps:*

#### i)
*Split the sample set into a training set and a validation set.*

```r
set.seed(1)
default_split <- resample_partition(default, c(train = 0.5, test = 0.5))
```

#### ii)
*Fit a multiple logistic regression model using only the training observations.*

```r
default_split_train <- glm(default ~ balance, data = as.tibble(default_split$train), family = binomial)
```

#### iii)
*Obtain a prediction of default status for each individual in the validation set by computing the posterior probability of default for that individual, and classifying the individual to the default category if the posterior probability is greater than 0.5.*

```r
as.tibble(default_split$test) %>% 
    mutate(pred_default = ifelse(predict(default_split_train, ., type = 'response') < 0.5, "No", "Yes"))
```

```
## # A tibble: 5,001 x 5
##    default student balance income pred_default
##    <fct>   <fct>     <dbl>  <dbl> <chr>       
##  1 No      No        1074. 31767. No          
##  2 No      No         529. 35704. No          
##  3 No      Yes        920.  7492. No          
##  4 No      No         826. 24905. No          
##  5 No      Yes        809. 17600. No          
##  6 No      No        1161. 37469. No          
##  7 No      No         237. 28252. No          
##  8 No      No        1113. 23810. No          
##  9 No      No           0  50265. No          
## 10 No      Yes        528. 17637. No          
## # ... with 4,991 more rows
```

#### iv)
*Compute the validation set error, which is the fraction of the observations in the validation set that are misclassified.*

```r
as.tibble(default_split$test) %>% 
    mutate(pred_default = ifelse(predict(default_split_train, ., type = 'response') < 0.5, "No", "Yes")) %>% 
    group_by(default, pred_default) %>% 
    tally()
```

```
## # A tibble: 4 x 3
## # Groups:   default [?]
##   default pred_default     n
##   <fct>   <chr>        <int>
## 1 No      No            4821
## 2 No      Yes             11
## 3 Yes     No             122
## 4 Yes     Yes             47
```

Out of 5001 observations, 11 + 122 are incorrect. The error rate is therefore (11 + 122) / 5001 = 2.65%

### c)
*Repeat the process in (b) three times, using three different splits of the observations into a training set and a validation set. Comment on the results obtained.*

We'll be a bit lazy with this and use a for loop.


```r
set.seed(2)
for (i in 1:3) {
    default_split <- resample_partition(default, c(train = 0.5, test = 0.5))
    default_split_train <- glm(default ~ balance, data = as.tibble(default_split$train), family = binomial)
    as.tibble(default_split$test) %>% 
        mutate(pred_default = ifelse(predict(default_split_train, ., type = 'response') < 0.5, "No", "Yes")) %>% 
        group_by(default, pred_default) %>% 
        tally() %>% 
        print()
}
```

```
## # A tibble: 4 x 3
## # Groups:   default [?]
##   default pred_default     n
##   <fct>   <chr>        <int>
## 1 No      No            4827
## 2 No      Yes             24
## 3 Yes     No              99
## 4 Yes     Yes             51
## # A tibble: 4 x 3
## # Groups:   default [?]
##   default pred_default     n
##   <fct>   <chr>        <int>
## 1 No      No            4826
## 2 No      Yes             23
## 3 Yes     No             113
## 4 Yes     Yes             39
## # A tibble: 4 x 3
## # Groups:   default [?]
##   default pred_default     n
##   <fct>   <chr>        <int>
## 1 No      No            4807
## 2 No      Yes             20
## 3 Yes     No             125
## 4 Yes     Yes             49
```

We get error rates of 2.4%, 2.8% and 2.7%.

### d)
*Now consider a logistic regression model that predicts the prob ability of default using income , balance , and a dummy variable for student . Estimate the test error for this model using the validation set approach. Comment on whether or not including a dummy variable for student leads to a reduction in the test error rate.*

We modify the formula in the `glm()` to be `default ~ balance + student`. We then run the three validation set tests and get error percentages of 2.4%, 2.7% and 2.7%. There seems to be no reduction in the error rate by adding in the student variable.


## 6)
*We continue to consider the use of a logistic regression model to predict the probability of default using income and balance on the Default data set. In particular, we will now compute estimates for the standard errors of the income and balance logistic regression co efficients in two different ways: (1) using the bootstrap, and (2) using the standard formula for computing the standard errors in the glm() function.*

### a)
*Using the summary() and glm() functions, determine the estimated standard errors for the coefficients associated with income and balance in a multiple logistic regression model that uses both predictors.*


```r
glm(default ~ income + balance, data = default, family = 'binomial') %>% tidy()
```

```
## # A tibble: 3 x 5
##   term           estimate  std.error statistic   p.value
##   <chr>             <dbl>      <dbl>     <dbl>     <dbl>
## 1 (Intercept) -11.5       0.435         -26.5  2.96e-155
## 2 income        0.0000208 0.00000499      4.17 2.99e-  5
## 3 balance       0.00565   0.000227       24.8  3.64e-136
```

We see the standard error for the coefficients is 0.00000499 for income and 0.000227 for balance.

### b) & c)
*Use the bootstrap to estimate the standard errors of the logistic regression coefficients*



```r
set.seed(1)
default %>% 
    modelr::bootstrap(n = 20) %>% 
    mutate(model = map(strap, ~glm(default~income+balance, data = .x, family = 'binomial'))) %>% 
    mutate(tidy = map(model, ~tidy(.x))) %>% 
    unnest(tidy) %>% 
    group_by(term) %>% 
    summarise(avg_stderr = mean(std.error))
```

```
## # A tibble: 3 x 2
##   term        avg_stderr
##   <chr>            <dbl>
## 1 (Intercept) 0.429     
## 2 balance     0.000225  
## 3 income      0.00000498
```

We see the average standard error to be 0.000225 for balance and 0.00000498 for income.

### d)
*Comment on the estimated standard errors.*

The difference in the standard errors from the bootstrap compared to the formula is small: a 1% different from balance and a .2% difference for income.

## 7)
*Compute the LOOCV error for a simple logistic regression model on the Weekly data set.*

### a) 
*Fit a logistic regression model that predicts Direction using Lag1 and Lag2*


```r
weekly <- as.tibble(Weekly)
weekly.logistic <- glm(Direction ~ Lag1 + Lag2, data = weekly, family = 'binomial')
```

### b)
*Fit a logistic regression model that predicts Direction using Lag1 and Lag2 using all but the first observation.*

```r
weekly.logistic.loo <- glm(Direction ~ Lag1 + Lag2, data = weekly[-1,], family = 'binomial')
```

### c)
*Use the model from (b) to predict the direction of the first observation.*


```r
weekly[1,] %>% 
    mutate(Prediction = ifelse(predict(weekly.logistic.loo, ., type = 'response') > 0.5, "Up", "Down")) %>% 
    select(Direction, Prediction)
```

```
## # A tibble: 1 x 2
##   Direction Prediction
##   <fct>     <chr>     
## 1 Down      Up
```

The prediction was 'Up', but the true direction was 'Down'.

### d)
*Write a for loop from i = 1 to i = n, where n is the number of observations in the data set, that performs each of the following steps:
    * Fit a logistic regression model using all but the ith observation to predict Direction using Lag1 and Lag2 .
    * Compute the posterior probability of the market moving up for the ith observation.
    * Use the posterior probability for the ith observation in order to predict whether or not the market moves up.
    * Determine whether or not an error was made in predicting the direction for the ith observation. If an error was made, then indicate this as a 1, and otherwise indicate it as a .*


```r
weekly %>% 
    crossv_kfold(k = nrow(.)) %>% 
    mutate(model = map(train, ~glm(Direction ~ Lag1 + Lag2, data = .x, family = 'binomial'))) %>% 
    mutate(prediction = map2_chr(model, test, ~ifelse(predict(.x, .y, type = 'response') > 0.5, "Up", "Down"))) %>% 
    mutate(test_direction = map_chr(test, ~as.character(as.tibble(.x)[['Direction']]))) %>% 
    summarise(error = mean(prediction != test_direction))
```

```
## # A tibble: 1 x 1
##   error
##   <dbl>
## 1 0.450
```


