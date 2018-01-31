library(car)
library(effects)
library(ggplot2)
library(multcomp)
library(pastecs)
library(reshape2)
library(Hmisc)

#--------Beer Goggles data----------
gogglesData<-read.csv("/Users/henrikeckermann/Documents/books/extra/field/goggles.csv", header = TRUE)
gogglesData$alcohol<-factor(gogglesData$alcohol, levels = c("None", "2 Pints", "4 Pints"))
gogglesData

#create dataframe
id<-(1:48)
gender<-gl(2, 24, labels = c("Female", "Male"))
alcohol<-gl(3, 8, 48, labels = c("None", "2 Pints", "4 Pints"))
attractiveness<-c(65,70,60,60,60,55,60,55,70,65,60,70,65,60,60,50,55,65,70,55,55,60,50,50,50,55,80,65,70,75,75,65,45,60,85,65,70,70,80,60,30,30,30,55,35,20,45,40)



gogglesData<-data.frame(id,gender, alcohol, attractiveness)

head(gogglesData)


library(ggplot2)
library(pastecs)
#inspect distributions separately for each group
by(gogglesData$attractiveness, gogglesData$gender, stat.desc, basic = F)
by(gogglesData$attractiveness, gogglesData$alcohol, stat.desc, basic = F)
by(gogglesData$attractiveness, list(gogglesData$alcohol, gogglesData$gender), stat.desc, basic = F)

#visualize... 
boxplot <- ggplot(gogglesData, aes(alcohol, attractiveness)) + geom_boxplot() + facet_wrap(~gender) + labs(x = "Alcohol Consumption", y = "Mean Attractiveness of Date (%)")
boxplot

line <- ggplot(gogglesData, aes(alcohol, attractiveness, colour = gender)) + stat_summary(fun.y = mean, geom = "point") + stat_summary(fun.y = mean, geom = "line", aes(group= gender)) + stat_summary(fun.data = mean_cl_boot, geom = "errorbar", width = 0.2) + labs(x = "Alcohol Consumption", y = "Mean Attractiveness of Date (%)", colour = "Gender") 
line

bar <- ggplot(gogglesData, aes(alcohol, attractiveness, fill = gender)) + stat_summary(fun.y = mean, geom = "bar", position="dodge") + stat_summary(fun.data = mean_cl_normal, geom = "errorbar", position=position_dodge(width=0.90), width = 0.2) + labs(x = "Alcohol Consumption", y = "Mean Attractiveness of Date (%)", fill = "Gender")
bar

library(car)
#test homogeneity...Levene's Test
leveneTest(gogglesData$attractiveness, gogglesData$gender)
leveneTest(gogglesData$attractiveness, gogglesData$alcohol)
leveneTest(gogglesData$attractiveness, interaction(gogglesData$alcohol, gogglesData$gender))

#check contrasts...should be dummy codes
contrasts(gogglesData$alcohol)
contrasts(gogglesData$gender)

gogglesModel<-lm(attractiveness ~ gender*alcohol, data = gogglesData)
summary(gogglesModel)
summary.aov(gogglesModel)#type I
Anova(gogglesModel, type="II")
Anova(gogglesModel, type="III")

#set orthogonal contrasts
contrasts(gogglesData$alcohol)<-cbind(c(-2, 1, 1), c(0, -1, 1))
contrasts(gogglesData$gender)<-c(-1, 1)

#check contrasts
contrasts(gogglesData$alcohol)
contrasts(gogglesData$gender)

#perform ANOVA
#gogglesModel<-aov(attractiveness ~ gender+alcohol+gender:alcohol, data = gogglesData)
gogglesModel2<-aov(attractiveness ~ gender*alcohol, data = gogglesData)
Anova(gogglesModel2, type="III")

plot(gogglesModel)

#################################

#here is an alternative using the afex package...which you will see again in the next course

library(afex)

#googleMod_opt <- aov_4(attractiveness ~ gender*alcohol, data = gogglesData, type = 3, observed = c("gender", "alcohol"))
googleMod_opt <- aov_ez("id", "attractiveness", data = gogglesData, between = c("gender", "alcohol"))
summary(googleMod_opt)

#should be type 3 SS, but it doesn't seem to be????

lsmeans(googleMod_opt, c("gender", "alcohol"), contr = "pairwise")

#################################
library(effects)
genderEffect<-effect("gender", gogglesModel2)
summary(genderEffect)
alcoholEffect<-effect("alcohol", gogglesModel2)
summary(alcoholEffect)
interactionMeans<-allEffects(gogglesModel2)
summary(interactionMeans)

summary.lm(gogglesModel2)

pairwise.t.test(gogglesData$attractiveness, gogglesData$alcohol, p.adjust.method = "bonferroni")
pairwise.t.test(gogglesData$attractiveness, gogglesData$alcohol, p.adjust.method = "BH")

postHocs<-glht(gogglesModel2, linfct = mcp(alcohol = "Tukey"))
summary(postHocs)
confint(postHocs)


#################################################################################

#REPEATED-MEASURES

#Enter data by hand
participant<-gl(20, 9, labels = c("P01", "P02", "P03", "P04", "P05", "P06", "P07", "P08", "P09", "P10", "P11", "P12", "P13", "P14", "P15", "P16", "P17", "P18", "P19", "P20" ))
drink<-gl(3, 3, 180, labels = c("Beer", "Wine", "Water"))
imagery<-gl(3, 1, 180, labels = c("Positive", "Negative", "Neutral"))
groups<-gl(9, 1, 180, labels = c("beerpos", "beerneg", "beerneut", "winepos", "wineneg", "wineneut", "waterpos", "waterneg", "waterneut"))
attitude<-c(1, 6, 5, 38, -5, 4, 10, -14, -2, 26, 27, 27, 23, -15, 14, 21, -6, 0, 1, -19, -10, 28, -13, 13, 33, -2, 9, 7, -18, 6, 26, -16, 19, 23, -17, 5, 22, -8, 4, 34, -23, 14, 21, -19, 0, 30, -6, 3, 32, -22, 21, 17, -11, 4, 40, -6, 0, 24, -9, 19, 15, -10, 2, 15, -9, 4, 29, -18, 7, 13, -17, 8, 20, -17, 9, 30, -17, 12, 16, -4, 10, 9, -12, -5, 24, -15, 18, 17, -4, 8, 14, -11, 7, 34, -14, 20, 19, -1, 12, 43, 30, 8, 20, -12, 4, 9, -10, -13, 15, -6, 13, 23, -15, 15, 29, -1, 10, 15, 15, 12, 20, -15, 6, 6, -16, 1, 40, 30, 19, 28, -4, 0, 20, -10, 2, 8, 12, 8, 11, -2, 6, 27, 5, -5, 17, 17, 15, 17, -6, 6, 9, -6, -13, 30, 21, 21, 15, -2, 16, 19, -20, 3, 34, 23, 28, 27, -7, 7, 12, -12, 2, 34, 20, 26, 24, -10, 12, 12, -9, 4)

longAttitude<-data.frame(participant, drink, imagery, groups, attitude)

longAttitude

#Graphs of main effects and interaction
attitudeBoxplot <- ggplot(longAttitude, aes(drink, attitude)) + 
  geom_boxplot() + facet_wrap(~imagery, nrow = 1) + labs(x = "Type of Drink", y = "Mean Preference Score")
attitudeBoxplot


drinkBar <- ggplot(longAttitude, aes(drink, attitude)) + 
 stat_summary(fun.y = mean, geom = "bar", fill = "White", colour = "Black") + stat_summary(fun.data = mean_cl_boot, geom = "pointrange") + labs(x = "Type of Drink", y = "Mean Attitude") 
drinkBar

imageryBar <- ggplot(longAttitude, aes(imagery, attitude)) + 
 stat_summary(fun.y = mean, geom = "bar", fill = "White", colour = "Black") + stat_summary(fun.data = mean_cl_boot, geom = "pointrange") + labs(x = "Type of Imagery", y = "Mean Attitude") 
imageryBar

attitudeInt <- ggplot(longAttitude, aes(drink, attitude, colour = imagery)) + 
 stat_summary(fun.y = mean, geom = "point") + stat_summary(fun.y = mean, geom = "line", aes(group= imagery)) + stat_summary(fun.data = mean_cl_boot, geom = "errorbar", width = 0.2) + labs(x = "Type of Drink", y = "Mean Attitude", colour = "Type of Imagery") 
attitudeInt

barInt <- ggplot(longAttitude, aes(imagery, attitude, fill = drink)) + stat_summary(fun.y = mean, geom = "bar", position="dodge") + stat_summary(fun.data = mean_cl_normal, geom = "errorbar", position=position_dodge(width=0.90), width = 0.2) + labs(x = "Imagery", y = "Mean Attitude", fill = "Drink")
barInt
#drink as the moderator

barInt2 <- ggplot(longAttitude, aes(drink, attitude, fill = imagery)) + stat_summary(fun.y = mean, geom = "bar", position="dodge") + stat_summary(fun.data = mean_cl_normal, geom = "errorbar", position=position_dodge(width=0.90), width = 0.2) + labs(x = "Drink", y = "Mean Attitude", fill = "Imagery")
barInt2
#imagery as the moderator

#################################

#describe data separately for each condition and for each within-participant effect

by(longAttitude$attitude, list(longAttitude$drink, longAttitude$imagery), stat.desc, basic = FALSE)
by(longAttitude$attitude, longAttitude$drink, stat.desc, basic = FALSE)
by(longAttitude$attitude, longAttitude$imagery, stat.desc, basic = FALSE)


#test homogeneity of each condition...Levene's Test
leveneTest(longAttitude$attitude, longAttitude$drink, center = median)
leveneTest(longAttitude$attitude, longAttitude$imagery, center = median)
leveneTest(longAttitude$attitude, interaction(longAttitude$drink, longAttitude$imagery), center = median)

#setting contrasts
WaterVbeer<-c(.5, 0, -.5)
WaterVwine<-c(0, .5, -.5)
NeutralVpos<-c(.5, 0, -.5)
NeutralVneg<-c(0, .5, -.5)


contrasts(longAttitude$drink)<-cbind(WaterVbeer, WaterVwine)
contrasts(longAttitude$imagery)<-cbind(NeutralVneg, NeutralVpos)

#perform RM ANOVA
install.packages("ez")
library(ez)

attitudeModel<-ezANOVA(data = longAttitude, dv = .(attitude), wid = .(participant),  within = .(drink, imagery), type = 3, detailed = TRUE)
attitudeModel

#post-hoc comparisons
pairwise.t.test(longAttitude$attitude, longAttitude$groups, paired = TRUE, p.adjust.method = "bonferroni")


#################################

#here is an alternative using the afex package...which you will see again in the next course

library(afex)

googleMod_opt2 <- aov_ez("participant", "attitude", data = longAttitude, within = c("drink", "imagery"))
summary(googleMod_opt2)

lsmeans(googleMod_opt2, c("drink", "imagery"), contr = "pairwise")
class(attitudeModel)
class(googleMod_opt2)