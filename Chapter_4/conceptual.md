# Chapter 4 - Conceptual

## 1) Logistic

*Using a little bit of algebra, prove that (4.2) is equivalent to (4.3)*

The 4.2 equation is the logistic function:

$$ p(x) = \frac{e^{\beta_0 + \beta_1X}}{1 + e^{\beta_0 + \beta_1X}} $$

The 4.3 equation is the odds:

$$ \frac{p(X)}{1 - p(X)} = e^{\beta_0 + \beta_1X} $$

If we divide both sides by $1 - p(x)$, we get 

## 2) Logistic 

*It was stated in the text that classifying an observation to the class for which (4.12) is largest is equivalent to classifying an observation to the class for which (4.13) is largest. Prove that this is the case.*

The 4.12 equation is:
$$ p_k(x) = \frac{\pi_k\frac{1}{\sqrt{2\pi\sigma}}exp(-\frac{1}{2\sigma^2}(x-\mu_k)^2)} {\sum_{l=1}^K\pi_l\frac{1}{\sqrt{2\pi\sigma}}exp(-\frac{1}{2\sigma^2}(x-\mu_l)^2)} $$

## 3) QDA Model

*This problem relates to the QDA model, in which the observations within each class are drawn from a normal distribution with a class-specific mean vector and a class specific covariance matrix.*

*We consider the simple case where p = 1; i.e. there is only one feature.*

*Suppose that we have K classes, and that if an observation belongs to the kth class then X comes from a one-dimensional normal distribution, $X \sim N(\mu_k,\sigma_k^2)$. Recall that the density function for the one-dimensional normal distribution is given in (4.11). Prove that in this case, the Bayes’ classifier is not linear. Argue that it is in fact quadratic.*

The 4.11 density function is 
$$ f_k(x) = \frac{1}{\sqrt{2\pi\sigma}}exp(-\frac{1}{2\sigma^2}(x-\mu_k)^2) $$

The Bayes classifier $\delta_k(x)$ formula contains the covariance matrix $\Sigma$. 

## 5) LDA vs QDA

*We now examine the differences between LDA and QDA.*

### a)
*If the Bayes decision boundary is linear, do we expect LDA or QDA to perform better on the training set? On the test set?*

As the QDA has mor flexibility, we would expect it to perform better on thee training set. However as the decision boundary is linear, we would expect the LDA to perform better on the test set.

### b)
*If the Bayes decision boundary is non-linear, do we expect LDA or QDA to perform better on the training set? On the test set?*

We expect the QDA to perform better on both sets due to its flexibility.

### c)
*In general, as the sample size n increases, do we expect the test prediction accuracy of QDA relative to LDA to improve, decline, or be unchanged? Why?*
We would expect the relative accuracy to improve. As the sample size increases, the more flexible method will yield a better fit.

### d)
*True or False: Even if the Bayes decision boundary for a given problem is linear, we will probably achieve a superior test error rate using QDA rather than LDA because QDA is flexible enough to model a linear decision boundary. Justify your answer.*

False - we may acheive a better training rate using the QDA, however the bias of the more flexible method will mean the test error rates will increase in constrast to the LDA.

## 6) 
*Suppose we collect data for a group of students in a statistics class with variables $X_1$ = hours studied, $X_2$ = undergrad GPA, and $Y$ = receive an A. We fit a logistic regression and produce estimated coefficient, $\hat{\beta}_0 = −6, \hat{\beta}_1 = 0.05, \hat{\beta}_2 = 1$.

### a) 
*Estimate the probability that a student who studies for 40 h and has an undergrad GPA of 3.5 gets an A in the class*

We can plug the values into the logistic function to get the probability:

```r
beta_0 <- -6
beta_1 <- 0.05
beta_2 <- 1
exp(beta_0 + beta_1*40 + beta_2*3.5) / (1 + exp(beta_0 + beta_1*40 + beta_2*3.5))
```

```
## [1] 0.3775407
```

We see their probability is 37.75%

### b)
*How many hours would the student in part (a) need to study to have a 50 % chance of getting an A in the class?*

$$.5 = \frac{e^{-6 + 0.05X1 + 3.5}}{1 + e^{-6 + 0.05X1 + 3.5}}$$

Multiply both sides by the denominator on the right, then expand out:

$$.5 + .5e^{-6 + 0.05X1 + 3.5} = e^{-6 + 0.05X1 + 3.5}$$

Take .5 of the e^a term away from both sides, then divide by .5

$$1 = e^{-6 + 0.05X1 + 3.5}$$

Take the log of both sides:

$$0 = 0.05X1 - 2.5$$

Solve for X

$$X1 = 50$$

## 7)

*Suppose that we wish to predict whether a given stock will issue a dividend this year (“Yes” or “No”) based on X, last year’s percent profit. We examine a large number of companies and discover that the mean value of X for companies that issued a dividend was X̄ = 10, while the mean for those that didn’t was X̄ = 0. In addition, the variance of X for these two sets of companies was σ̂ 2 = 36. Finally, 80 % of companies issued dividends. Assuming that X follows a normal distribution, predict the probability that a company will issue a dividend this year given that its percentage profit was X = 4 last year.*

We're going to use Pr(Dividend = k|X = x) = $\frac{\pi_kf_k(x)}{\Sigma_{l=1}^K\pi_lf_l(x)}$ where

* $f_k(x)$ is the normal density function with the variance and means stated above.
* The prior $\pi_k$ is .8 / .2 for Dividend = Yes / No.


```r
library(tidyverse)
```


```r
(.8 * dnorm(4, 10, 6)) / sum(c(.2,.8) * c(dnorm(4,0,6), dnorm(4,10,6)))
```

```
## [1] 0.7518525
```

## 8)
Suppose that we take a data set, divide it into equally-sized training and test sets, and then try out two different classification procedures. First we use logistic regression and get an error rate of 20 % on the training data and 30 % on the test data. Next we use 1-nearest neighbors (i.e. K = 1) and get an average error rate (averaged over both test and training data sets) of 18 %. Based on these results, which method should we prefer to use for classification of new observations? Why?*

Logistic regression (and LDA) both produce linear decision boundaries. The KNN is a non-parametric approach. With K = 1, KNN is highly flexible, and the training error rate would be 0. Thus the test error rate is actually 36%. Therefore the LDA is the better choice.

## 9) Odds

### a)
*On average, what fraction of people with an odds of 0.37 of defaulting on their credit card payment will in fact default?*

Using the odds formula we get $\frac{p(x)}{1 - p(x)} = 0.37$. If we multiply both sides by the denominator, then take add p(x) from the right hand side, we get $1.37p(x) = .37$. Therefore $p(x)$ is 0.27 or 27%.

### b)
*Suppose that an individual has a 16 % chance of defaulting on her credit card payment. What are the odds that she will default?*

Plugging in to the odds formula, we get .16 / (1 - .16) = .19.







