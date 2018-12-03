---
title: "Reproducible  Research Project 1"
author: "Kaazal"
date: "2 December 2018"
output: 
  html_document:
    keep_md: true
---

#DATASET- Activity monitoring data
The variables included in this dataset are:

steps: Number of steps taking in a 5-minute interval (missing values are coded as NA)

date:  The date on which the measurement was taken in YYYY-MM-DD format

interval: Identifier for the 5-minute interval in which measurement was taken

The dataset is stored in a comma-separated-value (CSV) file and there are a total of 17,568 observations in this dataset.

*LOADING AND PROCESSING DATA

 1.Load the data and read
 
 
 ```r
      #loading the packages 
      library(knitr)
      fileUrl <- ("https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip")
      download.file(fileUrl,destfile="activity.zip")
      unzip("activity.zip")
      Activity <- read.csv("activity.csv",header=TRUE)
 ```
 2.Process Data 
 
 
 ```r
      names(Activity)
 ```
 
 ```
 ## [1] "steps"    "date"     "interval"
 ```
 
 ```r
      dim(Activity)
 ```
 
 ```
 ## [1] 17568     3
 ```
 
 ```r
      str(Activity)
 ```
 
 ```
 ## 'data.frame':	17568 obs. of  3 variables:
 ##  $ steps   : int  NA NA NA NA NA NA NA NA NA NA ...
 ##  $ date    : Factor w/ 61 levels "2012-10-01","2012-10-02",..: 1 1 1 1 1 1 1 1 1 1 ...
 ##  $ interval: int  0 5 10 15 20 25 30 35 40 45 ...
 ```
   
*HISTOGRAM OF TOTAL NUMBER OF STEPS TAKEN

1.Total steps taken
 
 
 ```r
      library(dplyr)
 ```
 
 ```
 ## 
 ## Attaching package: 'dplyr'
 ```
 
 ```
 ## The following objects are masked from 'package:stats':
 ## 
 ##     filter, lag
 ```
 
 ```
 ## The following objects are masked from 'package:base':
 ## 
 ##     intersect, setdiff, setequal, union
 ```
 
 ```r
      #read the data
      Activity <- read.csv("activity.csv",header=TRUE)
      #sum of the total steps taken
      Totalsteps <- aggregate(steps ~ date,Activity,  sum)
 ```
                                              
 2.Difference between barplot and histogram
                                           
 
 ```r
       # The Difference Between Bar Charts and Histograms. Here is the main difference between bar charts and histograms. With bar charts, each column 
       # represents a group defined by a categorical variable; and with histograms, each column represents a group defined by a continuous, quantitative  
       # variable.
       
       hist(Totalsteps$steps, col="pink",xlab = "Frequency", ylab = "steps", main = "Total steps taken each day")
 ```
 
 ![](PA1_template_files/figure-html/unnamed-chunk-4-1.png)<!-- -->
                                                                                                        
 3.Mean and Median steps taken per each day 
  
 
 ```r
       Totalsteps <- aggregate(steps ~ date,Activity,  sum)
       mean <- mean(Totalsteps$steps)
       print(paste0("Mean : ", mean))
 ```
 
 ```
 ## [1] "Mean : 10766.1886792453"
 ```
 
 ```r
       median <- median(Totalsteps$steps)
       print(paste0("Median : ", median))
 ```
 
 ```
 ## [1] "Median : 10765"
 ```
                                                  
 *AVERAGE DAILY ACTIVITY PATTERN                                   
                                      
 1.Timeseries plot of the average number of steps taken
                                      
 
 ```r
      #calculate steps by interval
       Timeseries <- aggregate(steps ~ interval,Activity,FUN = sum)
       plot(Timeseries$interval,Timeseries$steps,xlab = "Interval", ylab = "Total steps",type="l",lwd = 2,col="cyan",main="Total steps of all days at 5 in           interval")
 ```
 
 ![](PA1_template_files/figure-html/unnamed-chunk-6-1.png)<!-- -->
            
 2.The 5-minute interval that, on average, contains the maximum number of steps
 
 
 ```r
        #total steps by interval
        Timeseries <- aggregate(steps ~ interval,Activity,FUN = sum)
        #using which.max (function)
        maxsteps <- Timeseries$interval[which.max(Timeseries$steps)]
        print(paste0("Maxsteps : ", maxsteps))
 ```
 
 ```
 ## [1] "Maxsteps : 835"
 ```
*IMPUTED MISSING VALUES

 1.TOTAL NUMBER OF MISSING VALUES  

     
     ```r
       # Total number of  of NA values
       sum(is.na(Activity$steps))
     ```
     
     ```
     ## [1] 2304
     ```
                                 
2.   FILLING THE MISSING VALUES WITH MEAN

     
     ```r
       activity2 <-  Activity
       na <- is.na(activity2$steps)
       Interval<- tapply(activity2$steps,activity2$interval,mean,na.rm=TRUE,simplify=TRUE)
     ```
    
3.NEW DATASET WITH MISSING DATA FILLED
                                                                        
 
 ```r
        activity2$steps[na]  <-Interval[as.character(activity2$interval[na])]
 ```
                                                             
4.Histogram of the total number of steps taken each day after missing values are imputed

 
 ```r
         Activity <- read.csv("activity.csv",header=TRUE)
         Totalsteps2 <- aggregate(steps ~ date,activity2,  sum)
         hist(Totalsteps2$steps, col="red",xlab = "NUMBER OF STEPS", ylab = "Interval", main = "Total steps taken each day")
 ```
 
 ![](PA1_template_files/figure-html/unnamed-chunk-11-1.png)<!-- -->
                                                                                                       
*Panel plot comparing the average number of steps taken per 5-minute interval across weekdays and weekends

1.Creating new factor variable in dataset 
2.plot Comparision with 5 minute interval across weekdays and weekends

 
 ```r
    library(lubridate)
 ```
 
 ```
 ## 
 ## Attaching package: 'lubridate'
 ```
 
 ```
 ## The following object is masked from 'package:base':
 ## 
 ##     date
 ```
 
 ```r
    library(lattice)
    library(dplyr)
    activity2 <-  Activity
    Interval<- tapply(activity2$steps,activity2$interval,mean,na.rm=TRUE,simplify=TRUE)
    activity2$steps[na]  <-Interval[as.character(activity2$interval[na])]
    activity2$date <- as.Date(activity2$date, "%Y-%m-%d")
 
    activity2 <- activity2 %>%
    mutate(typeofday=ifelse(weekdays(activity2$date)=="Saturday"| weekdays(activity2$date)=="Sunday","Weekend","Weekday")) 
 
  
    par(mfrow=c(1,2))
    panelplot <- aggregate(steps ~ interval + typeofday , activity2,FUN= "mean" ,na.rm=TRUE)
    xyplot(steps ~ interval | factor(typeofday),
         layout = c(1,2),
         xlab="Interval",
         ylab="Steps",
         type="l",
         lty=1,
         data=panelplot)
 ```
 
 ![](PA1_template_files/figure-html/unnamed-chunk-12-1.png)<!-- -->


    

      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
   
