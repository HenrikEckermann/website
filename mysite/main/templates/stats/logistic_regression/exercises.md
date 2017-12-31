##### 1. Presedential preference  
The folder nes contains the survey data of presidential preference and income for the 1992 election analyzed in Section 5.1, along with other variables including sex, ethnicity, education, party identification, and political ideology.

```{r}
setwd('/Users/henrikeckermann/Documents/Books/Extra/arm/ARM_Data/nes')
library(foreign)
nes <- read.dta('nes5200_processed_voters_realideo.dta')
print(nes)
```
###### a) Fit a logistic regression predicting support for Bush given all these inputs. Consider how to include these as regression predictors and also consider possible interactions.

```{r}
str(nes)
```

  
###### b) Evaluate and compare the different models you have fit. Consider coefficient estimates and standard errors, residual plots, and deviances.  
###### c) For your chosen model, discuss and compare the importance of each input variable in the prediction. 





##### Latent data formulation
Take the model Pr(y = 1) = logit−1(1 + 2x1 + 3x2) and consider a person for whom x1 = 1 and x2 = 0.5. Sketch the distribution of the latent data for this person. Figure out the probability that y=1 for the person and shade the corresponding area on your graph.

##### Limitations of logistic regression
Consider a dataset with n = 20 points, a single predictor x that takes on the values 1, . . . , 20, and binary data y. Construct data values y1, . . . , y20 that are inconsistent with any logistic regression on x. Fit a logistic regression to these data, plot the data and fitted curve, and explain why you can say that the model does not fit the data.

 

##### Graphing logistic regressions
The well-switching data described in Section 5.4 are in the folder arsenic.

###### (a) Fit a logistic regression for the probability of switching using log (distance to nearest safe well) as a predictor.  
###### (b) Make a graph similar to Figure 5.9 displaying Pr(switch) as a function of distance to nearest safe well, along with the data.  
###### (c) Make a residual plot and binned residual plot as in Figure 5.13.  
###### (d) Compute the error rate of the fitted model and compare to the error rate of the null model.  
###### (e) Create indicator variables corresponding to dist < 100, 100 ≤ dist < 200, and dist > 200. Fit a logistic regression for Pr(switch) using these indicators. With this new model, repeat the computations and graphs for part (a) of this exercise.  

##### Model building and comparison 
Continue with the well-switching data described in the previous exercise.  
###### (a) Fit a logistic regression for the probability of switching using, as predictors, distance, log(arsenic), and their interaction. Interpret the estimated coefficients and their standard errors.  
###### (b) Make graphs as in Figure 5.12 to show the relation between probability of switching, distance, and arsenic level.  
###### (c) Following the procedure described in Section 5.7, compute the average predictive differences corresponding to:  
i. A comparison of dist = 0 to dist = 100, with arsenic held constant. ii. A comparison of dist = 100 to dist = 200, with arsenic held constant.
iii. A comparison of arsenic = 0.5 to arsenic = 1.0, with dist held constant. iv. A comparison of arsenic = 1.0 to arsenic = 2.0, with dist held constant.
Discuss these results.  

##### Identifiability: 
The folder nes has data from the National Election Studies that were used in Section 5.1 to model vote preferences given income. When we try to fit a similar model using ethnicity as a predictor, we run into a problem. Here are fits from 1960, 1964, 1968, and 1972:
glm(formula = vote ~ female + black + income, family=binomial(link="logit"), subset=(year==1960))
R output
coef.est coef.se -0.14 0.23 0.24 0.14 -1.03 0.36 0.03 0.06
glm(formula
family=binomial(link="logit"), subset=(year==1964))
(Intercept) female black income
= vote ~ female + black + income,
coef.est (Intercept) -1.15 female -0.09 black -16.83 income 0.19
glm(formula = vote
family=binomial(link="logit"), subset=(year==1968))
coef.est coef.se (Intercept) 0.47 0.24
~
female
+ black + income,
coef.se 0.22 0.14 420.40 0.06

female -0.01 black -3.64 income -0.03
0.15 0.59 0.07
glm(formula = vote ~ female + black + income, family=binomial(link="logit"), subset=(year==1972))
coef.est coef.se (Intercept) 0.67 0.18 female -0.25 0.12 black -2.63 0.27 income 0.09 0.05
What happened with the coefficient of black in 1964? Take a look at the data and figure out where this extreme estimate came from. What can be done to fit the model in 1964?




## Chapter 4

1. Logarithmic transformation and regression: consider the following regression: log(weight) = −3.5 + 2.0 log(height) + error, with errors that have standard deviation 0.25. Weights are in pounds and heights are in inches.

(a) Fill in the blanks: approximately 68% of the persons will have weights within a factor of   and   of their predicted values from the regression.  
(b) Draw the regression line and scatterplot of log(weight) versus log(height) that make sense and are consistent with the fitted model. Be sure to label the axes of your graph.




2. The folder earnings has data from the Work, Family, and Well-Being Survey (Ross, 1990). Pull out the data on earnings, sex, height, and weight.  
  
(a) In R, check the dataset and clean any unusually coded data.
(b) Fit a linear regression model predicting earnings from height. What transfor- mation should you perform in order to interpret the intercept from this model as average earnings for people with average height?
(c) Fit some regression models with the goal of predicting earnings from some combination of sex, height, and weight. Be sure to try various transformations and interactions that might make sense. Choose your preferred model and justify.
(d) Interpret all model coefficients.


3. Plotting linear and nonlinear regressions: we downloaded data with weight (in pounds) and age (in years) from a random sample of American adults. We first created new variables: age10 = age/10 and age10.sq = (age/10)2, and indicators age18.29, age30.44, age45.64, and age65up for four age categories. We then fit some regressions, with the following results:  

lm(formula = weight ~ age10) coef.est coef.se (Intercept) 161.0 7.3 age10 2.6 1.6, n = 2009, k = 2
residual sd = 119.7, R-Squared = 0.00
lm(formula = weight ~ age10 + age10.sq) coef.est coef.se
R output
(Intercept) age10 age10.sq
n = 2009, k = residual sd =
96.2 19.3 33.6 8.7 -3.2 0.9 3
119.3, R-Squared = 0.01
lm(formula =
(Intercept) age30.44TRUE age45.64TRUE age65upTRUE
weight ~ coef.est 157.2 19.1 27.2 8.5
age30.44 + age45.64 + age65up) coef.se
5.4 7.0 7.6 8.7
n = 2009, k = residual sd =
4
119.4, R-Squared = 0.01
(a) On a graph of weights versus age (that is, weight on y-axis, age on x-axis), draw the fitted regression line from the first model.
(b) On the same graph, draw the fitted regression line from the second model.

76 LINEAR REGRESSION: BEFORE AND AFTER FITTING THE MODEL
(c) On another graph with the same axes and scale, draw the fitted regression line from the third model. (It will be discontinuous.)
4. Logarithmic transformations: the folder pollution contains mortality rates and various environmental factors from 60 U.S. metropolitan areas (see McDonald and Schwing, 1973). For this exercise we shall model mortality rate given nitric oxides, sulfur dioxide, and hydrocarbons as inputs. This model is an extreme oversimplification as it combines all sources of mortality and does not adjust for crucial factors such as age and smoking. We use it to illustrate log transforma- tions in regression.
(a) Create a scatterplot of mortality rate versus level of nitric oxides. Do you think linear regression will fit these data well? Fit the regression and evaluate a residual plot from the regression.
(b) Find an appropriate transformation that will result in data more appropriate for linear regression. Fit a regression to the transformed data and evaluate the new residual plot.
(c) Interpret the slope coefficient from the model you chose in (b).
(d) Now fit a model predicting mortality rate using levels of nitric oxides, sulfur dioxide, and hydrocarbons as inputs. Use appropriate transformations when
helpful. Plot the fitted regression model and interpret the coefficients.
(e) Cross-validate: fit the model you chose above to the first half of the data and then predict for the second half. (You used all the data to construct the model in (d), so this is not really cross-validation, but it gives a sense of how the
steps of cross-validation can be implemented.)
5. Special-purposetransformations:forastudyofcongressionalelections,youwould like a measure of the relative amount of money raised by each of the two major- party candidates in each district. Suppose that you know the amount of money raised by each candidate; label these dollar values Di and Ri. You would like to combine these into a single variable that can be included as an input variable into a model predicting vote share for the Democrats.
(a) Discuss the advantages and disadvantages of the following measures:
• The simple difference, Di − Ri
• The ratio, Di/Ri
• The difference on the logarithmic scale, log Di − log Ri • The relative proportion, Di/(Di + Ri).
(b) Propose an idiosyncratic transformation (as in the example on page 65) and discuss the advantages and disadvantages of using it as a regression input.
6. An economist runs a regression examining the relations between the average price of cigarettes, P , and the quantity purchased, Q, across a large sample of counties in the United States, assuming the following functional form, log Q = α+β log P . Suppose the estimate for β is 0.3. Interpret this coefficient.
7. Sequence of regressions: find a regression problem that is of interest to you and can be performed repeatedly (for example, data from several years, or for several countries). Perform a separate analysis for each year, or country, and display the estimates in a plot as in Figure 4.6 on page 74.
8. Return to the teaching evaluations data from Exercise 3.5. Fit regression models predicting evaluations given many of the inputs in the dataset. Consider interac- tions, combinations of predictors, and transformations, as appropriate. Consider

EXERCISES 77
several models, discuss in detail the final model that you choose, and also explain why you chose it rather than the others you had considered