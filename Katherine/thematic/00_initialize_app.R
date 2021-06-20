### ----------------------------------------------
### ----------------------------------------------
### This script loads and wrangles data
### CSV spreadsheets of the data we want to
### visualize
### ----------------------------------------------
### ----------------------------------------------

### Load Packages -------------------------

library(shiny)
library(ggplot2)
library(ggridges)
library(dplyr)
library(shiny)
library(thematic) #install.packages("thematic")
library(bslib) #install.packages("bslib")

# Import and clean data  ----------------------------------------

# Load dataset
eruptions <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-05-12/eruptions.csv')

# remove NAs in variables we care about
eruptions <- eruptions[-which(is.na(eruptions$vei) | is.na(eruptions$start_year) | is.na(eruptions$end_year)),]

# order volcano names by their mean explosivity index (vei)
df_sort <- eruptions %>% group_by(volcano_name) %>% summarise(mean_vei = mean(vei, na.rm = TRUE))
df_sort <- df_sort[order(df_sort$mean_vei),]

# convert to factor so ggplot2 uses this order when plotting the variable
eruptions$volcano_name <- factor(eruptions$volcano_name, levels = df_sort$volcano_name)