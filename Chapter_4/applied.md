# Chapter 4 - Applied


```
## Error: <text>:1:8: unexpected '{'
## 1: library{
##            ^
```

## 10) 'Weekly' Data Set

### a)
*Produce some numerical and graphical summaries of the Weekly data. Do there appear to be any patterns?*


```r
weekly <- as_tibble(Weekly)
```

```
## Error in as_tibble(Weekly): could not find function "as_tibble"
```

```r
weekly %>% ggplot() + geom_bar(aes(Direction))
```

```
## Error in weekly %>% ggplot(): could not find function "%>%"
```


### b)
*Use the full data set to perform a logistic regression with Direction as the response and the five lag variables plus Volume as predictors. Use the summary function to print the results. Do any of the predictors appear to be statistically significant? If so, which ones?*


```r
glm_weekly <- weekly %>% 
    select(-Year, -Today, -Volume) %>% 
    glm(Direction ~ ., ., family = binomial)
```

```
## Error in weekly %>% select(-Year, -Today, -Volume) %>% glm(Direction ~ : could not find function "%>%"
```

```r
glm_weekly %>% tidy()
```

```
## Error in glm_weekly %>% tidy(): could not find function "%>%"
```

The Lag2 variable is the only variable with a statistically significant p-value (0.025).

### c)
*Compute the confusion matrix and overall fraction of correct predictions. Explain what the confusion matrix is telling you about the types of mistakes made by logistic regression.*


```r
weekly %>% 
    mutate(Prediction = ifelse(predict(glm_weekly, type = 'response') < .5, 'Down', 'Up')) %>% 
    group_by(Direction, Prediction) %>% 
    tally() 
```

```
## Error in weekly %>% mutate(Prediction = ifelse(predict(glm_weekly, type = "response") < : could not find function "%>%"
```

We can see that the logistic regression does well to predict when the market goes up, but not when the market goes down.

### d)
*Now fit the logistic regression model using a training data period from 1990 to 2008, with Lag2 as the only predictor. Compute the confusion matrix and the overall fraction of correct predictions for the held out data (that is, the data from 2009 and 2010).*


```r
glm_weekly_90_08 <- weekly %>% 
    dplyr::filter(Year >= 1990 && Year <= 2008) %>% 
    select(Direction, Lag2) %>% 
    glm(Direction~Lag2,., family = 'binomial')
```

```
## Error in weekly %>% dplyr::filter(Year >= 1990 && Year <= 2008) %>% select(Direction, : could not find function "%>%"
```

```r
weekly %>% 
    dplyr::filter(Year > 2008) %>% 
    mutate(Prediction = ifelse(predict(glm_weekly_90_08, ., type = 'response') < .5, "Down", "Up")) %>% 
    group_by(Direction, Prediction) %>% 
    tally()
```

```
## Error in weekly %>% dplyr::filter(Year > 2008) %>% mutate(Prediction = ifelse(predict(glm_weekly_90_08, : could not find function "%>%"
```


