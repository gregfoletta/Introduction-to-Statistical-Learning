# Chapter 3 - Notes

## 3.1 - Simple Linear Regression

A simple linear regression predicts a response `Y` based on a single predictor variable `X`. 
```
Y ≈ β_0 + β_1X
```

Once we have training data to produce estimates for the coefficients, we can predict values by computing:
```
ŷ = β̂ 0 + β̂ 1x
```

### 3.1.1 - Estimating Coefficients

The goal is to obtain coefficients such that the linear model fits the data well - i.e. as close as possible to the data points. The most common approach involves minimising the **least squares** criterion.

We let `e_i = y_i − ŷ_i`, which represents the *i*th **residual**. The **residual sum of squares** or **RSS** is the sum of the squares of each of these residuals.

An example in R - we generate a our predictions base on f(x) + e, and also have a 'guess' at an f_hat(x). We calculate our y_i, and then calculate the RSS. 



```r
library(tidyverse)
```

```r
set.seed(1)
x <- 1:100
f <- function(x) 4 * x
f_hat <- function(x) 3.5 * x
y_i <- f(x) + rnorm(length(x), 0, .5)
y_hat_i <- f_hat(x)

RSS <- sum( (y_i - y_hat_i)^2 )
```

With some calculus, the RSS minimiser for `β̂ 1x` is the sum of the difference between `x` and the mean of `x` times by the difference between `y` and the mean of `y`, all divided by the sum of the square of the difference between `x` and the mean of `x`.


```r
beta_hat_1 <- sum( (x - mean(x)) * (y_i - mean(y_i)) ) / sum( (x - mean(x))^2 )
beta_hat_0 <- mean(y_i) - (beta_hat_1 * mean(x))

beta_hat_0
```

```
## [1] 0.06583287
```

```r
beta_hat_1
```

```
## [1] 3.999774
```

### 3.1.2 - Assessing the Accuracy of the Estimates

We take the analogy of μ̂, the **sample mean** being an estimate for μ, the **population mean**. The average sample mean over many data sets will be close to the population mean. In the code below, we create a population of 1,000,000 random variables, with very large standard deviation of 10,000. We see the mean is 10.46.

We then take 200 samples of 100 of the population, and calculate the mean for each sample. We see that each mean can be a very long way away from the real mean of 10.046.

We then take the mean of all of the sample means. We see this sample mean is 9.99, which is very close to the population mean.


```r
set.seed(1)
population <- rnorm(1000000, 10, 2)
(mu <- mean(population))
```

```
## [1] 10.00009
```

```r
(mu_hat <- map_dbl(1:200, ~mean(sample(population, 100))) %>% mean())
```

```
## [1] 9.991291
```

How close is a single estimate? In general we answer this by computing the **standard error** of μ̂, written Se(μ̂). This is `σ/sqrt(n)`, where sigma is the population standard mean. The population deviation is seldom known, so the standard error of the mean is usually estimated as the **sample standard deviation**.

The sample standard deviation is the sqaure root of the sum of the square of the difference between each x_i and the sample mean, divided by n - 1. Let's do this for our reponse variable:


```r
sd(y_i)
```

```
## [1] 116.0403
```

```r
sqrt( sum( (y_i - mean(y_i))^2 / (length(y_i) - 1) ) )
```

```
## [1] 116.0403
```

The standard error estimate is known as the **residual standard error**, and is given by the formula `RSE = sqrt(RSS / (n - 2))`. 

Using our previous generated values of `y_i` and `y_hat_i`, lets calculate the RSE:

```r
RSE <- sqrt( (sum((y_i - y_hat_i)^2)) / (length(y_i) - 2) )
RSE
```

```
## [1] 29.42717
```

The RSE for our 'guess' is 29.42. 

The standard error can be used to calculate confidence intervals. A 95% confidence interval is defined as a range of values such that with 95% probability, the range will contain the true unknown value of the parameter, or that it is within 2 standard deviations of the mean. Therefore the 95% confidence interval is +/- 2 * SE(β̂ _1) and +/- 2 * SE(β̂ _0). Thus there is a 95% probability that the true value of the slope of the linear regression is between 3.5 + 2 * 29.42, and 3.5 - 2 * 29.42. This is very wide, so we can't be very 'confident'. Of course our guess didn't minimise the RSS.

#### Hypothesis Tests

The standard errors are used to perform hypothesis tests. The most common is the null hypothesis `H_0` - 'there is no relationship between `X` and `Y` versus the *alternative hypthesis* - there is some relationship between `X` and `Y`' (H_a : β_1  = 0). 

To test the null hypothesis, we need to derermine with the coefficient estimate is sufficiently far from zero that we can be confident that it's non-zero. How far is far enough? This depends on the accuracy of the coefficient.

* If the standard error is small, then even small values of the coefficient may be strong evidence against the null hypothesis.
* If the stanard error is large, the coefficient must be large  in absolute value in order for us to reject the null hypothesis.

In practice, a **t-statistic** is calculated, where `t = β̂_1- 0 / SE(β̂_1)`

Let's take a look at the t-statistic for the slope of our linear regression:

```r
(t_stat <- (3.5 - 0) / 29.42)
```

```
## [1] 0.1189667
```

This measures how many standard deviations the coefficient is away from 0. If there is no relationship, then we expect that the formula will have a **t-distribution** with n - 2 degrees of freedom.

We can then compute the probability of observing any value equal to |t| or larger, assuming β̂_1 = 0. We call this probability the **p-value**. Roughtly speaking, we interpret the p-value as follows: *a small p-value indicates that it is unlikely to observe such a substantial association between the predictor and the response due to chance.

If we see a small p-value, then we can infer ther is an association between the predictor and the response. We *reject the null hypothesis*. Typical p-value cutoffs for rejecting the null hypothesis are 5% or 1%. When n = 30, these correspond to t-statistics of around 2 and 2.75 respectively.

### 3.1.3 - Assessing the Accuracy of the Model

The quality of the model is typically assessed using either the **residual standard error (RSE)** or the R^2 statistic.

The RSE is considered a measure of the lack of fit of the model. However it's an absolute measure, with the same units as Y. This makes it difficult to determine what a 'good' RSE is.A

The R^2 is an alternative measure of fit, and is the *proportion* of variance explained. It takes on a value between 0 and 1. It is equal to 1 minus the RSS divided by the TSS.

Let's look at it using our generated data - we re-calculate RSS from above for visibility.


```r
RSS <- sum( (y_i - y_hat_i)^2 )
TSS <- sum( (y_i - mean(y_i))^2 )
R_squared <- 1 - (RSS / TSS)
R_squared
```

```
## [1] 0.9363395
```

The constituent parts can be thought of as such:
* The TSS is the amount of variability inherent in the response before the regression is performed.
* The RSS measures the amount of variability left unexplained after performing the regression.
* TSS - RSS is therefore the amount variability in the response that is explained by performing the regression. 
* R^2 measures the *proportion* of variability in Y that can be explained using X.

## 3.2 - Multiple Linear Regression

Instead of fitting multiple linear regressions, the simple linear regression can be extended to accomodate multiple predictors. Each predictor is given its own slope coefficient.

Each coefficient `j` is then the average effect on Y of a one unit increase in X_j while *holding all other predictors fixed*.

### 3.2.1 Estimating the Regressio Coefficients

The parameters are estimated using the same least squares approach, minimising RSS where `RSS = sum( (y_i - f_hat(x))^2 )`. Each `f_hat(x)` now has multiple slope coefficients.

### 3.2.2 Important Questions

#### Is there a relationship between the response and the predictors?

In a simple linear regression we simply check whether the slope coefficient = 0. In the multiple regression settings with `p` predictors, we need to ask whether all of the regression coefficients are 0.

This hypothesis test is performed by computing the **F-statistic**, which is the TSS minus the RSS divided by p, divided by the RSS divided by n minus p minus 1.

```
F = ( (TSS - RSS)/p ) / ( RSS / (n - p - 1) )
```

If the linear model assumptions are correct:
* E{ RSS / (n - p - 1) } = sigma^2
* E{ (TSS - RSS) / p } = sigma^2

Thus if there is no relationship between the response and the predictors, one would expect the F-statistic to be close to 1.

How large does the F-statistic need to be? This depends**n** - when n is large, an F-statistic just a little larger than 1 might still provide evidence against H_0.

For any value of `n` and `p`, the p-value for the F-statistic can be calculated. Base on the p-value, we can determine whether or not to reject H_0.

Given individual p-values for each coefficient, why look at the overall F-statistic? Consider p = 100 and H_0: beta_0 ... beta_p = 0, so no variable is truly associated with the response. About 5% of the p-values will be below 0.05 by chance. Hence if we used individual t-statistics and p-values, there is an incorrect assumption.

#### Deciding on important variables.

**Forward selection** - begin with the null model, and fit p simple linear regressions and add to the model the variable that results in the lowest RSS.
**Backward selection** - start with all variables in the model, and remove the variable with the largest p-value. The new (p - 1) model is fit and the process continues.
**Moxed selecton** - start with no variables, and add the best fit. The p-values for data may become larger as more predictors are added. If a p-value rises above a certain threshold, it is removed.

#### Model fit

The two most common numerical measures of model fit are RSE and R^2. The R^2 always increases when more variables are added to the model.


#### Predictions

Once there is a model, it is straightforward to use it to predict. However there are three sorts of uncertainty associated with the prediction:
1) The coefficient estimates are estimates for the true population regression plane. This inaccuracy is related to the *reducible error*. We compute a confidence interval in order to determine how close `Y_hat` will be to `f(X)`.
2) Assuming linear `f(x)` is an approximation of reality, so there is another form of reducible error which is called *model bias*.
3) Even if we knew `f(x)`, the response cannot be predicted perfectly because of the random error `e`. This is *irreducible error*. We use **prediction intervals** to answer how much `Y` varies from `Y_hat`. Prediction intervals are wider than confidence intevals, as they take into account the reducible and irreducible error.


## 3.3 - Other Regression Model Considerations

### 3.3.1 - Qualitative Predictors

If a qualitative predcitor (factor) only has two levels, then it can be incorpoated into a model using a 0/1 encoding.

When a qualitative predictor has more than two levels, additional dummy variables can be created. If there the three factors are {A,B,C}, then `x_i1` is 1 if the ith value is A, 0 if it's not A, and `x_i2` is 1 if the ith value is B, 0 if it's not B. If `x_i{1,2}` are both 0, then the value is C.

It should be noted that while the final predictions will be the same regardless of the encoding, the p-values do depend on the choice. The F-test should be used to assess the statistical evidence as this does not depend on the dummy variable.

### 3.3.2 - Extensions of the Linear Model

#### Removing the Additive Assumption

Interaction terms can be used by adding another predictor which includes the product of two of the predictors:
```
Y = β_0 + β_1*X_1 + β_2*X_2 + β_3*X_1*X_2 + e
```

A model with no interaction terms contains only **main effects**.

The hierarchical principal states that *if we include an interaction in a model, we should also include the main effects, even if the p-values are not significant*.


### 3.3.3 - Potential Problems

#### Non-linearity of Data

The linear model assumes that there is a straight line relationship between the predictors and the response.

**Residual plots** are a graphical tool for identifying non-linearity. The residuals (`y_i` - `y_hat_i`) are plotted against the predictor `x_i`. When there are multiple predictors, the residuals are plotted against the predicted values `y_hat_i`. Ideally the residual plot will show no discernible pattern.

#### Correlation of Error Terms

An important 

