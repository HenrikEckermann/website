
install.packages("car")# for Levene's and D-W tests
install.packages("pastecs")#for descriptives
install.packages("multcomp") #for Tukey comparisons
install.packages("compute.es") #for effect sizes


#Initiate packages
library(car)
library(pastecs)
library(multcomp)
library(compute.es)
library(lattice) #for density plots


setwd("C:/Users/U148154/Dropbox/Analyzing in R 2016")

id<-(1:15)
libido<-c(3,2,1,1,4,5,2,4,2,3,7,4,5,3,6)
#dose<-c(rep(1,5),rep(2,5), rep(3,5))
#dose<-factor(dose, levels = c(1:3), labels = c("Placebo", "Low Dose", "High Dose"))
dose<-gl(3,5, labels = c("Placebo", "Low Dose", "High Dose"))
viagraData<-data.frame(dose, libido)

viagraData

#Descriptives
by(viagraData$libido, viagraData$dose, stat.desc, basic =F, norm=T)

#Levene's test
leveneTest(viagraData$libido, viagraData$dose)

#Examine distributions of DV within groups
by(viagraData$libido, viagraData$dose, densityplot)
#by(viagraData$libido, viagraData$dose, hist)

#Identify/specify contrasts (default is dummy codes)
contrasts(viagraData$dose)
#contrasts(viagraData$dose)<- contr.treatment(3)

#perform ANOVA(or regression)
viagraaovModel<-aov(libido ~ dose, data = viagraData)
viagraModel<-lm(libido ~ dose, data = viagraData)

#add diagnostic variables to dataframe
viagraData$residuals<-rstandard(viagraModel)
viagraData$dfbeta<-dfbeta(viagraModel)
viagraData$leverage<-hatvalues(viagraModel)

#examine residual distribution separately for each group
by(viagraData$residuals, viagraData$dose, densityplot)

#examine outliers and influential cases
densityplotby(viagraData$dfbeta) #I encounter a problem here
hist(viagraData$dfbeta)
densityplot(viagraData$leverage)

#default diagnostic plots
plot(viagraModel)


#examine results of analyses (regression output)
summary(viagraModel)
summary.aov(viagraModel)
#summary.lm(viagraModel)

#examine results of analyses (ANOVA output)
summary(viagraaovModel)
#summary.aov(viagraModel)
summary.lm(viagraModel)

#here are the alternative coding schemes used in lecture

#zero sum (effect codes)
contrasts(viagraData$dose)<- contr.sum(3)
#planned contrasts
contrasts(viagraData$dose)<-cbind(c(-2,1,1), c(0,-1,1))
#OR
contrast1<-c(-2,1,1)
contrast2<-c(0,-1,1)
contrasts(viagraData$dose)<-cbind(contrast1, contrast2)
#polynomial
contrasts(viagraData$dose)<- contr.poly(3)


#pairwise comparisons
pairwise.t.test(viagraData$libido, viagraData$dose, p.adjust.method = "bonferroni")
pairwise.t.test(viagraData$libido, viagraData$dose, p.adjust.method = "BH")

postHocs<-glht(viagraModel, linfct = mcp(dose = "Tukey"))
summary(postHocs); confint(postHocs)


#computing effect sizes (M of 1st group, M of 2nd group, SD of 1st group, SD of 2nd, group, n of 1st group, n of 2nd group)
mes(2.2, 3.2, 1.3038405, 1.3038405, 5, 5)
mes(2.2, 5, 1.3038405, 1.5811388, 5, 5)
mes(3.2, 5, 1.3038405, 1.5811388, 5, 5)

############################################################

#ANCOVA

install.packages("effects")
install.packages("ggplot2")
install.packages("reshape")


#Initiate packages
library(effects)
library(ggplot2)
library(reshape)

#create dataframe
libido<-c(3,2,5,2,2,2,7,2,4,7,5,3,4,4,7,5,4,9,2,6,3,4,4,4,6,4,6,2,8,5)
partnerLibido<-c(4,1,5,1,2,2,7,4,5,5,3,1,2,2,6,4,2,1,3,5,4,3,3,2,0,1,3,0,1,0)
dose<-c(rep(1,9),rep(2,8), rep(3,13))
dose<-factor(dose, levels = c(1:3), labels = c("Placebo", "Low Dose", "High Dose"))
viagraData2<-data.frame(dose, libido, partnerLibido)

#examine distributions separately for each group
by(viagraData2$libido, viagraData2$dose, stat.desc, norm =T)
by(viagraData2$partnerLibido, viagraData2$dose, stat.desc, norm=T)


#change format for plotting
restructuredData<-melt(viagraData2, id = c("dose"), measured = c("libido", "partnerLibido")) 
names(restructuredData)<-c("dose", "libido_type", "libido")

boxplot <- ggplot(restructuredData, aes(dose, libido)) + geom_boxplot() + facet_wrap(~libido_type) + labs(x = "Dose", y = "Libido")
boxplot

scatter <- ggplot(viagraData2, aes(partnerLibido, libido)) + geom_point(size = 3) + geom_smooth(method = "lm", alpha = 0.1) + labs(x = "Partner's Libido", y = "Participant's Libido")
scatter

#Levene's Test
leveneTest(viagraData$libido, viagraData$dose, center = median)

#Test whether the IV and covariate are independent
checkIndependenceModel<-aov(partnerLibido ~ dose, data = viagraData)
summary(checkIndependenceModel)
summary.lm(checkIndependenceModel)

checkIndependenceModel<-lm(partnerLibido ~ dose, data = viagraData2)
summary.aov(checkIndependenceModel)

#Test homogeneity of regression assumption
hoRS<-lm(libido~partnerLibido*dose,data=viagraData2)
summary(hoRS)
#indicates violation

#visualize VIOLATION of homogeneity of regression 
scatter2 <- ggplot(viagraData2, aes(partnerLibido, libido, colour = dose)) + geom_point(aes(shape = dose), size = 3) + geom_smooth(method = "lm", aes(fill = dose), alpha = 0.1) + labs(x = "Partner's Libido", y = "Participant's Libido")
scatter2

#based on these results, partner's libido should NOT be included as a covariate...however, I proceed in order to show different types of SS 

viagraModel2a<-aov(libido~ partnerLibido + dose, data = viagraData2)
#type 1 SS as default
summary(viagraModel2a)

viagraModel2b<-aov(libido~ dose + partnerLibido, data = viagraData2)
summary(viagraModel2b)
#notice that the SS attributed to each effect differs in models 2a and 2b 

viagraModel3<-lm(libido~ partnerLibido + dose, data = viagraData2)
Anova(viagraModel3, type = "3")

viagraModel4<-lm(libido~ dose + partnerLibido, data = viagraData2)
Anova(viagraModel4, type = "2")
#notice that models 3 and 4 have identical SS attributed to each effect. This is because only main effects are specified

viagraModel6<-lm(libido~ partnerLibido * dose, data = viagraData2)
summary(viagraModel6)
Anova(viagraModel6, type = "3")
Anova(viagraModel6, type = "2")
#notice that interaction is identical in the two models, but the main effects differ

#default is dummy coding
contrasts(viagraData2$dose)

#contrasts(viagraData$dose)<-contr.helmert(3)
contrasts(viagraData$dose)<-cbind(c(-2,1,1), c(0,-1,1))
viagraModel2<-aov(libido ~ partnerLibido + dose, data = viagraData2)
Anova(viagraModel2, type="III")
summary.lm(viagraModel2)

#obtain estimated marginal means
adjustedMeans<-effect("dose", viagraModel3, se=TRUE)
summary(adjustedMeans)
adjustedMeans$se

#perform pairwise comparisons with Tukey adjustment
postHocs<-glht(viagraModel3, linfct = mcp(dose = "Tukey"))
summary(postHocs)
confint(postHocs)
