
## Remember to set the working directory first
## It should have "household_power_consumption.txt"

###################################
###################################
## Note: this section is repeated in all four plotting scripts
## This section of code reads the data in an efficient manner
## The approach is to retrieve the first and last lines needed by reading through the text file using grep
## Using those values, only the relevant lines are read with read.table()


## Open a conenction to the file
data_on_disk <- file("household_power_consumption.txt", open="rt")



## The first iteration of our while loops will always run
## Therefore, we nominal start with minue one skipped lines
## And zero observations to read in
skipped_lines <- -1
nobs <- 0 

## grepl reads through the text file n=1 line at a time
## skipped_lines gets counted up, one for each line not on our date
## Until the loop hits a line with our start date
start_date <- FALSE
while (!start_date) {
   
   skipped_lines <- skipped_lines + 1
   
   start_date <- grepl("1/2/2007", readLines(data_on_disk,n=1))
   
}

## grepl continues reading though the text file
## nobs counts our number of observations
## Until the loop hits a line with our end date
## (Note: the end date is the first day we do NOT want to include)
end_date <- FALSE
while (!end_date) {
   nobs <- nobs + 1
   
   end_date <- grepl("3/2/2007", readLines(data_on_disk,n=1))
   
}

## Read in only the lines corresponding to our desired dates
data <- read.table("household_power_consumption.txt", 
                   header = FALSE,
                   sep = ";",
                   stringsAsFactors=FALSE,
                   skip=skipped_lines,
                   nrows= nobs)


## Since we skipped lines above, we have to read in our header separately
header <- read.table("household_power_consumption.txt", 
                     header = FALSE,
                     sep = ";",
                     nrows=1)
colnames(data) <- unlist(header)


## This new variable codes the R formatted date & time
data$DateTime <- strptime(paste(data$Date, data$Time, sep=""), format="%d/%m/%Y%H:%M:%S")


## Clean up the global environment
rm(nobs, end_date, start_date, data_on_disk, skipped_lines, header)

###################################
###################################//



## Send a histogram plot to the plot1.png file
png("plot1.png")

hist(data$Global_active_power,
     col = "Red",
     main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)"
     )

dev.off()