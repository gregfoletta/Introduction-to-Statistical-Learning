# Chapter 4 - Lab - Logistic Regression, LDA, QDA, and KNN

## 4.6.1 - Stock Market Data

We examine some numerical and graphical summaries of the `Smarket` data. We first   


```r
library(ISLR)
(smarket <- as_tibble(Smarket))
```

```
## Error in as_tibble(Smarket): could not find function "as_tibble"
```

We take a look at the pairwise correlations between the predictors in the set, removing `Direction` because it is quantative.

```r
smarket %>% select(-Direction) %>% cor() %>% tidy()
```

```
## Error in smarket %>% select(-Direction) %>% cor() %>% tidy(): could not find function "%>%"
```

The correlations are all close to zero, with the only larger correlation being between `Year` and `Volume`, as the amount of trades have increased over time:

```r
smarket %>% group_by(Year) %>% summarise(sum(Volume))
```

```
## Error in smarket %>% group_by(Year) %>% summarise(sum(Volume)): could not find function "%>%"
```

## 4.6.2 - Logistic Regression

We now use a logistic regression model in order to predict `Direction` using `Lag1 .. Lag5` and `Volume`. We use the `glm()`, or *generalised linear models* function to achieve this.


```r
smarket.glm <- glm(Direction ~ Lag1 + Lag2 + Lag3 + Lag4 + Lag5 + Volume, smarket, family = binomial)
```

```
## Error in is.data.frame(data): object 'smarket' not found
```

```r
smarket.glm %>% tidy() %>% arrange(p.value)
```

```
## Error in smarket.glm %>% tidy() %>% arrange(p.value): could not find function "%>%"
```

Looking at the p-values for the predictors, the smallest one is `Lag1` with 0.15, which is larger than our general 0.05 consideration for statistical significance. The negative correlation tells us that if the stock market went up yesterday, it's more likely to go down today.

The `predict()` function can be used to predict the probability that the stocket market will go up given the values of the predictors. The `type = response` option tells R to output probabilities of the form `P(Y = 1|X)` - the probability that Y equals 1 given X. If no data is given to `predict()`, it computes the probabilities for the training data.

Lets add these probabilities as a column `glm.pred` to the `smarket` data.


```r
(smarket <- smarket %>% add_column(glm.pred = predict(smarket.glm, type = "response")))
```

```
## Error in smarket %>% add_column(glm.pred = predict(smarket.glm, type = "response")): could not find function "%>%"
```

We add another column with the probabilities converted into class labels `Up` and `Down`.


```r
(smarket <- smarket %>% mutate(Pred = ifelse(glm.pred < .5, "Down", "Up")))
```

```
## Error in smarket %>% mutate(Pred = ifelse(glm.pred < 0.5, "Down", "Up")): could not find function "%>%"
```

We'll now create a 'confusion' matrix. In base R this is done using `table()`. but we'll use dplyr functions. We also compute the fraction of days for which the prediction was correct.

```r
smarket %>% group_by(Direction, Pred) %>% tally()
smarket %>% summarise(mean(Direction == Pred)
```

```
## Error: <text>:3:0: unexpected end of input
## 1: smarket %>% group_by(Direction, Pred) %>% tally()
## 2: smarket %>% summarise(mean(Direction == Pred)
##   ^
```
