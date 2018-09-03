# Chapter 2 - Notes

## 2.1 - Statistical Learning 

**Statistical Learning** - a set of approaches for estimating a function f(X) from a set of data.

Why estimate `f`? Either for prediction or inference.

### Prediction
The set of inputs `X` are readily available, but the output `Y` cannot easily be obtained. We wish to predict what `Y` will be given a set of inputs `X`.

The accuracy of the prediction depends on two quantities - the *reducible* and the *irreducible* error. The estimate `f_hat(x)` will not be a perfect estimate for the true `f(x)`. We can reduce the error by using better statistical learning techniques.

However the variability of `e` also affects the accuracy of the predictions. This is the irreducible error.

### Inference

We are often interested in the way that `Y` is affected by changes in `X`. We need to estimate `f(x)`, but we don't want to predict `Y`. We instead want to understand the relationship betrween `X` and `Y`.
