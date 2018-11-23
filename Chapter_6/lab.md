# Chapter 6 - Lab


```r
library(ISLR)
library(leaps)
library(tidyverse)
```

## 6.5.1 - Best Subset Selection

We wish to predict a baseball player's salary on the bassis of various statistics associated with the performance in the previous year. Let's remove the players for which the salary is missing from the dataset.


```r
hitters <- hitters %>% dplyr::filter(!is.na(Salary))
```

```
## Error in eval(lhs, parent, parent): object 'hitters' not found
```


