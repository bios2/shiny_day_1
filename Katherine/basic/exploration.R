# Script where the data is explored, and reactivity options are thought of and played with!

# packages 
library(ggplot2)
library(ggridges)
library(dplyr)

# load dataset
eruptions <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-05-12/eruptions.csv')
# look at the dataset
str(eruptions)
# remove NAs in variables we care about
eruptions <- eruptions[-which(is.na(eruptions$vei) | is.na(eruptions$start_year) | is.na(eruptions$end_year)),]

# take a quick look at the data distribution to think about the input values that could be useful
table(eruptions$volcano_name) %>% hist(main = "How many eruptions per volcano?")
hist(eruptions$start_year, main = "When do the eruptions start?")
hist(eruptions$end_year, main = "When do the eruptions end?")

# these will be reactive inputs when we move over to shiny!
input_frequency <- 25  # radio buttons?
input_years <- c(1900, 2000) # slider range?

# Subset to volcanos that have erupted more than X times  
df <- eruptions[eruptions$volcano_name %in% names(which(table(eruptions$volcano_name) > input_frequency)),]
# and subset to eruptions between the chosen years
df <- df[which(df$start_year >= input_years[1] & df$end_year <= input_years[2]),]

# order volcano names by their mean explosivity index (vei)
df_sort <- df %>% group_by(volcano_name) %>% summarise(mean_vei = mean(vei, na.rm = TRUE)) 
df_sort <- df_sort[order(df_sort$mean_vei),]
df$volcano_name <- factor(df$volcano_name, levels = df_sort$volcano_name)

# Ridgeplot example
ggplot(data = df,
       aes(x = vei, 
           y = volcano_name, 
           fill = volcano_name)) +
  geom_density_ridges(
    alpha = .5, size = .1, scale = 1) +
  labs(x = "Volcano Explosivity Index", y = "") +
  theme_classic() +
  theme(legend.position = "none")
