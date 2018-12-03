
library(knitr)
library(dplyr)
Activity <- read.csv("activity.csv",header=TRUE)
Totalsteps <- aggregate(steps ~ date,Activity,  sum)
png("Hist_Totalsteps.png")
hist(Totalsteps$steps, col="pink",xlab = "Frequency", ylab = "steps", main = "Total steps taken each day")
dev.off()