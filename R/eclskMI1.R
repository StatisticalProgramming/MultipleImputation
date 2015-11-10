#**************************************************************************
# Title: eclskMI.5.5.1.R ------------------------------------------------------
# Author: William Murrah
# Description: Script for use on UVA Linux Cluster for multiple imputation
#              of ECLSK for Relative Importance paper. This code is adapted
#              from the 'MultipleImputationCrossover.R' script. Prepared 
#              using mice version 2.18 (see sessionInfo at end of code).
# 
# Version History ---------------------------------------------------------
# 2014.01.24: File created
# 2014.02.09: Forked code from eclskMI1 to this version, 5.3a. with same
#             seed number as original.
# 2014.02.18: Forked v5.4.1-5
# 2015.04.17: Forked v5.4.1 This version was used for Developmental 
#             Psychology revision 1.
#**************************************************************************

# Load R Packages and Data ------------------------------------------------
library(mice)
# Stef van Buuren, Karin Groothuis-Oudshoorn (2011). mice: Multivariate
#    Imputation by Chained Equations in R. Journal of Statistical Software,
#    45(3), 1-67. URL http://www.jstatsoft.org/v45/i03/.

# Load data saved for MI on Linux Cluster.
load('eclskMI.Rdata')
# remove 15 cases missing on key childhood characteristisc
eclskMI <- eclskMI[!is.na(eclskMI$race), ]
# Set MI Specifications ---------------------------------------------------
M  <- 10          # Number of imputations
Maxit <- 20      # Number of iterations
Seed <- 20140211 # Pseudo-random number seed for replicability
drop <- c('id')
df <- eclskMI[ , !(names(eclskMI) %in% drop)]   # Dataframe to use
rm(eclskMI, drop)
# Model setup -------------------------------------------------------------
# Run model without conducting imputations to obtain the 
# PredictorMatrix I call 'pred'.
imp0 <- mice(df, maxit=0)
Pred <- imp0$pred

# Modify 'pred' matrix ----------------------------------------------------
# The code in this section modifies the preditor matrix to modify which
# variables are used in the imputation models for each of the variables
# being imputed.

# remove daded from the model imputing momed.
Pred["momed", "daded"] <- 0

Pred[c("t2learn", "t2contro", "t2interp", 
       "t2extern", "t2intern"),
     c("t2learn", "t2contro", "t2interp", 
         "t2extern", "t2intern")] <- 0 

Pred[ , c("c2read", "c2math", "c2genk", 
          "c4read", "c4math", "c4genk", 
          "c5read", "c5math", "c5sci", 
          "c6read", "c6math", "c6sci", 
          "c7read", "c7math", "c7sci")]  <- 0

# time 2: only time 1 (t1) variable used to impute
# This is already set in the Pred matrix.

# time 4: only t1 and t2 used to impute
Pred[c("c4read", "c4math", "c4genk"),  
     c("c2read", "c2math", "c2genk")]<- 1

# time 5: only t1 and t4 used to impute
Pred[c("c5read", "c5math", "c5sci"),   
     c("c4read", "c4math", "c4genk")]<- 1

# time 6: only t1 and t5 used to impute
Pred[c("c6read", "c6math", "c6sci"),   
     c("c5read", "c5math", "c5sci")]<- 1

# time 7: pnly t1 and t6 used to impute
Pred[c("c7read", "c7math", "c7sci"),   
     c("c6read", "c6math", "c6sci")]<- 1

# Also include other academic skills at the same time point as predictors
# time 2
Pred['c2read', c('c2math', 'c2genk')] <- 1 
Pred['c2math', c('c2read', 'c2genk')] <- 1
Pred['c2genk', c('c2math', 'c2read')] <- 1

# time 4
Pred['c4read', c('c4math', 'c4genk')] <- 1 
Pred['c4math', c('c4read', 'c4genk')] <- 1
Pred['c4genk', c('c4math', 'c4read')] <- 1

# time 5
Pred['c5read', c('c5math', 'c5sci')] <- 1 
Pred['c5math', c('c5read', 'c5sci')] <- 1
Pred['c5sci', c('c5math', 'c5read')] <- 1

# time 6
Pred['c6read', c('c6math', 'c6sci')] <- 1 
Pred['c6math', c('c6read', 'c6sci')] <- 1
Pred['c6sci', c('c6math', 'c6read')] <- 1

# time 7
Pred['c7read', c('c7math', 'c7sci')] <- 1 
Pred['c7math', c('c7read', 'c7sci')] <- 1
Pred['c7sci', c('c7math', 'c7read')] <- 1

# Run Multiple Imputation -------------------------------------------------

eclskImp1 <- mice(df, m=M, print=TRUE, seed=Seed, 
                  predictorMatrix=Pred, maxit=Maxit)
#plot(eclskImp1)
#densityplot(eclskImp1)
save(eclskImp1, file='eclskImp1.Rdata')

# END ---------------------------------------------------------------------




