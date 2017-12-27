---
title: "Logistic Regression in Python"
author: "Henrik Eckermann"
date: "23.12.2017"
bibliography: 'Users/henrikeckermann/Documents/workspace/Website/mysite/main/templates/BibTex/statistics.bib'
csl: https://raw.githubusercontent.com/citation-style-language/styles/master/apa.csl
---

_italic_
Normal
**bold**
[link](www.google.de)


# Logistic Regression
- DV: Categorial, IV: Continuous or Categorical
- To make a linear relationship possible with a dichotomous variable, the logit is taken from the regression equation
- The equation for Logistic regression returns the P(Y|X) and it is:
$P(Y|X) = \frac{e^{a+b_1X_1+...+b_pX_p}}{1+e^{a+b_1X_1+...+b_pX_p}}$
- coefficients are estimated with maximum likelihood method
- Like in MLR, each predictor has a coefficient
- Log-likelihood: $\sum_{i=1}^N[Y_iln(\hat{Y_i}) + (1-Y_i)ln(1-\hat{Y_i})]$  
How well does the model fit - Analoguous to the residual sum of squares: The larger, the poorer the model fit. We can compare models using the Log-likelihood. The baseline in a logistic model is that it predicts the score with the highest frequency in the dataset. Whenever we add a predictor, we can evaluate if the log-likelihood significantly decreased or not by calculating the **likelihood-ratio** $\chi^2$ as follows: $\chi^2 = -2*LL_{small}-(-2*LL_{big})$. If it is significant, then the model with the added predictor predicts better than without.
- The Wald statistic is analogous to the t-statistic in linear regression: Does the predictor $b_i$ contribute? $Wald=\frac{b}{SE_b}$ (The Wald statistic needs to be treated with caution because with increasing b-coefficient the Wald statistic can be underestimated (more likely to make a type II error)
- More crucial for the interpretation is the **odds ratio: Exp(B) or $e^B$**. To interpret this first see what odds is: $\frac{P(y|x)}{1-P(x|y)}$ The odds ratio can then be interpreted as: Change in odds resulting from a unit change in the predictor. If the odds ratio >1, then the odds get higher with a unit increase in B and vice versa!
- CI for the Exp(B): 1 is the critical value here and not zero like for example in the t-test!
- Rule of thumb: divide ß by 4 to get the maximum change in probability for one unit change in the corresponding x. This upper bound is a reasonable approximation only near the midpoint of the logistic curve where P(Y|X) is close to 0.5.
​
## Assumptions
1. Linearity  
Linear relationship between continious X and the logit of Y.  
We can check this by looking at whether the interaction term between the predictor and its log transformation is significant.  
2. Indepence of Errors  
Just as in ordinary regression, the error must be independet. Thus, the data must be independet. You could not measure the same people at different points in time  
3. Multicollinearity  
Predictors should not be correlated too highly (check with VIF statistics, eigenvalues of the scaled uncentred cross-products matrix)
​
## Outliers:
- standardized residuals:
    - No more than 5% should have absolute values >2
    - No more than 1% should have absolute values >2.5
    - Absolute values >3 could be outlier
- Calculate average leverage (k+1)/N and look for values > 2(or 3)* the average leverage
- Look for absolute values of DFBeta>1
​
​
## Problems that can occur
1. Incomplete information  
If you have different categorial variables to predict Y but you miss combinations of variables, then this can lead to very high SE of the coefficients. Watch out how complete the information in the dataset is and always look at the SE.
2. Complete separation  
If Y can be perfectly predicted by an IV or a combination of IVs, standard errors get very large.
​
​
## Lecturer
- Need 50 participants per predictor
- No distributional assumptions
- Any combination of continuous and categorical IVs
- Can have interactions (moderation)
- Also called covariates (confusing term)
- If categorical variable with more than two levels, pay attention to the contrast group (set by SPSS)
​
​
```{r echo=TRUE}
print('penis')
```
​

​
Lecture Logistic Regression Bill
LL tell you how much you can NOT explain
Durban Watson for independence of errors
VIF, standardize
linearity only for continuous precdictors
In [ ]:
