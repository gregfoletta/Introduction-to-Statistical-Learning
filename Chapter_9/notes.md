# 9 - Support Vector Machines

The *support vector machine* is an approach for **classification** that was developed in the computer science community in the 1990s. The are often considered one of the best 'out of the box' classifiers.

It is a generalisation of a *maximal margin classifier* (MMC), which although elegant and simple, cannot be applied to most data sets as it requires the classes be separated by a linear boundary.

The *support vector classifier* extends the MMC so it can be applied in a broader range of cases.

The *support vector machine* is a further extension in order to accomodate non-linear class boundaries. SVMs are intended for binary class distinctions, however there are extensions for cases with more than two classes.

## 9.1 - Maximal Margin Classifier

### 9.1.1 - Hyperplanes

In $p$ dimensional space, a *hyperplane* is a flat affine subspace of dimension $p - 1$. In two dimensions, it's a plane of one-dimension (a line), or in three dimensions its a plane of two-dimensions (a plane).

In two dimensions, a hyperplane is defined by:

$$ \beta_0 + \beta_1X_1 + \beta_2X_2 = 0 $$

By defined we mean that any $X = (X_1, X_2)^T$ for which the equation holds is a point on the hyperplane.

This can easily be extended out to $p$ dimensional space:

$$ \beta_0 + \beta_1X_1 + \ldots +  \beta_pX_p = 0 $$

and

$$ X = (X_1, \ldots, X_p)^T $$

If $X$ doesn't satisfy the equation, it will be on either one side or another side ($X < 0$) or the other side ($X > 0$) of the hyperplane. So the hyperplane is dividing the $p$ dimensional space into two halves.

### 9.1.2 - Classification Using a Separating Hyperplane

Suppose we have an $n \times p$ matrix $\matbf{X}$. The $n$ training observations fall into one of two classes - $y_1, \ldots, y_n \in \{-1, 1\}$. We also have a test observation $x^* = (x^*_1, \ldots, x^*_p)^T$. The goal is to develop a classifier that correctly classifies the test observation bases on its features.

We have previously seen:

* Linear disciminant analysis
* Logistic regression
* Decision trees
* Bagging
* Boosting

This approach is based on the concept of a separating hyperplane.

We classify $x^*$ based on the sign of $f(x^*) = \beta_0 + \beta_1x^*_1 + \ldots + \beta_px^*_p$. If $f(x^*)$ is positive then the test is assigned to class 1, if it's negative it's assigned to class -1. 

The magnitude of $f(x^*)$ can also be used to have increased confidence about the class assignment.

### 9.1.3 - Maximal Margin Classifier

If the data can be perfectly separated by a hyperplane, there are in fact an infinite number of such hyperplanes. Thus we need a reasonable way to contruct the hyperplane.

The *maximal margin hyperplane* is the farthest away from the training observations. We compute the perdendicular distance from each training observation to the hyperplane. The maximal margin hyperplane is the separating hyperplane that has the farthest minimum distance to the hyperplane.

The classification on this is then known as a *maximal margin classifier*. Although often useful, there can be overfitting if $p$ is large.A

Consider the MMC to be the midline of a slab of space between the two classes. Then consider at least three training observations will be equidistant from this midline. These are known as *support vectors* as they are vectors in $p$-dimensional space and they "support" the MMC in the sense that if they moved, the hyperplane would move as well.

In fact the hyperplane **only** depends on these vectors - a movement of any of the other vectors would not affect the hyperplane.

### Construction of the MMC

$$ maximise M_{\beta_0, \ldots, \beta_p} $$

$$ \text{subject to } \sum_{j=1}^p\beta_j^2 = 1 $$

$$ y_i(\beta_0 + \beta_1x_{i1} + \beta_2x_{i2} + \beta_px_{ip}) \ge M  \forall  i = 1, \ldots, n $$

The final constraint guarrentees that each observation will be on the correct side of the hyperplane, provided $M$ is positive.

The final two constraints ensure that each observation is on the correct side of the hyperplane, and at least a distance $M$ from the hyperplane. Hence $M$ represents the *margin*. The first constraint then maximises $M$.

### 9.1.5 - The Non-seperable Case

The MMC is a natural way to perform classification *if a separating hyperplane exists*. In many cases it may not exist. However the concept can be extended to develop a hyperplane that *almost* separates using a *soft margin*. This is known as a *support vector classifier*.


## 9.2 - Support Vector Classifiers

### 9.2.1 - Overview

Observations belonging to two classes may not be seperable by a hyperplane, and in fact this might not be desirable as it can be sensitive to single observations.

This we might want a hyperplane that doesn't perfectly separate the two classes in the interest of:

* Greater robustness to individual observations.
* Better classification of *most* of the training observations.

The support vector classifier (or soft margin classifier) does this.

### 9.2.2 - Details

The support vector classifier classifies a test observation based on the side of the hyperplane it is on. The hyperplane is chosen to correct classify *most* of the training observations, but may misclassify some of them.

It is the solution to the optimisation problem:

$$ maximise M_{\beta_0, \ldots, \beta_p, \epsilon_0, \ldots, \epsilon_n} $$

$$ \text{subject to } \sum_{j=1}^p\beta_j^2 = 1 $$

$$ y_i(\beta_0 + \beta_1x_{i1} + \beta_2x_{i2} + \beta_px_{ip}) \ge M(1 - \epsilon_i) $$

$$ \epsilon_i \ge 0, \sum_{i=1}^n \epsilon_i \le C $$




