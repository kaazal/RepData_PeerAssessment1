library(dplyr)
Timeseries <- aggregate(steps ~ interval,Activity,FUN = sum)
maxsteps <- Timeseries$interval[which.max(Timeseries$steps)]
print(paste0("Max Steps : ", maxsteps))
