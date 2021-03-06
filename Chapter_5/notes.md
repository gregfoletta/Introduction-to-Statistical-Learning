# Chapter 4 - Resampling Methods

Resampling involves repeatedly drawing samples from a training set and refitting a model of interest on each sample.

## 5.1 - Cross-validation

We consider a class of methods that estimate the test error rate by *holding out* a subset of the training observations from the fitting process. The statistical learning method is then applied to these held out observations.

### 5.1.1 - Validation Set

It involves randomly dividing the available set of observations into two parts: the *training set* and the *validation set*. The validation set error rate provides an estimate of the test error rate.

**Drawbacks**
* The validation estimate of the test error rate can be highly variable, depending on which observations are included in the training set.
* Only a subset of the observations are used to fit the model. Since statistical methods perform worse with fewer observations, the validation set error rate may overestimate the test error rate.

### 5.1.2 - Leave-One-Out Cross Validation (LOOCV)

Closesly related to the validation set, but attempts to address it's drawbacks. Instead of two subsets of the same size, a single observation is used for the validation set. Everything else is part of the training set. The statistical learning method is fit on the n - 1 training observations, and a prediction is made for the excluded observation.

The MSE for the single observation is unbiased but highly variable. The approach is repeated n times to give n MSEs. The LOOCV estimate for the test MSE is the average of these n test error estimates.

**Advantages**:
* Far less bias than the validation set approach.
* Always yields the same result.

The downside is that the model needs to be fit n times, however for least squares linear or polynomial regression, the following formula holds:

$$ CV_{(n)} = \frac{1}{n}\sum_{i=1}^n\Bigg(\frac{y_i - \hat{y}_i}{1 - h_i}\Bigg)^2 $$

Where $\hat{y}_i$ is the ith fitted value, and $h_i$ is the leverage. This does not hold in general.

### 5.1.3 - k-Fold Cross Validation

An alternative to LOOCV is k-fold. This involves randomly dividing the set of observations into k groups - or folds - of approximately equal size. The first fold is treated as a validation set, and the method is fit on the remaining k - 1 folds. The MSE is computed on the observations in the held out fold. The k-fold estimate is then computed by averaging the k MSEs:

$$ CV_{(k)} = \frac{1}{k}\sum_{i=1}^kMSE_i $$

LOOCV is therefore a special case of k-fold where k = n.

*Advantages:*
* Computational - fit the model only k times, not n.

#### Bias-Variance Trade-off

Another advantage of the k-fold is that it often gives more accurate estimates due to the bias-variance trade-off. The LOOCV gives almost unbiased estimates of he test error, since each training set contains n-1 observations - almost the full data set. For increasing k there is an increase in the bias, since each training set contains (k-1)n/k observations. From a bias reductions perspecive LOOCV is preferable to k-fold.

However from a variance perspective, the LOOCV is the mean of the n fitted models, each of which nearly have the same observations. The outputs are highly correlated with each other. Since the mean of many highly correlated quantities has higher variance, the LOOCV has a higher variane.

### 5.1.5 - Cross-validation on Classification Problems

In this setting, cross-validation works just as described except that rather than using MSE to quantify test error, we instead use the number of misclassifed observations.

$$ CV_{(n)} = \frac{1}{n}\sum_{i=1}^nErr_i$$

where $Err_i = I(y_i \neq \hat{y}_i)$

# 5.2 - The Bootstrap

The bootstrap can be used to quantify the uncertainty associated with a given estimator or statistical learning method. Rather than obtaining new data sets from the population, we obtain distinct data sets by repeatedly sampling observations from the original data set.

The procedure is:
* Randomly select n observations from the data set $Z$ **with replacement** - i.e. the same observation can be taken more than once. This gives us $Z^{*1}$.
* This data set is used to produce a new estimate $\hat{\alpha}$.
* This is repeated $B$ times for a large value of $B$ in order to produce $Z^{*1},\ldots,Z^{*B}$ data sets and corresponding estimates.
* The standard error of the estimates is then computed using:
  $$ SE^B(\hat{\alpha}) = \sqrt{\frac{1}{B - 1}\sum_{r=1}^B}\Bigg(\hat{\alpha}^{*r} - \frac{1}{B}\sum_{r'=1}^B\hat{\alpha}^{*r'}\Bigg)^2 $$

This services as an estimate of the standard error of $\hat{\alpha}$ from the original data set.
