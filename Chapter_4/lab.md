# Chapter 4 - Lab - Logistic Regression, LDA, QDA, and KNN

## 4.6.1 - Stock Market Data

We examine some numerical and graphical summaries of the `Smarket` data. We first   


```r
library(ISLR)
(smarket <- as_tibble(Smarket)
```

```
## Error: <text>:3:0: unexpected end of input
## 1: library(ISLR)
## 2: (smarket <- as_tibble(Smarket)
##   ^
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

Looking at the p-values for the predictors 
