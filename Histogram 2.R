getwd()
Activity <- read.csv("activity.csv",header=TRUE)
Totalsteps2 <- aggregate(steps ~ date,activity2,  sum)
hist(Totalsteps2$steps, col="red",xlab = "NUMBER OF STEPS", ylab = "Interval", main = "Total steps taken each day")
