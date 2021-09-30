# scooby do data set 20210715
library(tidyverse)
library(lubridate)
scoobydoo <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-07-13/scoobydoo.csv')
# 603 observations... 

colnames(scoobydoo)
unique(scoobydoo$series_name)
# 29 different series

# my idea how does the gender of culprits change over time... 

scoobydoo %>%
    # pull out columns that we need
    # good practice to keep the index 
    select(index, date_aired, culprit_gender)  %>%
    # looking at the data, sometimes culprit_gender is NULL
    filter(culprit_gender != "NULL") -> data

# so this gives a plot... 
# shows the pattern of shows... 

# where we have multiple culprits per show we need to separate the data... 
max(scoobydoo$culprit_amount)
# 11 is the maximum... 

# this is hard coded which feels wrong but works...
data %>%
    separate(culprit_gender, into=c("cul1", 
                                    "cul2", 
                                    "cul3",
                                    "cul4",
                                    "cul5",
                                    "cul6",
                                    "cul7",
                                    "cul8",
                                    "cul9",
                                    "cul10", 
                                    "cul11"),sep = ",") -> gender_wide

# gives a warning but that's OK...

# move this from wide to long
gender_wide %>%
    pivot_longer(starts_with("cul"),
                 values_drop_na = TRUE) %>% 
    mutate(Gender = str_trim(value)) %>%
    mutate(year = year(date_aired)) %>%
    mutate(decade = floor(year/10)*10) %>% 
    mutate(decade = as_factor(decade)) %>%  
    group_by(decade, Gender)  %>% 
    summarise(count = n())  -> data2

# make a plot...
p <- ggplot(data2, aes(x = decade, 
                   y = count, 
                   fill = Gender))


# add titles and some colours... 
p + geom_bar(stat="identity", position="fill") +
    scale_fill_brewer(palette = 16, direction=-1) +
    # and add a title
    labs(x = "",
         y = "Gender of culprits (proportion)", 
         title = "Scooby Doo: culprits through the decades",
         subtitle = "More badly behaved females but mostly bad males \nData from Kaggle via Tidy Tuesday") +
    theme_bw() +
    theme(axis.title.y = element_text(size = 14)) +
    theme(axis.text.x = element_text(size = 14)) -> scooby_plot

scooby_plot


