

library(texreg)
library(stargazer)
achieve <- read.csv('data/Achieve.csv')
achieve <- achieve[ ,c("geread", "gevocab", "gender")]
achieve$gender <- achieve$gender - 1
stargazer(achieve, type = 'text')
mod <- lm(geread ~ gevocab + gender, data = achieve)
screenreg(mod)

b0 <- 1.92
b1 <- .53
b2 <- .03
n <- 10000
sigma <- 1.97
set.seed(123456)
gevocab <- rnorm(n = n, mean = 4.49, sd = 2.37)

gender <- rep(0:1, n/2)

geread <- b0 + b1*gevocab + b2*gender + rnorm(n = n, mean = 0, sd = sigma )

sim.mod <- lm(geread ~ gevocab + gender)
screenreg(list(mod, sim.mod))

par(mfrow = c(1,2))
plot(geread ~ gevocab, data = achieve)
plot(geread ~ gevocab)
cor(achieve)
cor(geread, gevocab)
range(geread)



# simulate missingness ----------------------------------------------------
n = 10000
r.mcar <- 1 - rbinom(n = n, size = 1, prob = 0.25)
sum(r.mcar)

geread.mcar <- geread
geread.mcar[r.mcar==0] <- NA
sum(complete.cases(geread.mcar))
