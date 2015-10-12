
library(mice)
library(stargazer)
library(Hmisc)
library(VIM)
library(VIMGUI)
library(rms)
data(nhanes)
names(nhanes)
stargazer(nhanes, type = "text")
naclus(nhanes)
naplot(naclus(nhanes))
md.pattern(nhanes)
plot(md.pairs(nhanes))

mod <- lm(chl ~ bmi + age, nhanes)
summary(mod)

pred.chl.miss <- glm(is.na(chl) ~ bmi + age + hyp, 
                     family = binomial, data =nhanes)
summary(pred.chl.miss)

pred.bmi.miss <- glm(is.na(bmi) ~ chl + age + hyp, 
                     family = binomial, data =nhanes)
summary(pred.chl.miss)

pred.hyp.miss <- glm(is.na(hyp) ~ chl + age + bmi, 
                     family = binomial, data = nhanes)
summary(pred.hyp.miss)
