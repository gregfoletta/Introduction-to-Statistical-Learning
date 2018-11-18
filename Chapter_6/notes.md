# Chapter 6 - Linear Model Selection and Regularization

This chapter, and the chapters that follow, extend the linear model framework. We discuss how the linear model can be improved by replacing the least squares with alternative fitting provedures.

Alternative fitting procedures can yield better:
    * Prediction Accuracy - if *n* is not much larger than *p*, there can be a lot of variability in the least squares fit, resulting in overfitting. If *p* > *n* then there is no longer a unique least squares coefficient estimate. By *constraining* or *shrinking* the estimated coefficients we can reduce the variance at the cost of a negligible increase in bias.
    * Model interpretability - it is often the case that many of the variables are not associated with the response. Least squares is extremely unlikely to to yield any coefficient estimates that are exactly zero. In this chapter we see methods for *feature selection* or *variable selection*.

This chapter discusses three classes of methods:

* Subset selection - identifying a set of *p* predictors we beleive are related to the response.
* Shrinkage - fitting a model using all *p* predictors, however the estimated coefficients are shrunken towards zero. Also known as *regularisation*.
* Dimension reduction - involves projecting the *p* predictors into an *M-dimensional* space where M < p. This is acheived by computing M different *linear combinations* or *projections*.

## 6.1 - Subset Selection

This section discusses methods for selecting subsets of predictors.

### 6.1.1 - Best Subset Selection

To perform best subset select we fit a separate least squares regression for each posisble combination of *p* predictors. We then look at the model that is 'best'.

The selection of the 'best' model is non-trivial, and usually broken into stages:

* Let $M_0$ denote the *null model*, which contains no predictors. This predicts the sample mean for each observation.
* For $k = 1, 2, ..., p$.
    * Fit all ${p}\choose{k}$ models that contain exactly $k$ predictors
    * Pick the best amongst the ${p}\choose{k}$ models and call it $M_K$. Best is defines as the smallest RSS, or the largest $R^2$.
* Select the single best model from $M_0,...,M_p$ using cross-validated prediction error $C_p$ (AIC), BIC, or adjusted $R^2$. 

With $M_0,...,M_p$, the RSS will decrease as more predictors are added, so we would always end up choosing the model with all of the variables. Hence a cross-validated error, BIC or adjusted $R^2$ is used in order to select the model.

The same ideas apply to other models such as logistic. With a logistic regression we use *deviance* which plays the role of RSS for a broader class of models.

Best subset is simple however it suffers from comutational limitations. In general there are $2^P$ models that involve subsets of $p$ predictors - let's see this computationally.


```r
library(broom)
library(tidyverse)
library(ISLR)
```


```r
tibble(x = 1:30) %>% 
    mutate(binom_coef = choose(max(x), x)) %>% 
    summarise(sum = sum(binom_coef))
```

```
## # A tibble: 1 x 1
##          sum
##        <dbl>
## 1 1073741823
```

```r
2^30
```

```
## [1] 1073741824
```

Thus 'Best Subset Selection' becomes computationally infeasible for larger values of *p*.

### 6.1.2 - Stepwise Selection

The main issues with best subset are computational, and statistical: whem *p* is large, there's a higher chance of finding models that look good on the training data. *Stepwise* methods are attractive alternatives to best subset.

#### Forward Stepwise Selection

Forward stepwise begins with a model with no predictors, the adds predictors one at a time, until all the predictors are in the model.

* Let $M_0$ denote the *null model*, which contains no predictors. This predicts the sample mean for each observation.
* For $k = 0, 1, ..., p - 1$.
    * Consider all the $p - k$ models that augment the predictors in $M_K$ with one additional predictor.
    * Choose the best amongst these $p - k$ models and call it $M_{k+1}$. Here best is lowest RSS or highest $R^2$.
* Select a single best model from among $M_0,...,M_p$ using cross validated prediction error, $C_p$ (AIC) or adjusted $R^2$.

This results in the fitting of $1 + p(p + 1)/2$ models.

Can be used with $n < p$, however can only generate up to $M_{n_1}$ models.

#### Backward Stepwise Selection

Begins with all predictors, then iteratively removes the least useful predictor.

* Let $M_p$ denote the *full model*, with all predictors.
* For $k = p,p - 1,...,0$.
    * Consider all $k$ models that contain all but one of the predictors in $M_k$.
    * Choose the best amongst these $k$ models.
* Select a single best model among $M_0,...,M_p$.

Requires that $n > p$.

### 6.1.3 - Choosing the Optimal Model

The training error can be a poor estimate of the test error, therefore RSS and $R^2$ are not suitable for selecting the best model. There are two approaches:

1) Indirectly estimate the test error by making an *adjustment* to the training error.
2) We can directly estimate the test error using the validation set or cross-validation approach.

#### Cp

For a fitted least squares model containing $d$ predictors, the $C_p$ estimate of test MSE is computed using the equation:
$$ C_p = \frac{1}{n}(RSS + 2d\hat{\sigma}^2) $$

where \hat{\sigma}^2 is an estimate of the variance of the error $\epsilon$ associated with each response measurement.

Essentially it adds a penalty of $2d\hat{\sigma}^2$ to the training RSS in order to adjust for the fact the training error tends to underestimate the test error.

#### AIC

The Akaike Information Criterion is defined for a large class of models fit by maximum likelihood. In the case of a linear model with Gaussian errors, maximum likelihood and least squares are the same thing. In this case AIC is given by
$$ AIC = \frac{1}{n\hat{\sigma}^2}(RSS + 2d\hat{\sigma}^2) $$

hence for least squares models, $C_p$ and AIC are proportional to each other.

#### BIC

The Bayesian Information Criterion is derived from a Bayesian point of view. For the least squares with *d* predictors the BIC is:
$$ BIC = \frac{1}{n}(RSS + log(n)d\hat{\sigma}^2) $$

#### Adjusted R^2

The usual $R^2$ is defined as $1 - RSS/TSS$, where $TSS = \sum(y_i - \bar{y})^2$. For a least squares model with $d$ variables, the adjusted $R^2$ is:
$$ Adjusted R^2 = 1 - \frac{RSS / (n - d - 1)   }{TSS / (n - 1)} $$

The intuition is that once all of the correct variables have been included in the model, adding additional *noise* variables will lead to only a small decrease in RSS. Therefore, in theory, the model with the largest adjusted $R^2$ will have only correct variables and no noise variables.

#### Validation and Cross Validation

As an alternative to indirect estimates, we can directly estimate the test error by using validation or cross-validation methods.

## 6.2 - Shrinkage Methods

The previous section discussed selecting a subset of the predictors. As an alternative we can fit a model with all *p* predictors using a technique that constrains or regularises the coefficient estimates, or equivalently shrinks the coefficient estimates towards zero. Shrinking the coefficient estimates can significantly reduce their variance.

The two best-known techniques are *ridge regression* and the *lasso*.

### 6.2.1 - Ridge Regression

Least squares estimates $\beta_0,\ldots,\beta_p$ using values that minimise:
$$ RSS = \sum_{i=1}^n\bigg(y_i - \beta_0 - \sum_{j=1}^p\beta_jx_{ij}\bigg)^2 $$

Ridge regression is similar except that there is an additionaln term:
$$ RSS^R = RSS + \lambda\sum_{j=1}^p\beta_j^2 $$

where $\lambda$ is a tuning parameter to be determined seperately. This $\lambda$ is called the *shrinkage penalty*. When $\lambda = 0$, it has no effect and the result is a least squares estimate. As $\lambda\to\infty$, the shrinkage pentaly grows and the coefficient estimates will approach 0. We receive a different set of estimates for each $\lambda$, so we need to choose the 'best' $\lambda$.

Standard least squares coefficients are *scale invariant* - multiplying $X_j$ predictor by a constant $c$ simply leads to a scaling of the least squares coefficient estimates:


```r
auto <- as.tibble(Auto)
auto %>% lm(horsepower~mpg, data = .) %>% tidy() %>% dplyr::filter(term == "mpg")
```

```
## # A tibble: 1 x 5
##   term  estimate std.error statistic  p.value
##   <chr>    <dbl>     <dbl>     <dbl>    <dbl>
## 1 mpg      -3.84     0.157     -24.5 7.03e-81
```

```r
auto %>% mutate(mpg = mpg * 1000) %>% lm(horsepower~mpg, data = .) %>% tidy() %>% dplyr::filter(term == "mpg")
```

```
## # A tibble: 1 x 5
##   term  estimate std.error statistic  p.value
##   <chr>    <dbl>     <dbl>     <dbl>    <dbl>
## 1 mpg   -0.00384  0.000157     -24.5 7.03e-81
```

However with the ridge regression the coefficient estimates can change substantiall when multiplying the given predictor by a constant. Therefore it's best to standardise the predictors before applying the ridge regression with the formula:
$$ \tilde{x}_{ij} = \frac{x_{ij}}{\sqrt{\frac{1}{n}\sum_{i=1}^n(x_{ij} - \bar{x}_j)^2}} $$

The denominator is the estimated standard deviation of the predictor, so all the predictors will have a standard deviation of 1.

#### Least Squares (OLS) vs Ridge Regression (RR)

RR's advantage over least squares is rooted in the *bias-variance* trade-off. As $\lambda$ increases, the flexibility of the RR fit decreases, leading to decreased variance but increased bias. At $\lambda = 0$ the variance is high but there is no bias. As $\lambda$ increases, the shrinkage of the RR estimates leads to a reduction in the variance at the expense of an increase in the bias.

In general in situations where the relationships between the predictors and the response is close to linear, the OLS will have low bias but high variance. A small change in the training data may cause a large change in the coefficient estimates. In particular when $p$ is almost as large as $n$ OLS will be extremely variable. RR works best in situations where the OLS estimates have a high varince.

### 6.2.2 - The Lasso

Ridge regression has one disadvantage: it will will include all $p$ in the final model. It will shrink the coefficients to zero, but won't set them to zero. This isn't an issue with prediction, but can does pose issues for model interpretation, especially when $p$ is large.

The lassoo coefficients $\hat\beta_\lambda^L$ minimise the quantity:
$$ RSS + \lambda\sum_{j=1}^p\abs{\beta_j} $$

The lasso and the ridge regression have similar formulations. The lasoo uses an $\ell_1$ penalty instead of an $\ell_2$. The $\ell_1$ norm of a coefficient vector $\beta$ is given by $\norm{\beta}_1 = \sum\abs{\beta_j}$.

The lasso shrinks the coefficient estimates towards zero, however the $\ell_1$ penality forces some of the coefficients to be zero when $\lambda$ is sufficiently large. Hence it performs variable selection.

#### Comparing the Lasso and Ridge Regression

In general the lasso performs better in a setting where a relatively small number of predictors have substantial coefficients. Ridge regression performs better when the response is a function of many predictors, all with coefficients of equal size. A procedure such as cross-validation can be used to determine which approach is better for a particular data set.

### 6.2.3 - Selecting the Tuning Parameter

Cross validation provides a simple way to tackle this problem. We choose a grid of $\lamba$ values and compute the cross-validation error for each one. We then select the tuning parameter for which the error is smallest. The model is then re-fit using all of the available observations and the selected value of the tuning parameter.

## 6.3 - Dimension Reduction

We now explore a class of approaches that *transform* the predictors and then fit a least squares model using the transformed variables.

Let $Z_1,\ldots,Z_M$ represent $Z < p$ linear combinations of our original predictors, i.e.
$$ Z_m = \sum_{j=1}^p\phi_{jm}X_j $$
for some constants $\phy_{1m},\ldots,\phi_{pm}$. We can then fit the linear regression model:
$$ y_i = \theta_0 + \sum_{m=1}^M\theta_mz_{im} + \epsilon_i, i = 1,\ldots,n $$

If the constants are chosen wisely then such dimension reduction can ofter outperform least squares regression.

This is termed *dimension reduction* because it reduces the problem of estimating the $p + 1$ coefficients $\beta_0,\ldots,\beta_p$ to the simpler problem of estimating $M + 1$ coefficients $\theta_0,\dots,\theta_M$, where $M < p$.

Dimension reduction serves to constrain and therefore bias the coefficient estimates. However in situations where $p$ is large relative to $n$, selecting a value of $M \ll p$ can significantly reduce the variance of the fitted coefficients.

All dimension reduction consists of obtained the transformed predictors, then a model is fit to those predictors. The choice of the transformed predictors can be achieved in different ways; we will consider *principal components* and *partial least squares*.
