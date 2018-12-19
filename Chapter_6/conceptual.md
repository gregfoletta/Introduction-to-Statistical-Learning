# Conceptual

## 1)
*We perform best subset, forward stepwise, and backward stepwise selection on a single data set. For each approach, we obtain $p + 1$ models, containing $0, 1, 2,\ldots,p$ predictors. Explain your answers:*

### a)
*Which of the three models with k predictors has the smallest training RSS?*

As the best-subset fits every combination of predictors, it will have the smallest training RSS.

### b)
*Which of the three models with k predictors has the smallest test RSS?*

Best subset may have the smallest test RSS because it considers more models. However it also may be overfitting the training data, and one of the other models may find a better model for the test data.

### c)
*True or False:*

#### i)
*The predictors in the $k$-variable model identified by forward stepwise are a subset of the predictors in the $(k+1)$ variable model identified by forward stepwise selection.*

In each step, forward stepwise augments with one additional predictor, hence the statement is **true**.

#### ii)
*The predictors in the k-variable model identified by backward stepwise are a subset of the predictors in the (k + 1) variable model identified by backward stepwise selection.*

In each step the backward stepwise the least useful predictor is removed, hence the answer is **true**.

#### iii)
*The predictors in the k-variable model identified by backward stepwise are a subset of the predictors in the (k + 1) variable model identified by forward stepwise selection.*

Forward and backward stepwise are independent functions, thus the above statement is **false**.

#### iv)
*The predictors in the k-variable model identified by forward stepwise are a subset of the predictors in the (k +1)-variable model identified by backward stepwise selection.*

**False**.

#### v)
*The predictors in the k-variable model identified by best subset are a subset of the predictors in the (k + 1)-variable model identified by best subset selection.*

Best subset chooses the best model for each $k$, therefore the above statement is **false**.

## 2)
*For parts (a) through (c), indicate which of i. through iv. is correct. Justify your answer.*

### a)
*The lasso, relative to least squares, is:*

Less flexible and hence will give improved prediction accuracy when its increase in bias is less than its decrease in variance.

The lasso reduces the flexibility, decreasing the variance and increasing the bias.

### b)
*The ridge regression, relative to least squares, is:*

Less flexible and hence will give improved prediction accuracy when its increase in bias is less than its decrease in variance.

Same as a)

### c)
*Non-linear methods, relative to least squares, are:*

More flexible, and will give improves accuracy when its increase in variance is less than it's decrease in bias.

## 3)
*Suppose we estimate the regression coefficients in a linear regression model by minimizing:




