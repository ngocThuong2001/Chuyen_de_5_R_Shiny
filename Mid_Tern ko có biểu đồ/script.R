rm(list = ls()) #removes all variables stored previously
library(Hmisc) #import Hmics library
data <- read.csv("D:/Thuong19it5/Chuyen_de/Mid_Tern/dataset/COVID19_line_list_data.csv")
describe(data) #hmisc command

#Cleaned up death column
data$death_dummy <- as.integer(data$death != 0)

#death rate
sum(data$death_dummy) / nrow(data)

#AGE
#claim: people who die are older
dead = subset(data, death_dummy == 1)
alive = subset(data, death_dummy == 0)
mean(dead$age, na.rm = TRUE)
mean(alive$age, na.rm = TRUE)

#is this statistically significant?
t.test(alive$age, dead$age, alternative = "two.sided", conf.level = 0.99)
#normally, if p-value 0.05, we reject null hypothesis
#here, p-value ~ 0, so we reject the null hypothesis and 
#conclude that this is statistically  significant

#GENDER
#claim: people who die are older
men = subset(data, gender == "male")
women = subset(data, gender == "female")
mean(men$death_dummy, na.rm = TRUE)  #8.46%
mean(women$death_dummy, na.rm = TRUE)  #3.66%

#is this statistically significant?
t.test(men$death_dummy, women$death_dummy, alternative = "two.sided", conf.level = 0.99)
#normally, if p-value 0.05, we reject null hypothesis
#here, p-value ~ 0, so we reject the null hypothesis and 
#conclude that this is statistically  significant
#99% confidence: men have from 0.8% -> 8.8% higher change
#of dying
#p-value = 0.002 < 0.05, so this is statistically
#significant


