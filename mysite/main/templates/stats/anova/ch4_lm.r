#*******************************************************************************
# Chapter 4: Normal linear models
#*******************************************************************************
#
# Fr�nzi Korner-Nievergelt, Tobias Roth, Stefanie von Felten, J�r�me Gu�lat, 
# Bettina Almasi, Pius Korner-Nievergelt, 2015. Bayesian data analysis in ecology 
# using linear models with R, BUGS and Stan. Elsevier.
#
# Last modification: 2. 10. 2014
# R version 3.1.1 (2014-07-10)
#-------------------------------------------------------------------------------
# Settings 
#-------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# 4.1	Linear regression
#------------------------------------------------------------------------------
#------------------------------------------------------------------------------
# 4.1.1	Background
#------------------------------------------------------------------------------


# model:
# y_i = b_0 + b_1 * x_i + e_i
# e_i ~ Norm(0, sigma2)

#------------------------------------------------------------------------------
#4.1.2	Fitting a linear regression in R
#------------------------------------------------------------------------------
# data simulation--------------------------------------------------------------
set.seed(34) # set a seed for the random number generator
n <- 50      # sample size
sigma <- 5   # standard deviation of the residuals
b0 <- 2      # intercept
b1 <- 0.7    # slope

x <- runif(n, 10, 30)   # sample values of the covariate

yhat <- b0 + b1*x
y <- rnorm(n, yhat, sd=sigma)

# end of data simulation-------------------------------------------------------

#-------------------------------------------
# Figure 4.1 
#-------------------------------------------

jpeg(filename="../figures/Figure4-1_regression.jpg",
     width = 6000, height = 6000, units = "px", res=1200)

plot(x,y, pch=16, las=1, cex.lab=1.2)

# insert regression line
abline(lm(y~x), lwd=2, col="blue")
# add the residuals
segments(x, fitted(lm(y~x)), x, y, lwd=2, col="orange", lty=3)

dev.off()

#--------------------------------------------------
# additional information, not part of the text book
#--------------------------------------------------
# obtain the LS-estimate analytically:
modmat <- model.matrix(~x)
library(MASS)
ginv((t(modmat)%*%modmat))%*%t(modmat)%*%y   # this is how to obtain the estimates for beta 
ginv(t(modmat)%*%modmat) # V_beta

#--------------------------------------------------
# fit the linear regression model

mod <-  lm(y~x)
mod
summary(mod)$sigma

# for r-code on assessing model assumptions, see chapter 6!


#-------------------------------------------
# 4.1.3	Drawing conclusions
#-------------------------------------------
#Draw inference from the regression using Bayesian methods
set.seed(34) # set a seed for the random number generator
library(arm)
nsim <- 1000

bsim <- sim(mod, n.sim=nsim)
str(bsim)

#-------------------------------------------
# Figure 4.2  : joint posterior distribution 
#-------------------------------------------
hist(coef(bsim)[,2], freq=FALSE)

histofun <- function(x){
  basicdat <- hist(x, plot=FALSE)
  segments(basicdat$mids, min(x), basicdat$mids, 
           min(x)+(max(x)-min(x))*2/3*basicdat$density/max(basicdat$density), lwd=10, lend="butt", col=grey(0.5))
  }
panelfun <- function(x,y) points(x,y, cex=0.6)

jpeg(filename="../figures/Figure4-2_jointposdist.jpg",
     width = 6000, height = 6000, units = "px", res=1200)
pairs(cbind(coef(bsim), bsim@sigma), diag.panel =histofun, panel=panelfun,
      labels=c(expression(beta[0]), expression(beta[1]), expression(sigma)))
dev.off()

#-------------------------------------------
# 95% CrI of model parameters
apply(coef(bsim), 2, quantile, prob=c(0.025, 0.975)) #the function coef extracts the simulated values for the beta coefficients

quantile(bsim@sigma, prob=c(0.025, 0.975))

quantile(coef(bsim)[,2], probs=c(0.025, 0.975))   # gives the 95%CrI of simulated values of x


# probability that the slope of the regression line is larger than  1
sum(coef(bsim)[,2]>1)/nsim
sum(coef(bsim)[,2]>0.5)/nsim




# show the effect graphically including credible interval 

jpeg(filename="../figures/Figure4-3_fitted_regrline.jpg",
     width = 9000, height = 5000, units = "px", res=1200)
par(mfrow=c(1,2), mar=c(5,4,2,0.2))     
plot(x,y, pch=16, las=1, cex.lab=1.2)
for(i in 1:nsim) abline(coef(bsim)[i,1], coef(bsim)[i,2], col=rgb(0,0,0,0.05))

newdat <- data.frame(x=seq(10, 30, by=0.1))
newmodmat <- model.matrix(~x, data=newdat)
fitmat <- matrix(ncol=nsim, nrow=nrow(newdat))
for(i in 1:nsim) fitmat[,i] <- newmodmat%*%coef(bsim)[i,]
plot(x,y, pch=16, las=1, cex.lab=1.2)
abline(mod, lwd=2)
lines(newdat$x, apply(fitmat, 1, quantile, prob=0.025), lty=3)
lines(newdat$x, apply(fitmat, 1, quantile, prob=0.975), lty=3)

dev.off()



# Add the posterior predictive distribution

# increase number of simulation to procude smooth lines of the posterior predictive distribution
set.seed(34) # set a seed for the random number generator
nsim <- 50000
bsim <- sim(mod, n.sim=nsim)
fitmat <- matrix(ncol=nsim, nrow=nrow(newdat))
for(i in 1:nsim) fitmat[,i] <- newmodmat%*%coef(bsim)[i,]


jpeg(filename="../figures/Figure4-4_postpreddist.jpg",
     width = 6000, height = 6000, units = "px", res=1200)

plot(x,y, pch=16, las=1, cex.lab=1.2)
abline(mod, lwd=2)
lines(newdat$x, apply(fitmat, 1, quantile, prob=0.025), lty=3)
lines(newdat$x, apply(fitmat, 1, quantile, prob=0.975), lty=3)

newy <- matrix(ncol=nsim, nrow=nrow(newdat)) 
# for each simulated fitted value, simulate one new y-value 
for(i in 1:nsim) newy[,i] <- rnorm(nrow(newdat), mean=fitmat[,i], 
                                   sd=bsim@sigma[i])
# extract the 2.5% and 97.5% quantiles of the simulated new data for each value on the x-axis of the plot
lines(newdat$x, apply(newy, 1, quantile, prob=0.025), lty=2)
lines(newdat$x, apply(newy, 1, quantile, prob=0.975), lty=2)

dev.off()

sum(newy[newdat$x==25,]>20)/nsim

#------------------------------------------------------------------------------
# 4.1.4  4.1.4	Frequentist results
#------------------------------------------------------------------------------
#------------------------------------------------------------------------------
#Interpretation of results from frequentists tests
#------------------------------------------------------------------------------
summary(mod)

#------------------------------------------------------------------------------
# 4.2	Regression variants: ANOVA, ANCOVA, and multiple regression 
#------------------------------------------------------------------------------
#------------------------------------------------------------------------------
# 4 .2.1	One-way ANOVA
#------------------------------------------------------------------------------

# data simulation--------------------------------------------------------------
# compare mean of y between 3 groups
# model:  y_i = mu + I(group2)*b_1 + I(group3)*b_2 + e_i
#         e_i ~ Norm(0, sigma^2)

mu <- 12 # mean of group 1 (reference group)
sigma <- 2 # Residual standard deviation

b1 <- 3   # difference between group 1 and group 2
b2 <- -5  # difference between group 1 and group 3

n <- 90  # sample size

# generate data
group <- factor(rep(c(1,2,3), each=30))

# simulate the y variable
set.seed(626436)  # set the seed of the random number generator, so that everybody gets the same numbers
simresid <- rnorm(n, mean=0, sd=sigma)  # simulate residuals

y <- mu + as.numeric(group=="2") * b1 + as.numeric(group=="3") * b2 + simresid
# end of data simulation--------------------------------------------------------------

# -----------------------------------------------------------------------------
# do an ANOVA
# -----------------------------------------------------------------------------
# Figure 4.5
# -----------------------------------------------------------------------------

# have a look at the (simulated) data
jpeg(filename="../figures/Figure4-5_anova_simdat.jpg",
     width = 6000, height = 6000, units = "px", res=1200)

boxplot(y~group, las=1, names=c("group 1", "group 2", "group 3"), ylab="Weight (g)",
    boxwex=0.5, col="orange", cex.lab=1.4, ylim=c(0, max(y)), cex.axis=1.4)
npg <- table(group)
text(1:3, rep(1, 3), npg, cex=1.4)
text(0.6, 1, "n =", cex=1.4)
dev.off()


#------------------------------------------------------------------------------
# Do the ANOVA using R

# do the ANOVA
group <- factor(group)# define group as a factor!
mod <- lm(y~group)  # fit the model

# parameter estimates 
mod
summary(mod)$sigma

#------------------------------------------------------------------------------
# r_squared
ssb <- anova(mod)["Sum Sq"][1,1]
sst <- var(y)*(length(y)-1)
ssb/sst

# adjusted r_squared  (interpret as proportion of variance explained by the model)
(var(y)-summary(mod)$sigma^2)/var(y)  # use this R2 if more than one explanatory variable in the model



# Assess model assumptions: residual analysis
par(mfrow=c(2,2))
plot(mod)
# test for autocorrelation
par(mfrow=c(1,1))
acf(resid(mod))  # detect systematic change along the entries in the data file

#------------------------------------------------------------------------------

# draw inference in a Bayesian way

# draw simulations from the posterior distributions of the model parameters
set.seed(626436)  # set the seed of the random number generator, so that everybody gets the same numbers
nsim <- 1000
bsim <- sim(mod, n.sim=nsim)

apply(coef(bsim), 2, mean)  # means of the posterior distributions for the coefficients (compare to summary(mod))

#--------------------------------------------------------------------------------------
# obtain group means as derived parameters:
m.g1 <- coef(bsim)[,1]    # a lot of values from the posterior distribution of mean of group 1
m.g2 <- coef(bsim)[,1]+coef(bsim)[,2] # a lot of values from the posterior distribution of mean of group 2
m.g3 <- coef(bsim)[,1]+coef(bsim)[,3] # a lot of values from the posterior distribution of mean of group 3

#--------------------------------------------------------------------------------------
#Figure 4.6
#--------------------------------------------------------------------------------------

jpeg(filename="../figures/Figure4-6_postdist_anova.jpg",
     width = 9000, height = 4500, units = "px", res=1200)

par(mfrow=c(1,2))
hist(m.g1, xlim=c(5, 16), main="", xlab="Group means", las=1, ylab="Density",
  freq=FALSE, cex.lab=1.4, cex.axis=1.2)    # histogramm of the simulations describing the posterior distribution of the mean of group 1
hist(m.g2, add=TRUE, col="orange", freq=FALSE)
hist(m.g3, add=TRUE, col="blue", freq=FALSE)

groupmeans <- cbind(m.g1, m.g2, m.g3) # combine the 3 vectors together in a matrix
plot(1:3, seq(0, 16, length=3), xlim=c(0.5, 3.5), type="n", las=1, xlab="Group",
  ylab="y", cex.lab=1.4, cex.axis=1.2, xaxt="n")
axis(1, at=1:3, labels=1:3, cex.axis=1.2)
segments(1:3, apply(groupmeans, 2, quantile, prob=0.025), 1:3, apply(groupmeans, 2, quantile, prob=0.975),
  lend="butt", lwd=3, col=c(1, "orange", "blue"))
points(1:3, apply(groupmeans, 2, mean), pch=21, bg="white", 
       cex=0.9, col=c(1, "orange", "blue"))

dev.off()



# differences between group means
d.g1.2 <- m.g1-m.g2
mean(d.g1.2)
quantile(d.g1.2, prob=c(0.025, 0.975))

sum(m.g2>m.g1)/nsim  # probability that mean of group 2is higher than mean of group 1


#------------------------------------------------------------------------------
# 4.2.2	Frequentist results from a one-way ANOVA
#------------------------------------------------------------------------------
#------------------------------------------------------------------------------
# overall mean and total variance
#------------------------------------------------------------------------------
mean(y)
var(y)
sd(y)

#--------------------------------------------------------------------------------------
#Figure 4.7
#--------------------------------------------------------------------------------------
jpeg(filename="../figures/Figure4-7_SS.jpg",
     width = 9000, height = 4000, units = "px", res=1200)

par(mfrow=c(1,3), mar=c(5,3,3,0.5), oma=c(0,2,0,0))
# total sum of squares
plot(1:n, y, las=1, cex.lab=1.2, pch=16, ylab=NA, 
     xlab="Observation ID", main="SST", cex.main=1.5)
abline(h=mean(y))
segments(1:n, mean(y), 1:n, y, col="orange", lwd=1)
mtext("Weights (g)", side=2, outer=TRUE)

# sum of squares between groups
mpg <- tapply(y, group, mean)
plot(1:n, y, las=1, cex.lab=1.2, pch=16, ylab=NA, 
     xlab="Observation ID", main="SSB", yaxt="n", cex.main=1.5)
segments(c(1, cumsum(npg)[1:2]+1), mpg, cumsum(npg), mpg)
abline(h=mean(y))
segments(1:n, rep(mpg, times=npg), 1:n, mean(y), col="orange", 
         lwd=1)

text(-13.5, mean(y), "=", xpd=NA, cex=2)
text(-13.5, 20.5, "=", xpd=NA, cex=2)

# sum of squares within groups
plot(1:n, y, las=1, cex.lab=1.2, pch=16, ylab=NA, 
     xlab="Observation ID", main="SSW", yaxt="n", cex.main=1.5)
segments(c(1, cumsum(npg)[1:2]+1), mpg, cumsum(npg), mpg)
segments(1:n, rep(mpg, times=npg), 1:n, y, col="orange", lwd=1)
text(-13.5, mean(y), "+", xpd=NA, cex=2)
text(-13.5, 20.5, "+", xpd=NA, cex=2)
dev.off()


#--------------------------------------------------------------------------------------
#Figure 4.8
#--------------------------------------------------------------------------------------

# draw F-distribution
jpeg(filename="../figures/Figure4-8_F.jpg",
     width = 6000, height = 4000, units = "px", res=1200)

x <- seq(0, 8, by=0.01)
dfx <- df(x, df1=2, df2=n-3)
plot(x, dfx, type="l", xlab="F-value", ylab="Density", las=1, cex.lab=1.4, lwd=2, yaxs="i", xaxs="i",
     cex.axis=1.2)
par(mar=c(5,4.5,1,1))
# find the critical F-value
fcrit <- qf(p=0.95, df1=2, df2=n-3)
polygon(c(fcrit, fcrit, x[x>fcrit]), c(0, df(fcrit, df1=2, df2=n-3),dfx[x>fcrit]), col="orange", border=NA)
text(4.2, 0.1, "5 %", cex=1.3, col="orange")
dev.off()

#--------------------------------------------------------------------------------------
# additional code, not in the text book
#--------------------------------------------------------------------------------------

# classical ANOVA table
# sum of squares
sst <- sum((y-mean(y))^2)
ssb <- sum((rep(mpg, npg)-mean(y))^2)
ssw <- sum((rep(mpg, npg)-y)^2)

# sst = ssb + ssw
ssb+ssw
sst

# using the R-function anova
anova(mod)          # ANOVA table


# mean sum of squares
k <- 3 # number of groups
msb <- ssb/(k-1)
msw <- ssw/(n-k)

f.obs <- msb/msw

# p-value
1-pf(f.obs, df1=k-1, df2=n-k)
# 


#---------------------------------------------------------------------------------
# 4.2.3	Two-way ANOVA
#---------------------------------------------------------------------------------

# read in data
library(blmeco)
data(periparusater)
dat <- periparusater
str(dat)
# the data contain measurements taken from museum skins of Coal tits
# country = country of origin of the individual
# age, sex = age class (code) and sex code (see below)
# P8 = length of primary 8 (the third-outermost wing feather, often building the wing tip)
# wing = length of wing chord
dat$sexage <- factor(paste(dat$sex, dat$age))




# fit the model 
mod <- lm(wing~sex+age, data=dat)
mod
summary(mod)$sigma

# residual analysis
plot(mod)
acf(resid(mod))
plot(resid(mod)~dat$sexage)

# add predicted values (group means
newdat <- expand.grid(sex=factor(c(1,2)), age=factor(c(3,4)))
newdat$fit <- predict(mod, newdata=newdat)
set.seed(11002)
nsim <- 2000
bsim <- sim(mod, n.sim=nsim)
str(bsim)
fitmat <- matrix(ncol=nsim, nrow=nrow(newdat))
Xmat <- model.matrix(formula(mod)[c(1,3)], data=newdat)
for(i in 1:nsim) fitmat[,i] <- Xmat%*%bsim@coef[i,]
newdat$lower <- apply(fitmat, 1, quantile, prob=0.025)
newdat$upper <- apply(fitmat, 1, quantile, prob=0.975)

#--------------------------------------------------------------------------------------
#Figure 4.9
#--------------------------------------------------------------------------------------


jpeg(filename="../figures/Figure4-9_two-wayANOVA.jpg",
     width = 6000, height = 6000, units = "px", res=1200)
par(mar=c(5,4.5,1,1))
plot(wing~jitter(as.numeric(sexage), amount=0.05), data=dat, las=1, ylab="Wing length (mm)", xlab="Sex and age", xaxt="n",
    pch=1, cex.lab=1.4, cex=0.8, cex.axis=1.1, xlim=c(0.5, 4.5))
newdat$sexage <- factor(paste(newdat$sex, newdat$age))
x <- as.numeric(newdat$sexage)+0.15
segments(x, newdat$lower, x, newdat$upper, lwd=2, lend="butt")
points(x, newdat$fit, pch=17, cex=1.3)
axis(1, at=c(1:4), labels=c("juv M", "ad M", "juv F", "ad F"), cex.axis=1.2)

#--------------------------------------------------------------------------------------

mod2 <- lm(wing~sex*age, data=dat)
set.seed(1442)
bsim2 <- sim(mod2, n.sim=nsim)

Xmat <- model.matrix(formula(mod2)[c(1,3)], data=newdat)
fitmat2 <- matrix(ncol=nsim, nrow=nrow(newdat))
for(i in 1:nsim) fitmat2[,i] <- Xmat%*%bsim2@coef[i,]
newdat$fitint <- predict(mod2, newdata=newdat)
newdat$lowerint <- apply(fitmat2, 1, quantile, prob=0.025)
newdat$upperint <- apply(fitmat2, 1, quantile, prob=0.975)
x <- as.numeric(newdat$sexage)+0.3
segments(x, newdat$lowerint, x, newdat$upperint, lwd=2, lend="butt", lty=1)
points(x, newdat$fitint, pch=16,cex=1.3)

dev.off()

#-------------------------------------------------------------------------
#additional coed, not in the text book
#-------------------------------------------------------------------------
# posterior distribution of the interaction parameter
hist(bsim2@coef[,4], col=grey(0.5), las=1, main="", cex.axis=1.1, cex.lab=1.4, freq=FALSE)
abline(v=1, lwd=2, col="orange")

#-------------------------------------------------------------------------

quantile(bsim2@coef[,4], prob=c(0.025, 0.5, 0.975))

mean(abs(bsim2@coef[,4])>0.3)

summary(mod2)$sigma # compare to between-individual variance


# report the results
coef(mod2)
colnames(bsim2@coef) <- names(coef(mod2))
apply(bsim2@coef, 2, quantile, prob=c(0.025, 0.975))

# estimated differences:
quantile(bsim2@coef[,2], prob=c(0.025, 0.5, 0.975))
quantile(bsim2@coef[,2]+bsim2@coef[,4], prob=c(0.025, 0.5, 0.975))


# posterior probability that males have longer wings than females
# for adults
sum(bsim2@coef[,2]<0)/nsim
# for juveniles
sum(bsim2@coef[,2]+bsim2@coef[,4]<0)/nsim




#-------------------------------------------------------------------------------
# 4.2.4	Frequentist results from a two-way ANOVA
#-------------------------------------------------------------------------------
dat <- dat[order(dat$sex, dat$age),] # order data file according to sex and age
dat$pch1 <- dat$pch
dat$pch1[dat$pch==21&dat$col=="blue"] <- 16
dat$pch1[dat$pch==22&dat$col=="blue"] <- 15

mod <- lm(wing~sex+age, dat)
mod2 <- lm(wing~sex*age, dat)

modsex <- lm(wing~sex, dat)
modage <- lm(wing~age, dat)

n <- nrow(dat)
#-------------------------------------------------------------------------------
# Figure 4.10
#-------------------------------------------------------------------------------

jpeg(filename="../figures/Figure4-10_SS_unbalanced.jpg",
     width = 9000, height = 4500, units = "px", res=1200)

par(mfrow=c(1,2), mar=c(1,1, 2,0.1),mgp=c(3,0.5,0), tck=-0.01, oma=c(2,2,0,15))
plot(1:n, dat$wing, pch=dat$pch1, las=1, ylab=NA, 
  cex.lab=1, cex.axis=0.9, xlab=NA, ylim=c(55, 70), 
  lwd=1, main="wing ~ sex + age")
mtext("Observation", side=1, outer=TRUE, line=0.5)
mtext("Wing length (mm)", side=2, outer=TRUE, line=1)
abline(h=mean(dat$wing)) # overall mean (null model)
for(i in levels(dat$sex)) for(j in levels(dat$age)){ 
  lines(c(1:n)[dat$sex==i&dat$age==j], fitted(mod)[dat$sex==i&dat$age==j], 
        col=1, lwd=2)
}
for(i in levels(dat$sex)) for(j in levels(dat$age)) lines(c(1:n)[dat$sex==i&dat$age==j], fitted(modsex)[dat$sex==i&dat$age==j], col=1, lwd=2, lty=3)
v <- 0.08
segments(c(1:n)-v, mean(dat$wing), c(1:n)-v, fitted(modsex), lwd=3, col="blue", lend="butt")
segments(c(1:n)+v, fitted(modsex), c(1:n)+v, fitted(mod), lwd=3, col="orange", lend="butt")

#legend(1, 60, pch=c(15, 22, 16, 21, NA, NA, NA, NA), lty=c(rep(NA,4), 1,3,1,1),   col=c(rep(1,6), "blue", "orange"), lwd=c(rep(1, 4), rep(2, 4)),
#  legend=c("juvenile males", "adult males", "juvenile females", "adult females", "fitted per sex and age class", "fitted per sex", "SS of sex", "SS of age"), cex=1)


plot(1:n, dat$wing, pch=dat$pch1, las=1, ylab=NA, 
  cex.lab=1, cex.axis=0.9, xlab=NA, yaxt="n", ylim=c(55, 70), lwd=1, 
  main="wing ~ age + sex")
abline(h=mean(dat$wing)) # overall mean (null model)
for(i in levels(dat$sex)) for(j in levels(dat$age)){
  lines(c(1:n)[dat$sex==i&dat$age==j], fitted(mod)[dat$sex==i&dat$age==j], 
        col=1, lwd=2)
}
for(i in levels(dat$sex)) for(j in levels(dat$age)){ 
  lines(c(1:n)[dat$sex==i&dat$age==j], 
        fitted(modage)[dat$sex==i&dat$age==j], col=1, lwd=2, lty=3)
}
v <- 0.08
segments(c(1:n)-v, mean(dat$wing), c(1:n)-v, fitted(modage), 
         lwd=3, col="orange", lend="butt")   # effect of age
segments(c(1:n)+v, fitted(modage), c(1:n)+v, fitted(mod), lwd=3, col="blue", lend="butt")        # effect of sex
legend(20.5, 70.5, pch=c(15, 22, 16, 21, NA, NA, NA, NA), 
       lty=c(rep(NA,4), 1,3,1,1),   col=c(rep(1,6), "blue", "orange"), 
       lwd=c(rep(1, 4), rep(2, 4)), xpd=NA,bty="n",
  legend=c("juvenile males", "adult males", "juvenile females", 
           "adult females", "fitted per sex and age class", 
           "fitted per sex (left) or age class (right)", "SS of sex", 
           "SS of age"), cex=0.9)

dev.off()

#--------------------------------------------------------------
# additional code
#--------------------------------------------------------------
anova(mod)  # sequential test
anova(lm(wing~age+sex, dat))


drop1(mod, test="F")   # independent of order
 

#--------------------------------------------------------------------------------
# 4.2.6	Analysis of covariance
#--------------------------------------------------------------------------------

library(blmeco)
data(ellenberg)
# select data of Alopecurus pratensis, Dactylis glomerata

index <- is.element(ellenberg$Species, c("Ap", "Dg"))
dat <- ellenberg[index,]
dat <- droplevels(dat)

# run the model
str(dat) # make sure that factors are factors and  numeric variables numeric

mod <- lm(log(Yi.g)~Species+Water, data=dat)

head(model.matrix(mod))
mod
summary(mod)$sigma
summary(mod)

#------------------------------------
# residual analysis
#------------------------------------
par(mfrow=c(2,2))
plot(mod)   # standard plots

index <- complete.cases(dat[,c("Yi.g", "Species", "Water")])
plot(dat$Water[index], resid(mod))     # residuals against predictors
abline(h=0)

plot(resid(mod)~dat$Species[index])

acf(resid(mod))   # there seems to be some correlation -> because there is repeated measurements, we re-analyse the data set in the mixed effect model chapter...
#------------------------------------


# interaction
mod2 <- lm(log(Yi.g)~Species*Water, data=dat)
mod2 <- lm(log(Yi.g)~Species+Water+Species:Water, data=dat)
mod2 <- lm(log(Yi.g)~(Species+Water)^2, data=dat)

summary(mod2)

#--------------------------------------------------------------------------
# Figure 4.11
#--------------------------------------------------------------------------
jpeg(filename="../figures/Figure4-11_ANCOVA.jpg",
     width = 9000, height = 5000, units = "px", res=1200)

par(mfrow=c(1,2), mgp=c(2.5, 1, 0), mar=c(5.5,2,3,0.5), oma=c(0,2,0,0))
plot(dat$Water, log(dat$Yi.g), col=c("orange", "blue")[as.numeric(dat$Species)],
     las=1, ylab=NA, main="log(Yi.g) ~ Species * Water",
     xlab="Average distance to ground water (cm)", pch=c(16, 17)[as.numeric(dat$Species)])
mtext(expression(paste("Above-ground biomass ", (g/m^2),  " [log]")), 
      side=2, outer=TRUE)

# insert regression lines per group
abline(lm(log(Yi.g)~Water, data=dat[dat$Species=="Ap",]), lwd=2, col="orange")
abline(lm(log(Yi.g)~Water, data=dat[dat$Species=="Dg",]), lwd=2, col="blue")
legend(0, -1.2, pch=c(16, 17), lty=1, lwd=2, col=c("orange", "blue"), 
       legend=c("Species Ap", "Species Dg"), horiz=TRUE, xpd=NA, bty="n")

# visualise the model
plot(dat$Water, log(dat$Yi.g), col=c("orange", "blue")[as.numeric(dat$Species)],
     las=1, ylab=NA, yaxt="n", main="log(Yi.g) ~ Species + Water",
     xlab="Average distance to ground water (cm)", pch=c(16, 17)[as.numeric(dat$Species)])
abline(coef(mod)[1], coef(mod)[3], lwd=2, col="orange")
abline(coef(mod)[1]+coef(mod)[2], coef(mod)[3], lwd=2, col="blue")
dev.off()



# When does species Dg has an advantage over species Ap

library(arm)
set.seed(142)
nsim <- 2000
bsim <- sim(mod2, n.sim=nsim)

xatcross <- crosspoint(coef(bsim)[,1], coef(bsim)[,3], 
                       coef(bsim)[,1]+coef(bsim)[,2], coef(bsim)[,3]+coef(bsim)[,4])[,1]
xatcross[xatcross< (-5)] <- -5
th <- hist(xatcross, breaks=seq(-5.5, 140.5, by=5))

#-------------------------------------------------------------------------------
# Figure 4.11
#-------------------------------------------------------------------------------

jpeg(filename="../figures/Figure4-12_DgAp.jpg",
     width = 6000, height = 6000, units = "px", res=1200)

plot(th$mids, cumsum(th$counts)/2000, type="l", lwd=2, las=1,ylim=c(0,1),
     ylab="P(Dg > Ap | data)", xlab="Average distance to ground water (cm)")

dev.off()

#-------------------------------------------------------------------------------
# 4.2.7	Multiple regression and collinearity
#-------------------------------------------------------------------------------

data(mdat)

mod <- lm(y~x1+x2, data=mdat)
summary(mod)

library(lattice)
newdat <- expand.grid(x1=seq(min(mdat$x1), max(mdat$x1), length=10),
                      x2=seq(min(mdat$x2), max(mdat$x2), length=10))
newdat$yhat <- predict(mod, newdata=newdat)



jpeg(filename="../figures/Figure4-13A_multiplreg.jpg",
     width = 6000, height = 6000, units = "px", res=1200)

cloud(y~x1*x2, mdat, add=TRUE)
dev.off()

jpeg(filename="../figures/Figure4-13B_multiplreg.jpg",
     width = 6000, height = 6000, units = "px", res=1200)

wireframe(yhat~x1*x2, data=newdat, drape=TRUE, colorkey=TRUE)
dev.off()





# look at the data
cor(mdat[,2:6])
pairs(mdat, panel=panel.smooth)

# how to use the function pairs: -----------------------------------------------
own.graph <- function(x,y){
  points(x,y, pch=16, col=rgb(1,0.5,0,0.7), cex=0.8)
  abline(lm(y~x))
  }

jpeg(filename="../figures/Figure4-14_pairs.jpg",
     width = 6000, height = 6000, units = "px", res=1200)

pairs(mdat, panel=own.graph, cex.labels=1.4)
dev.off()
# end of how to use the function pairs------------------------------------------







#-------------------------------------------------------------------------------
# 4.2.8	Ordered factors and contrasts
#-------------------------------------------------------------------------------
data(swallows)
levels(swallows$nesting_aid)
contrasts(swallows$nesting_aid)

swallows$nesting_aid <- factor(swallows$nesting_aid, levels=c("none", "support", "artif_nest", "both"), ordered=TRUE)
levels(swallows$nesting_aid)
contrasts(swallows$nesting_aid)

#-------------------------------------------------------------------------------
# 4.2.9	Quadratic and higher polynomial terms
#-------------------------------------------------------------------------------

data(ellenberg)
dat <- ellenberg
# data on grass species performance (measured with the variable Yi.g) in relation to the depth of available water in the ground.

ix <- dat$Species=="Ap"        # index for the grass species we want to look at here = Ap
dat <- ellenberg[ix,]
dat <- dat[!is.na(dat$Water),]  # NA's are not allowed for the poly-function

t.poly <- poly(dat$Water, 2)   # create a poly-object with orthogonal linear and quadratic polynomials
dat$Water.l <- t.poly[,1]        # linear term for water
dat$Water.q <- t.poly[,2]        # quadratic term for water

mod <- lm(log(Yi.g) ~ Water.l + Water.q, data=dat)

newdat <- data.frame(Water = seq(0,140))              #	predict over the observed range of Water
newdat$Water.l <- predict(t.poly,newdat$Water)[,1]    # transformation analogous to the one used to fit the model
newdat$Water.q <- predict(t.poly,newdat$Water)[,2]

Xmat <- model.matrix(~ Water.l + Water.q, data=newdat)   # model matrix to get the fitted values in the next line
newdat$fit <- Xmat %*% coef(mod)

# get values from the posterior distribution to, afterwards, calculate the 95% credible interval
library(arm)
nsim <- 10000
bsim <- sim(mod, nsim)
fitmat <- matrix(nrow=nrow(newdat), ncol=nsim)
for(i in 1:nsim) fitmat[,i] <- Xmat %*% bsim@coef[i,]
newdat$lwr <- apply(fitmat, 1, quantile, prob=0.025)    # lower bound of the 95% credible interval
newdat$upr <- apply(fitmat, 1, quantile, prob=0.975)    # upper bound of the 95% credible interval

# draw the effect plot, on the original Water-sclae, and with 95% credible interval.
plot(dat$Water, log(dat$Yi.g), xlab="Water depth", ylab="log(Yi.g)",las=1)
lines(newdat$Water, newdat$fit)
lines(newdat$Water, newdat$lwr, lty=3)
lines(newdat$Water, newdat$upr, lty=3)




#did not work
```{r}
#create matrix that has each possible combination of preds once
newdat <- expand.grid(sex=factor(c('male','female')), age=factor(c('juv','adu'))) 
#add coefficients to that matrix
newdat$fit <-  model.matrix(~ sex + age, data=newdat) %*% coef(mod)
#this is the result
newdat
#simulate 2000 times model parameters
nsim <- 2000
bsim <- sim(mod, n.sim=nsim)
fitmat <- matrix(ncol=nsim, nrow=nrow(newdat))
Xmat <- model.matrix(formula(mod)[c(1,3)], data=newdat)
for(i in 1:nsim) {
  fitmat[,i] <- Xmat %*% bsim@coef[i,]
}

newdat$lower <- apply(fitmat, 1, quantile, prob=0.025)
newdat$upper <- apply(fitmat, 1, quantile, prob=0.975)
```