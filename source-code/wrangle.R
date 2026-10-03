# Sibanie, Biruktawit

####### INST314 -- HW03: Data Wrangling with Fast Food Data ######

### Question 0: Setup ####

# Clean up the working environment so old objects don't foul up the works
rm(list = ls())

# Load the tidyverse package (includes dplyr, ggplot2, etc.)
library(tidyverse)


### Question 1: Fast food ####

## Part A ####
# Read in fastfood.csv as a data frame named fastfoodData, treating character
# strings as factors. Then use summary() to quickly inspect the variables.
fastfoodData <- read.csv("datasets/fastfood.csv", stringsAsFactors = TRUE)

summary(fastfoodData)


## Part B ####
# Use filter() to create a smaller dataframe named dqMcdData that includes
# observations from Dairy Queen OR McDonalds.
# (We want level A OR level B, so we use the | operator.)
dqMcdData <- fastfoodData %>%
  filter(restaurant == "Dairy Queen" | restaurant == "Mcdonalds")


## Part C ####
# With a SINGLE LONG COMMAND, calculate summary statistics for protein for
# Dairy Queen and McDonald's. Output should be a 2 row x 7 column tibble.
dqMcdData %>%
  group_by(restaurant) %>%
  summarize(
    mean   = mean(protein, na.rm = TRUE),
    median = median(protein, na.rm = TRUE),
    sd     = sd(protein, na.rm = TRUE),
    IQR    = IQR(protein, na.rm = TRUE),
    min    = min(protein, na.rm = TRUE),
    max    = max(protein, na.rm = TRUE)
  )


## Part D ####
# Draw boxplots of protein for Dairy Queen and McDonald's on the same graph.
ggplot(dqMcdData, aes(x = restaurant, y = protein)) +
  geom_boxplot() +
  xlab("Restaurant") +
  ylab("Protein (g)") +
  theme_minimal()


## Part E ####
# Which restaurant has a more skewed distribution of protein?
#
# ANSWER: McDonald's has the more skewed (strongly right-skewed) distribution
# of protein. Dairy Queen's protein is close to symmetric by comparison.
#
# Reasoning (using specific numbers from the Part C summary table and the
# Part D boxplots):
#
# 1. Mean vs. median: For McDonald's the mean protein (40.3 g) is far above the
#    median (33 g) -- a gap of about 7 g that pulls the average upward and is a
#    classic sign of right skew. For Dairy Queen the mean (24.8 g) and median
#    (23 g) are nearly equal (gap of under 2 g), indicating a roughly symmetric
#    distribution.
#
# 2. Maximum vs. the box (long upper tail / outliers): McDonald's has a maximum
#    of 186 g of protein, which sits enormously far above its box (median 33 g,
#    IQR 21 g). On the boxplot this shows up as a very long upper whisker with
#    high outlier points. Dairy Queen's maximum is only 49 g, close to its box,
#    so it has no comparably long tail.
#
# 3. Spread (SD and range): McDonald's standard deviation (29.5 g) is about
#    2.5 times Dairy Queen's (11.5 g), and McDonald's range is 7-186 g (179 g)
#    versus Dairy Queen's 1-49 g (48 g). That much larger, lopsided spread --
#    driven by a few very high-protein McDonald's items -- confirms McDonald's
#    is the more skewed of the two.
