# 8 - Tree-Based Methods

This chapter discusses tree-based methods for regression and classification. These involve **stratifying** or **segmenting** the predictor space into a number of simple regions. These types of approaches are known as **decision tree* methods**.

Tree based methods are good for interpretation, but are not competitative against the supervised learning methods in chapters 6 and 7 in terms of prediction accuracy. Hence this chapter also discusses **bagging**, **boosting**, and **random forrests**.

## 8.1 - The Basics

Decision trees can be applied to both regression and classification problems.

### 8.1.1 - Regression Trees

Consider the `Hitters` data set used to predict a player' salary based on the `Years` they've been playing, and the number of `Hits` made in the previous year.

The regression tree generates a series of splits in the data. The first split creates the left branch, and is at `Years < 4.5`. The predicted salary for these players is given by the mean response value for players in the data set with `Years < 4.5`.

Players with `Years >= 4.5` are placed in the right branch, and then subdivided by `Hits`. Overall the tree stratifies or segments players into three regions of predictor space:

$$ 

R_1 = { X | Years < 4.5 }
R_2 = { X | Years >=4.5, Hits < 117.5 }
R_3 = { X | Years >=4.5, Hits >= 117.5 }

$$

The regions of the tree are known as *terminal nodes* or *leaves* of a tree.

#### Prediction via Stratification of the Feature Space

Roughly there are two steps in building the regression tree:

* Divide the predictor space (the set of possible values for $X_1, X_2, \ldots, X_p$) into $J$ distinct and non-overlapping regions $R_1, R_2, \ldots, R_J$.
* For every observation that falls into region $R_J$, we make the same predictions, which is simply the mean of the response values for the training observations in $R_J$.

How do we construct the regions? They could have any shape, however we choose to divide the space into high-dimensional rectangles, or *boxes*. This is for both simplicity and for ease of interpretation.

The goal is to find regions that minimise the RSS given by:

$$ \sum_{j=1}^J \sum_{i \in R_j}(y_i - \hat{y}_R_j)^2 $$

where $ \hat{y}_R_j $ is the mean response for the training observations within the $j$th box.

It is computationally infeasible to consider every possibly partition, so a top-down greedy approach known as *recsursive binary splitting* is used. It begins at the top of the tree (all observations in a single region) and successively splits the predictor space.

In order to perform recursive binary splitting, we select predictor $X_j$ and the cutpoint $s$ such that splitting the preditor space into the regions ${X|X_j < s}$ and ${X|X_j \ge s}$ leads to the greatest possible reduction in RSS. The notation means *the region of predictor space in which X_j takes on a value less than s*.

The process is repeated, however instead of splitting the entire predictor space, we split one of the two previously identified regions.

Once the regions $R_1, \ldots, R_J$ have been created. we predict the response for a given test observation using the mean of the training observations in the region to whichthat test observation belongs.

#### Tree Pruning

The process described above is likely to overfit the data, leading to poor test set experience. A smaller tree may have lower variance and better interpretation at the cost of a little bias.

A strategy is to grow a very large tree $T_0$ and then prune it back in order to obtain a *subtree*. How do we determine the best way to prune the tree? Our goal is to select a subtree that leads to the lowest test error rate. 

Given a subtree, we can estimate its test error using cross-validation or the validation set approach. Estimating the CV error for every possible sub-tree would be too cumbersome.

*Cost complexity pruning* - also known as *weakest link pruning* - gives us a way to do just this. We consider a sequence of trees indexed by non-negative $\alpha$:

1. Use recsursive binary splitting to grow a large tree on the training data.
2. Apply cost complexity pruning to the large tree in order to obtain a sequence of best subtrees, as a function of $\alpha$.
3. Use k-fold CV to choose $\alpha$:
    a. Repeat steps 1 and 2 on all but the kth fold of the training data.
    b. Evaluate the MSE on the data in the left-out kth fold, as a function of $\alpha$. Average the results for each value of $\alpha$, and pick $\alpha$ to minimise the average error.
4. Returnt he subtree from step 2 that corresponds to the chosen value of $\alpha$.

For each value of $\alpha$ there corresponds a subtree $T \in T_0$ such that
$$ \sum_{m=1}^{\abs{T}}\sum_{i: x_i \in R_m} (y_i - \hat{y}_{R_m})^2 + \alpha\abs{T}$$

is as small as possible. Here $\abs{T}$ indicates the numner of terminal nodes of the tree $T$, $R_m$ is the rectangle corresponding to the $m$th terminal node, and $\hat{y}_{R_m}$ is the predicted response assoociated with $R_m$ - that is, the mean training observations in $R_m$.

The tuning parameter $\alpha$ controls a tradeoff between the subtrees complexity and its fit to the training data. When its 0, the subtree $T$ will simply equal $T_0$ because it just measures the training error.

As $\alpha$ increases, there is a price to pay for having a tree with many terminal nodes, and so the quantity will tend to be minimised for a smaller subtree.

It turns out that as $\alpha$ in increased, the branches get pruned in a nested and predictable fashion, so obtaining the whole sequence of subtrees is easy. We can select a value of $\alpha$ using a validation set or using cross validation.

### Classification Trees

A classification tree is similar to a regression tree, except its predicting a qualitative response rather than a quantitative response. Instead of using the mean as in the quantitative response, we predict that the observation belongs to the *most commonly occurring class* of training observations. 

We are often interested not only in the class prediction, but also the *class proportions* among the training ovbservations.

The process is similaer to a regression tree: we use recursive binary splitting to grow a classification tree. However RSS cannot be used as a criterion. The *classification error rate* is a natural alternative. 

Since we plan to assign an observation to the *most occurring class* of training observations in tat region, the classification error rate is simply the fraction of the training observations in that region that do not belong to the most common class.

$$ E = 1 - max_k(\hat{p}_{mk}) $$

Here $p_{mk}$ represents the proportion of training observations in the $n$th region that are from the $k$th class. It turns out that the classification error is not sufficiently sensitive for tree-growing.

The *Gini index* is defined by:

$$ G = \sum_{k=1}^K \hat{p}_{mk}(1 - \hat{p}_{mk)) $$

It's a measure of the total variance across the $K$ classes. It takes on a small value if all of the $\hat{p}_{mk}$'s are close to zero or one. It is referred to as a measure of node *purity* - a small value indicates the a node contains observations from a sinlge class.

An alternative is *cross-entropy*:

$$ D = -\sum_{k=1}^K\hat{p_{mk}}log(\hat{p}_{mk}) $$

Since $0 \le \hat{p}_{mk} \le 1$, it follows that $0 \le -\hat{p}_{mk}log(\hat{p}_{mk})$

One can show hat the cross-entropy will ake on a value near zero of the $\hat{p}_{mk}$'s are all near zero or near one. Therefore, like the *Gini index*, the cross-entropy will take on a small value of the $m$th node is pure.

These two values are typically used to evaluate the quality of a split as they are more sensitive to node purity than the classification error rate.

### 8.1.3 - Tree Versus Linear Models

Regression and classification trees have a very different flavour from the more classical approaches. Suitability depends on the problem at hand. If the relationship between the responses is well approximated by a linear model, then a linear regression approach will likely wokr well.

If the relationship between the features and the response is complex or non-linear, the decision trees may outperform classical approaches. A tree may also be preferable due to its interpretability and visualisation.

### 8.1.4 - Advantages and Disadvantages of Trees

*Advantages*

1. Easy to explain to people.
2. Some belief that decision trees more closely mirror human decision making.
3. Trees can be displayed graphically.
4. Can handle qualitative predictors without the need to create dummy variables.

*Disadvantages*

1. Do not generally have the same predictive accuracy as some other regression and classification approaches.
 a. By aggregating many decision trees using methods like *bagging*, *random forrests* and *boosting*, predictive performance can be substantially improved.

## 8.2 - Bagging, Random Forests, Boosting.

These techniques use trees as building blocks to construct more powerful prediction models.

### 8.1.3 - Bagging

Decision trees suffer from *high variance* - if we split the training data at random and fit a tree to both halves, the results can be quite different.

*Bootstrap aggregation* or *bagging* is a general purpose procedure for reducing the variance of a statistical learning method.

Given $n$ independent observations $Z_1, \ldots, Z_n$, each with variance $\sigma^2$, the variance of the mean $\mean{Z}$ of the observations is given by $\frac{\sigma^2}{n}$. I.e averaging a set of observations reduces variance.

Thus a way to reduce the variance of a statistical learning method is to take many training sets from the population, build a separate prediction model for each, then take thaverage of the resulting predictions.

We can take $\hat{f^1}(x), \ldots, \hat{f^B}(x)$ using $B$ separate training sets, then average them to obtain a single low variance statistical model:

$$ \hat{f_{avg}}(x) = \frac{1}{B}\sum_{b=1}^B\hat{f^b}(x) $$

We don't generally have mulitple training sets, so we can bootstrap by taking repeating samples from a single training set.

To apply bagging to regression trees, we construct $B$ regression trees from the $B$ bootstrapped training sets and average the resulting predictions.

To apply in a qualitative context, for a given observations we record the class predicted by each of the $B$ trees and take a *majority vote*. The overall prediction is the most commonly occurring class among the $B$ prediction. 

#### Out-of-Bag Error Estimation

On average each bagged tree makes use of around two-thirds of the observations (see [exercise 2, chapter 5](../Chapter_5/conceptual.md). The remaining one-third not used are referred to as the *out-of-bag* (OOB) obversations. The response can be predicted by using each of the trees for which that observation was OOB. This yields around $B/3$ predictions for the $i$th observations. These are then averaged or take a majority vote.

#### Variable Importance Measures

Bagging improves the accuracy, but it can be difficult to interpret the model. A summary of the importance of each predictor can be obtained which can help. This is RSS for bagging regression trees, or the Gini index for bagging classification trees.

### 8.2.2 - Random Forests

*Random forests* provide and improvement over bagged trees by way of a small tweak that *decorrelates* the trees. As with bagging, a number of decision trees are built on bootstrapped data. However each time a split in a tree is considered a *random sample of $m$ predictors* is chosed as split candidates from the full set of $p$ predictors.

A fresh sample is taken at each split, and typically $m = \sqrt{p}$.

Consider a data set with a strong predictor. Most of the bagged trees will look the same, having this predictor as the first split. However averaging all of these correlated quantities does not lead to as large a reduction in variance. Random forests overcome this be decorrelating the trees, reducing the variance.

### 8.2.3 - Boosting

*Boosting* is another approach to improve the predictions from a decision tree, although like bagging it can be applied to mant statistical learning methods.

Boosting works similar to bagging, except that the trees are grown using information from previously grown trees. There is no bootstrap of the data; instead each tree is fit on a modified version of the original data set:

1. Set $\hat{f}(x) = 0$ and $r_i = y_i$ for all $i$ in the training set.
2. For $b = 1, 2, \ldots, B$, repeat:
    a. Fit a tree $\hat{f^b}$ with $d$ splits to the training data $(X,r)$.
    b. Update $\hat{f}$ by adding in a shrunken version of the new tree:
    $$ \hat{f}(X) \leftarrow \hat{f}(x) + \lambda\hat{f^b}(x) $$
    c. Update the residuals
    $$ r_r \leftarrow r_i - \lambda\hat{f^b}(x_i) $$
3. Output the boosted model

$$ \hat{f}(x) = \sum_{b=1}^B\lambda\hat{f^b}(x) $$

Like bagging, we're combining a large number of decision trees. The boosting approach *learns slowly*. Given the current model, we fit a decision tree to the residuals from the model, rather than the outcome Y. We add this new decision tree into the fitted function in order to update the residuals.

Each of these trees can be small, with just a few terminal nodes. By fitting small trees to the residuals, we slowly improve $\hat{f}$ in areas where it does not perform well. The shrinkage parameter $\lambda$ slows the process down even further.

Boosting has three tuning parameters:

1. $B$ - the number of trees. Overfitting can occur if $B$ is too large. Use cross-validation to select $B$.
2. $\lambda$ - the shrinkage paramter. A small positive number. Tyical values are 0.01 or 0.001. Right choice depends on the problem. Very small $\lambda$ can require a large $B$ in order to achieve good performance.
3. $d$ - the number of splits in each tree. Often $d = 1$ works well.

