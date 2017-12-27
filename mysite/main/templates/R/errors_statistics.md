## Effect size, errors and power

When we perform hypothesis tests, we have a Null-hypothesis and at least one alternative hypothesis.

Rejecting the Null-Hypothesis when it is true is called **type one error** (false positive).  
Keeping the Null-Hypothesis when it is false is called **type two error** (false negative).

The probability that we reject the Null-Hypothesis  correctly, is the **power** of a statistical test.  

The power depends on the number of data points we have (N), the effect size and the **Alpha-value** we choose (by convention it is 0.05 or 0.01 but this is arbitrary - more important here is to make informed decisions).  

With high enough N we could reach a significant p-value (a p-value < alpha-value) even with meaningless effect sizes. Therefore, we also need to determine when an effect size is actually meaningful.

When we plan to use hypothesis testing we thus need to calculate how large N must be to be sure our statistical test has enough power to detect a certain effect size. We need to calculate this **before** we perform scientific experiments. Otherwise we may choose to few or too many subjects. In R, we can use the _pwr package_.

It is then more reasonable to present the effect size and a confidence interval rather than a p-value.
