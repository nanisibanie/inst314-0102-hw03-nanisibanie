####### INST314 -- 03 data wrangling #####

### Cleaning workspace and loading packages ####
# Before anything else, verify that your environment is totally clear.
# This is important, because old objects can foul up the works
# Clean up the working environment
rm(list = ls())

# Load the package(s).  You will need to include which packages should be loaded at
# the beginning of every script.  The tidyverse is actually a meta-package
# and includes the package dplyr, the package ggplot2, and many others.

library(tidyverse)

### Introduction to Data Wrangling ####

# Some define statistics as the field that focuses on turning information into
# knowledge.
# The first step in that process is to summarize and describe the raw information
# -- some of which we have done in earlier labs when we estimated the center and
# spread of numerical variables and when we visualized their distribution with
# box plots and histograms.

# First off we explore flights, specifically a random sample of domestic
# flights that departed from the three major New York City airports in 2013.

# Since this is a large data set, along the way you will also learn the
# indispensable skills of data processing and subsetting.

### Reading in data from files in your course repository ####

# There are two major reasons that your instructor forces you to use GitHub and
# version control with RStudio.
# Reason #1: this is how real people work together on data science projects
# Reason #2: since your instructor provides all of your datasets *in the
# assignment repository* you can use a simple file path that assumes your
# working directory is set to your course repository.

# ALWAYS START YOUR WORK BY OPENING THE .Rproj file.  You will know you have
# opened it correctly if you see the repository name (in this case something like
# hw03-YourGithubName) next to the little blue cube icon in the
# upper left corner.  If you see anything else, shut it all down,
# find your confidence-intervals.Rproj file and open it.


# The Bureau of Transportation Statistics (BTS) is a statistical agency that is a
# part of the Research and Innovative Technology Administration (RITA).
# As its name implies, BTS collects and makes transportation data available, such
# as the flights data we will be working with in this lab.

# We are going to read in the dataframe and call it nycflightsData.
nycflightsData <- read.csv("datasets/nycflights.csv", stringsAsFactors = TRUE)

# You can use glimpse() or summary() to take a quick look at your data
glimpse(nycflightsData)
summary(nycflightsData)
# You can also look at the Environment tab in the upper right pane of RStudio
# If you click on the blue triangle next to nycflightsData, it shows the same
# information as glimpse

### filter(), or How to work with a subset of your observations ####

# If you want to visualize only delays of flights headed to Los Angeles, you
# need to first `filter` the data for flights with that destination
# (`dest == "LAX"`) and then make a histogram of the departure delays of only
# those flights.

# The way this works is that you first specify your data frame, nycflightsData, and
# then put in a %>% pipe operator.  You could read this as "start with
# dataframe nycflightsData and then apply this function....

# Pipes can be useful when you want to do a series of manipulations to a
# single data frame.

laxFlightsData <- nycflightsData %>%
  filter(dest == "LAX")

ggplot(data = laxFlightsData, aes(x = dep_delay)) +
  geom_histogram()

# Let's decipher these two commands above (OK, so it might look like four lines,
# but the first two physical lines of code are actually part of the same
# command. It's common to add a break to a new line after the pipe operator `%>%`
# to help readability).

# So translated into English, we have:
# Command 1: Take the nycflightsData data frame, filter for flights whose
# destination is LAX, and save the result as a new data frame called
# laxFlightsData.

# *Note* == means "if it's equal to".

# LAX is in quotation marks since it is a character string.  I can't tell you
# how many times I forget the " " marks and then spend 20 minutes using trial
# and error to fix my broken code. Pay attention to " " marks.

# Command 2: Basically the same ggplot() call from earlier for making a
# histogram, except that it uses the smaller data frame for flights headed to
# LAX instead of all flights, and so you don't need to mess with the x-axis.

### Side note: logical operators ####
# **Logical operators:** Filtering for certain observations (e.g. flights from
# a particular airport) is often of interest in data frames where we might want
# to examine observations with certain characteristics separately from the rest
# of the data.

# To do so, you can use the filter() function and a series of
# **logical operators**.
# The most commonly used logical operators for data analysis are as follows:

#   == means "equal to"
#   != means "not equal to"
#   > or < means "greater than" or "less than"
#   >= or <= means "greater than or equal to" or "less than or equal to"

### %>% or Using pipes and summarize to simplify your life ####

# Remember in previous exercises how TEDIOUS it was to cut and paste over and
# over to get mean and median and other summary statistics?

# Well, using the function summarize can shorten that up a little bit.

# Suppose we want the mean, median, standard deviation, and IQR of delay times
# for flights going to LAX.  And what the heck, we'll get the sample size too.

laxFlightsData %>%
  summarize(mean_dd   = mean(dep_delay),
            median_dd = median(dep_delay),
            sd_dd = sd(dep_delay),
            iqr_dd = IQR(dep_delay),
            n_dd = n(),
            min_dd = min(dep_delay),
            max_dd = max(dep_delay)
  )

# Note that in the summarize() function you created a list of seven different
# numerical summaries that you were interested in.
# The names of these elements are user defined, like mean_dd, median_dd etc,
# and you can customize these names as you like (just don't use spaces in your
# names).

# Calculating these summary statistics also requires that you know the
# relevant functions like mean(), median(), sd(), IQR().

# Note that n() reports the sample size AND DOES NOT HAVE A VARIABLE INSIDE ()

# Common sources of error include, missing commas, too many or too few end
# end parentheses, putting something in n().  Putting parts of the command on
# different lines can help you keep track of this kind of thing, but it is just
# stylistic

### '==' and |  or Filter based on multiple criteria ####
# You can also filter based on multiple criteria.
# Suppose you are interested in flights headed to San Francisco (SFO) in
# February:

sfoFebFlightsData <- nycflightsData %>%
  filter(dest == "SFO", month == 2)

# Note that you can separate the conditions using commas if you want flights
# that are both headed to SFO **and** in February.
# If you are interested in either flights headed to SFO **or** in February,
# you can use the | instead of the comma.

### group_by() is your friend ####

# Another useful technique is quickly calculating summary statistics for various
# groups in your data frame.
# For example, we can modify the above command using the group_by() function
# to get the same summary stats for each origin airport:

sfoFebFlightsData %>%
  group_by(origin) %>%
  summarize(mean_dd   = mean(dep_delay),
            median_dd = median(dep_delay),
            sd_dd = sd(dep_delay),
            iqr_dd = IQR(dep_delay),
            n_dd = n(),
            min_dd = min(dep_delay),
            max_dd = max(dep_delay)
  )

# Here, we first grouped the data by `origin` and then calculated the summary
# stats. Situations like this is where the pipe operator %>% starts to shine!

