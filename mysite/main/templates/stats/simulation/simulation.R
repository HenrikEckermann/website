




# Exercise 5 (using the well switch model)
setwd('/Users/henrikeckermann/Documents/workspace/website/mysite/main/templates/stats/logistic_regression/arm_lr/arsenic')
#import dataset
df <- read.table('wells.dat')
df$dist100 <- df$dist/100
df$educ4 <- df$educ/4
#center preds 
centered <- scale(df[,c('dist100','arsenic', 'educ4')], center=T, scale=F)
colnames(centered) <- c('c_dist100', 'c_arsenic', 'c_educ4')
df <- cbind(df, centered)
#fit model 
fit <- glm(switch ~ c_dist100 + c_arsenic + c_educ4 + c_dist100:c_arsenic + c_dist100:c_educ4+ c_arsenic:c_educ4 , family = binomial(link='logit'), df)
display(fit)

lr.sim <- sim(fit, 1000)
x.new <- data.frame(dist100=1, arsenic=-0.5, educ4=0.2)
xpred <- rep(NA, 1000)
for (i in c(1:1000)) {
  xpred[i] <- invlogit(lr.sim@coef[i,1] + lr.sim@coef[i,2]*x.new$dist100 + lr.sim@coef[i,3]*x.new$arsenic + lr.sim@coef[i,4]*x.new$educ4 + lr.sim@coef[i,5]*x.new$dist100*x.new$arsenic + lr.sim@coef[i,6]*x.new$dist100*x.new$educ4 + lr.sim@coef[i,7]*x.new$arsenic*x.new$educ4)
}
hist(xpred)

# Inference for the ratio of parameters: a (hypothetical) study compares the costs and effectiveness of two different medical treatments.  
# - In the first part of the study, the difference in costs between treatments A and B is estimated at $600 per patient, with a standard error of $400, based on a regression with 50 degrees of freedom.  
# -  In the second part of the study, the difference in effectiveness is estimated at 3.0 (on some relevant measure), with a standard error of 1.0, based on a regression with 100 degrees of freedom.  
# - For simplicity, assume that the data from the two parts of the study were collected independently.  
# - 
# Inference is desired for the incremental cost-effectiveness ratio: the difference between the average costs of the two treatments, divided by the difference between their average effectiveness. (This problem is discussed further by Heitjan, Moskowitz, and Whang, 1999.)

#a Create 1000 simulation draws of the cost difference and the effectiveness difference, and make a scatterplot of these draws.
cost_diff <- rnorm(1000, 600, 400)
eff_diff <- rnorm(1000, 3, 1)
ratio <- cost_diff/eff_diff
df <- data.frame(cost_diff, eff_diff, ratio)
qplot(cost_diff, eff_diff, data=df)
#b Use simulation to come up with an estimate, 50% interval, and 95% interval for the incremental cost-effectiveness ratio. 
quantile(df$ratio, c(0.025, 0.975))
quantile(df$ratio, c(0.25, 0.75))
qplot(ratio, geom='density', data=df)
#c Repeat this problem, changing the standard error on the difference in effectiveness to 2.0
cost_diff <- rnorm(1000, 600, 400)
eff_diff <- rnorm(1000, 3, 2)
ratio <- cost_diff/eff_diff
df <- data.frame(cost_diff, eff_diff, ratio)
qplot(cost_diff, eff_diff, data=df)
quantile(df$ratio, c(0.025, 0.975))
quantile(df$ratio, c(0.25, 0.75))
qplot(ratio, data=df)


#(a) Use sim() with n.iter = 10000. Compute the mean and standard deviations of the 1000 simulations of the coefficient of beauty, and check that these are close to the output from display.
#import data 
bdf <- read.csv('http://www.stat.columbia.edu/~gelman/arm/examples/beauty/ProfEvaltnsBeautyPublic.csv')
library(arm)
model <- lm(courseevaluation ~ btystdave + female + nonenglish, bdf)
display(model)
#10000
tt <- sim(model, 10000)
mean(tt@coef[,2]); sd(tt@coef[,2])
#(b) Repeat with n.iter = 1000, n.iter = 100, and n.iter = 10. Do each of these a few times in order to get a sense of the simulation variability.
#1000
t <- sim(model, 1000)
mean(t@coef[,2]); sd(t@coef[,2])
#100
h <- sim(model, 100)
mean(h@coef[,2]); sd(h@coef[,2])
#10
ten <- sim(model, 10)
mean(ten@coef[,2]); sd(ten@coef[,2])

#(c) How many simulations were needed to give a good approximation to the mean and standard error for the coefficient of beauty?
# 1000


#8.2 Fake data simulation to understand residual plots

#make fake data
midterm <- rnorm(50, 50, 12)
a <- 65
b <- 4
sigma <- 15
y_fake <- a + b * midterm + rnorm(50, 0,15)
#fit fake model 
lm_fake <- lm(y_fake ~ midterm)
display(lm_fake)
df <- data.frame(midterm, y_fake)
df$fitted <- fitted(lm_fake)
df$sresid <- rstandard(lm_fake)
qplot(fitted, sresid, data=df)
qplot(y_fake, sresid, data=df)
qplot(midterm, final, data=grades)



# 8.3 Simulating from the fitted model and comparing to actual data
l <- read.delim('lightspeed.dat', skip=3, header=F, sep=' ')
v <- c()
for (i in c(1:10)) {
  v <- append(v, l[,i])
}
df <- data.frame(y=na.omit(v))
# fit a normal distribution
light <- lm(y ~ 1, df)
summary(light)
#See: the mean is intercept + the sd == sd(resid)
mean(df$y)
sd(df$y)
sd(resid(light))
#simulate 1000 fake parameters
sim.light <- sim(light, 1000)
#simulate 1000 fake data sets
n <- length(df$y)
y.rep <- array(NA, c(1000, n))
for (i in 1:1000){
  y.rep[i,] <- rnorm(n, sim.light@coef[i], sim.light@sigma[i])
}
par(mfrow=c(5,4))
for (s in 1:20){
  hist(y.rep[s,])
}
hist(df$y)
