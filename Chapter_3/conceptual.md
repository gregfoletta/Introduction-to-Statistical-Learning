# Chapter 3 - Conceptual

## 1) Null Hypothesis

*Describe the null hypothesis to which the p-values given in table 3.4 correspond. Explain the conclusions you can draw based on these values. Explaination should be phrased in terms of `sales`, `TV`, `radio`, and `newspaper`.*

The p-value is a value between 0 and 1 that gives a probability that the null hypothesis is true. 

The null hypothesis for the next three rows of is "The advertising spend on {`TV`, `radio`, `newspaper`} has no influence on the amount of `sales`.

From the values, we can reject the null hypothesis for the `Intercept`, `TV` and `radio`, but cannot reject it for `newspaper`.

## 2) KNN

*Carefully explain the differences between the KNN classifier and KNN regression methods.*

The KNN classifier and the KNN regression are related. The classifier estimates a qualitative class for an observation based on its `K` nearest neighbours.

The KNN regression identifies `K` training ovservations that are closest to `x0` (represented by `N0`) and then estimates `f(x0)` using the average of all of the training responses in `N0`.



## 3) Predictors

Consider a data set with five predictors {X1, ..., X5} = (GPA, IQ, Gender, Interaction between GPA and IQ, Interaction between GPA and Gender). The response is starting salary after graduation (in thousands of dollars).

Suppose we use least squares fit and get B0 = 50, B1 = 20. B2 = 0.07, B3 = 35, B4 = 0.01, B5 = -10.

### a) Which answer is correct

1)  For a fixed value of IQ and GPA, males earn more on average than females
2)  For a fixed value of IQ and GPA, females earn more on average than males
3)  For a fixed value of IQ and GPA, males earn more on average provided that the GPA is high enough.
4)  For a fixed value of IQ and GPA, females earn more on average provided that the GPA is high enough.

To answer this, we fix B1, B2 and B4, so we're dependent on B3 = 35 and B5 = -10. B3 shows males earning more than females (we assume the dummy variable is 1 for males, 0 for females). B5 shows a negative correllation between males and GPA. Taking these two together, 3 is the correct answer.

### b) Predict the salary of a female with IQ 110 and a G.P.A of 4.0

f(x)    = 50 + 20*4.0 + 0.07*110 + 35*(0) + 0.01*(4.0 * 110) + -10(0 * 4.0)
        = 50 + 80 + 7.7 + 0 + 4.4 + 0
        = 142.1

### c) True or false: since the coefficient for the GPA/IQ interaction term is very small, there is very little evidence of an interaction effect.


