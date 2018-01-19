#categorical data analysis script from Bill's lecture

#this script describes steps for performing: (a) binary logistic regression, (b) multinomial logistic regression, (c) chi-square analyses, and (d) loglinear analyses

#for logistic regression (with missing values): 

install.packages("foreign") #to import spss file
install.packages("lattice") #for density plots
install.packages("car") #for dwt() and vif()
install.packages("VIM")#for missing values 

library(foreign)
library(lattice)
library(car)
library(VIM)


######################

#import data

setwd("//Cnas.ru.nl/u148154/Documents/RU courses/Analyzing in R 2016")

logex <- read.spss("logreg.sav", to.data.frame = T, use.value.labels = T)
head(logex)

#alternative to use.value.labels
#logex$sex <- factor(logex$sex, levels = c(0:1), labels = c("male", "female"))
#logex$satjob <- factor(logex$satjob, levels = c(0:1), labels = c("satisfied", "not satisfied"))
#logex$life <- factor(logex$life, levels = c(1:3), labels = c("dull", "routine", "exciting"))

#there are missing values, so...

#examine prevalence and patterns of missing
miss <- aggr(logex, numbers=T, prop = F)
miss

#examine missingness between two variables (this can be done for any pair of variables...histogram preferable when one variable is continuous)
miss2<- logex[ ,c("age","satjob")]
histMiss(miss2)

################

###OPTIONAL (not in lecture slides) ###
#this is one way to perform "attrition" analyses (i.e., testing whether participants with missing values on job satisfaction differ from those without missing)

#create new dummy variable indicating who is missing satjob (missing = 0 and not missing = 1)
logex$nojob <-as.integer(complete.cases(logex$satjob))

#perform t-test examining whether those with missing satjob differ in age from those with satjob
t.test(age ~ nojob, logex)

#these two steps could be used to test differences between any pair of variables.

################

#there are several ways to obtain a subset of complete cases

# (a) create subset that omits cases with missing values
logex1sub<-subset(logex, satjob != FALSE & life != FALSE, select=c("id", "sex", "satjob", "life"))
head(logex1sub)
nrow(logex1sub)

### (b) alternative using complete.cases()
#logex1 <- logex[,c(1,3,4,7)]
#logex1sub2 <- logex1[complete.cases(logex1),]
#head(logex1sub2)
#nrow(logex1sub2)

### (c) alternative using na.omit
#logex1sub3 <- na.omit(logex1)
#head(logex1sub3)
#nrow(logex1sub3)

#it is always a good idea to know what the reference groups are, so...

#inspect contrast settings (default is dummy coding)
contrasts(logex1sub$sex)
contrasts(logex1sub$satjob)
contrasts(logex1sub$life)

#specify effect coding (included as a primer for next week when different coding schemes are described)
#...does not change any values compared to dummy codes (FOR MODEL WITH MAIN EFFECTS ONLY)
#contrasts(logex$sex)<- contr.sum(2)
#contrasts(logex$satjob)<- contr.sum(2)
#contrasts(logex$life)<- contr.sum(3)

#perform binary logistic regression on entire data frame (only to show listwise deletion is default)
#logmodel <- glm(satjob ~ sex + life, data = logex, family = binomial())
#summary(logmodel)

#perform binary logistic regression on subset
logmodel1 <- glm(satjob ~ sex + life, data = logex1sub, family = binomial())

#examine model assumptions

# (1) test independence of errors
dwt(logmodel1)

# (2) examine VIFs (multicollinearity)
###for continuous predictors (which are not in this example) the GVIF can be used
###for categorical predictors the GVIF^(1/(2*Df)) should be used...values above 10 indicate a problem
vif(logmodel1)

# (3) test linearity
### this is only done for continuous predictors...so it is not necessary for this example

# examine outliers and influential cases

#import and examine standardized residuals
logex1sub$residuals <- rstandard(logmodel1)
densityplot(logex1sub$residuals)

#import and examine DFBetas (influence)
logex1sub$dfbeta <- dfbeta(logmodel1)
densityplot(logex1sub$dfbeta) #does not work for DF betas
hist(logex1sub$dfbeta)

#import and examine hat values (leverage, which is also for influential cases)
logex1sub$leverage <- hatvalues(logmodel1)
densityplot(logex1sub$leverage)

#determine leverage cutoff value
3/754

#default plots not very helpful
plot(logmodel1)

###CONCLUSION: leverage values indicate some issues, all other metrics do not indicate problem

########################

# examine fit of overall model (deviance and pseudo R-square)

#Assess model fit...statistically significant chi-square indicates predictors improve null model
modelChi <- logmodel1$null.deviance - logmodel1$deviance
chidf <- logmodel1$df.null - logmodel1$df.residual
chisq.prob <- 1 - pchisq(modelChi, chidf)
modelChi; chidf; chisq.prob

#Compute R-square...three different pseudo R-squares (Nagelkirke)
R2.hl<-modelChi/logmodel1$null.deviance
R.cs <- 1 - exp ((logmodel1$deviance - logmodel1$null.deviance)/754)
R.n <- R.cs /( 1- ( exp (-(logmodel1$null.deviance/ 754))))
R2.hl; R.cs; R.n


###examine parameter estimates...finally
summary(logmodel1)

#unstandardized only, so compute odds ratio and CIs
exp(logmodel1$coefficients)
exp(confint(logmodel1))

#there is one comparison not made (routine vs. exciting), so...
#change reference group of lifestyle from dull to routine
logex1sub$life <- relevel(logex1sub$life, ref = 2)
contrasts(logex1sub$life)
###so routine is now reference group

#perform alternative logistic regression model
logmodel1alt <- glm(satjob ~ sex + life, data = logex1sub, family = binomial())
summary(logmodel1alt)

#change reference group back to dull (this was not done in the lecture slides)
logex1sub$life <- relevel(logex1sub$life, ref = 2)
contrasts(logex1sub$life)

#test the interaction between gender and lifestyle
# perform interactive logistic regression model
logmodel2 <- glm(satjob ~ sex * life, data = logex, family = binomial())
summary(logmodel2)
###while I do not do it here, the model diagnostics should also be checked for this model as well (ORs and CIs would also need to be calculated)

#Compare two models
anova(logmodel1,logmodel2)
#interaction(s) do not add to model (deviance not reduced)

##################################

## Multinomial logistic regression


install.packages("mlogit")
install.packages("car")
library(car)
library(mlogit)
library(lattice)

#re-load dataframe (mlogit doesn't like the extra variables added, e.g., residuals)

logex1sub<-subset(logex, satjob != FALSE & life != FALSE, select=c("id", "sex", "satjob", "life"))
head(logex1sub)

#re-structure data frame into special long format
mlog1 <-mlogit.data(logex1sub, choice ="life", shape ="wide")
head(mlog1)

#inspect 
str(mlog1)

#perform model (should examine independence and multicollinearity beforehand)
mlogmodel1<-mlogit(life ~ 1|sex * satjob, data = mlog1, reflevel = 1)
mlogmodel2<-mlogit(life ~ 1|sex * satjob, data = mlog1, reflevel = 2)

#hmm...cannot obtain diagnostics due to model complexity:(
plot(mlogmodel1)

# check outliers and influential cases...hmm

mlog1$residuals<-residuals(mlogmodel1)
#mlog1$dfbeta<-dfbeta(mlogmodel1)
mlog1$leverage<-hatvalues(mlogmodel1)

densityplot(mlog1$residuals)
#hist(mlog1$dfbeta)
#densityplot(mlog1$leverage)

### residuals can be inspected, but not influential case indices???
# these could be checked in a piecewise manner...perform series of binary logistic regressions with two levels of lifestyle

#examine results
summary(mlogmodel1)
summary(mlogmodel2)

#Compute odds ratio and CIs
exp(mlogmodel2$coefficients)
exp(confint(mlogmodel2))


##################################################

# Chi-square and loglinear models

install.packages("gmodels")
install.packages("MASS")

library(gmodels)
library(MASS)

#demonstrate default settings of CrossTable
CrossTable(logex1sub$satjob, logex1sub$life, chisq = TRUE)

#suppress and add standardized residuals
CrossTable(logex1sub$satjob, logex1sub$life, fisher = TRUE, chisq = TRUE, expected = TRUE, prop.c = FALSE, prop.r = FALSE, prop.t = FALSE, prop.chisq = FALSE,  sresid = TRUE, format = "SPSS")
CrossTable(logex1sub$satjob, logex1sub$life, fisher = TRUE, chisq = TRUE, expected = TRUE, prop.c = FALSE, prop.r = FALSE, prop.t = FALSE, prop.chisq = FALSE,  asresid = TRUE, format = "SPSS")


#relations between 3 categorical variables
table(logex1sub$satjob, logex1sub$life, logex1sub$sex)
xtabs(~sex + satjob + life, data = logex1sub)

#create two subsets based on sex...to examine satjob and life for males and females separately
justmales <- subset(logex1sub, sex == "Male")
justfemales <- subset(logex1sub, sex == "Female")

#examine 2-way contingency tables separately for males and females
CrossTable(justmales$satjob, justmales$life, expected=TRUE,asresid = TRUE, prop.t=FALSE, prop.c=FALSE, prop.r = FALSE,prop.chisq=FALSE, format = "SPSS")
CrossTable(justfemales$satjob, justfemales$life, expected=TRUE,asresid = TRUE, prop.t=FALSE, prop.c=FALSE, prop.r = FALSE,prop.chisq=FALSE, format = "SPSS")

#you could also create subsets based on the other measures e.g....
#justdull = subset(logex, life =="dull")
#justroutine = subset(logex, life =="routine")
#justexciting = subset(logex, life =="exciting")

###################

#loglinear analyses

#create contingency tables for analysis
llinx<-xtabs(~ satjob + life + sex, data = logex1sub)
llinx
summary(llinx)

#perform analyses for all combinations of main effects ad interactions
mainonly<-loglm(~ satjob + life + sex, data = llinx, fit = TRUE)

nolifeint<-loglm(~ satjob + life + sex + satjob:sex, data = llinx, fit = TRUE)
nojobint<-loglm(~ satjob + life + sex + life:sex, data = llinx, fit = TRUE)
nosexint<-loglm(~ satjob + life + sex + satjob:life, data = llinx, fit = TRUE)

nosexlife<-loglm(~ satjob + life + sex + satjob:life + satjob:sex, data = llinx, fit = TRUE)
nojobsex<-loglm(~ satjob + life + sex + satjob:life + life:sex, data = llinx, fit = TRUE)
nojoblife<-loglm(~ satjob + life + sex + satjob:sex + life:sex, data = llinx, fit = TRUE)

no3way<-loglm(~ satjob + life + sex + satjob:life + satjob:sex + life:sex, data = llinx, fit = TRUE)

loglin1_sat<-loglm(~ satjob * life * sex, data = llinx, fit = TRUE)

#test models to determine most parsimonious solution...lots to test, just make sure the models are nested

anova (loglin1_sat,no3way)

#ns, so saturated model not better than model without 3-way interaction

anova (no3way, nosexlife)
anova (no3way, nojobsex)
anova (no3way, nojoblife)
#sign. satjob:life improves fit

anova (nosexlife,nosexint)
#ns, satjob:sex does not improve

anova (nojobsex,nosexint)
#ns, life:sex does not improve

anova (nosexlife, nolifeint)
#sign. satjob:life improves fit

anova (nojobsex, nojobint)
#sign. satjob:life improves fit

anova (nojoblife, nolifeint)
anova (nojoblife, nojobint)

#most parsimonious solution...satjob:life + all three main effects


#post-hoc contingency tables (same as above)
table(logex1sub$satjob, logex1sub$life, logex1sub$sex)
xtabs(~sex + satjob + life, data = logex1sub)

#create two subsets based on sex...to examine satjob and life for males and females separately
justmales <- subset(logex1sub, sex == "Male")
justfemales <- subset(logex1sub, sex == "Female")

CrossTable(justmales$satjob, justmales$life, expected=TRUE,asresid = TRUE, prop.t=FALSE, prop.c=FALSE, prop.r = FALSE,prop.chisq=FALSE, format = "SPSS")
CrossTable(justfemales$satjob, justfemales$life, expected=TRUE,asresid = TRUE, prop.t=FALSE, prop.c=FALSE, prop.r = FALSE,prop.chisq=FALSE, format = "SPSS")


#visualize
mosaicplot(loglin1_sat$fit, shade = TRUE, main = "Saturated Model")
mosaicplot(nosexint$fit, shade = TRUE, main = "Expected Values")







