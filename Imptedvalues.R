numberofmissingvalues <- sum(is.na(Activity$steps))
activity2 <-  Activity
na <- is.na(activity2$steps)
Interval<- tapply(activity2$steps,activity2$interval,mean,na.rm=TRUE,simplify=TRUE)

activity2$steps[na]  <-Interval[as.character(activity2$interval[na])]
print(paste0("Number Of Missing Values : ", numberofmissingvalues))
