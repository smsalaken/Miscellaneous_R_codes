# get the data
df <- data_get() # make sure you get the data here



# convert time to decimal hours, remove if not required
df$start.ct   <- as.POSIXct(paste(df$`Date Time`, df$start, sep = " "))
df$end.ct     <- as.POSIXct(paste(df$`Date Time`, df$end, sep = " "))
df$start.hour <- as.POSIXlt(df$start.ct)$hour + as.POSIXlt(df$start.ct)$min/60 + as.POSIXlt(df$start.ct)$sec/3600
df$end.hour   <- as.POSIXlt(df$end.ct)$hour + as.POSIXlt(df$end.ct)$min/60 + as.POSIXlt(df$end.ct)$sec/3600

# do this if your start time and end time is same in the df
df$endTime <- df$start.ct+3600              # add one hour to start time if this is hourly, remove if needed

library(googleVis)
datTL <- data.frame(Position='',            # if you want to see bar labels, put them here
                    Name=df$`Child Object`, # the row label for Gantt charts
                    start=df$start.ct,      # the start time
                    end=df$endTime)         # the end time

# the actual Gantt chart. If using in shiny, render via renderGvis
Timeline <- gvisTimeline(data=datTL, 
                         rowlabel="Name",
                         barlabel="Position",
                         start="start", 
                         end="end",
                         options=list(timeline="{groupByRowLabel:true}",  # put all elements for a label in a single row
                                      width='100%',                       # control the width w.r.t parent container/div
                                      height=700,                         # height of Gantt chart. Scoller appears if necessary
                                      backgroundColor='#ffd', 
                                      height=350,
                                      colors="['#cbb69d', '#603913', '#c69c6e']"))  # what colors do you want on the chart?

cat('class Timeline:', class(Timeline),'\n')                              # It should be a gvis class