library(lubridate)
library(lattice)
library(dplyr)
   activity2 <-  Activity
   Interval<- tapply(activity2$steps,activity2$interval,mean,na.rm=TRUE,simplify=TRUE)
   activity2$steps[na]  <-Interval[as.character(activity2$interval[na])]
    activity2$date <- as.Date(activity2$date, "%Y-%m-%d")

activity2 <- activity2 %>%
    mutate(typeofday=ifelse(weekdays(activity2$date)=="Saturday"| weekdays(activity2$date)=="Sunday","Weekend","Weekday")) 

   png("plot_comparison.png")
    par(mfrow=c(1,2))
    panelplot <- aggregate(steps ~ interval + typeofday , activity2,FUN= "mean" ,na.rm=TRUE)
    xyplot(steps ~ interval | factor(typeofday),
         layout = c(1,2),
         xlab="Interval",
         ylab="Steps",
         type="l",
         lty=1,
         data=panelplot)
          dev.off()
 

 

 
 
 

 