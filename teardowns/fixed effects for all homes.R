# install.packages("plm")
# install.packages("lmtest")
# install.packages("sandwich")
library(readr)
library(readxl)
library(lmtest)
library(plm)
library(sandwich)

regression <- read_csv("Desktop/Berger Bayer Teardowns/Zillow/regression_total.csv");

model_fe1 <- plm(LogPrice ~ Q4 + Q5 + Q6 + Q7 + Q8 + Q9 + 
                   Q10 + Q11 + Q12 + Q13 + Q14 + Q15 + Q16 + Q17 + Q18 + Q19 + 
                   Q20 + Q21 + Q22 + Q23 + Q24 + Q25 + Q26 + Q27 + Q28 + Q29 + 
                   Q30 + Q31 + Q32 + Q33 + Q34 + Q35 + Q36 + Q37 + Q38 + Q39 + 
                   Q40 + Q41 + Q42 + Q43 + Q44 + Q45,
                 data = regression,
                 index = c("OBJECT_ID"),
                 model = "within")

# coefficients of model
model_fe1

# normalize and plot
plot(4:45, coef(model_fe1), xlab = "Quarter since 2005", ylab = "percent increase in sale price")
plot(4:45, coef(model_fe1) - coef(model_fe1)[1], xlab = "Quarter since 2005", ylab = "percent increase in sale price")