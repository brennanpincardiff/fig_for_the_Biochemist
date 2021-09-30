# Figure 3B
library(tidyverse)
passwords <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-01-14/passwords.csv')

passwords <- passwords[1:500,]

# pays be nerdy and numeric...

# numbers are probably the key...
# want to see if they have numbers
# colour these by number
passwords$digit <- str_detect(passwords$password, "[1234567890]")

# what are the better passwords
# filter on nerdy-pop, simple-alphanumeric, sport and password-related
good_words_in <- c("nerdy-pop", "simple-alphanumeric", "sport", "password-related")

passwords %>%
    filter(category %in% good_words_in) %>%  # the %in% is important!!  
    ggplot(aes(rank, strength, colour = digit)) + 
    geom_point() + facet_wrap(~category)

# try ggrepel
# https://cran.r-project.org/web/packages/ggrepel/vignettes/ggrepel.html
library(ggrepel)

# need to remove labels for strength < 20. 
# create a data set with strength greater than 20
passwords %>%
    filter(strength >20) -> better_passwords

# overlay these labels with a different dataset...
passwords %>%
    filter(category %in% good_words_in) %>% 
    ggplot(aes(rank, strength, colour = digit)) + 
    geom_point() -> graphs


g_label <- graphs + geom_text_repel(data = better_passwords, 
                                    aes(rank, strength, label=password))


# add some styling...
g_label + facet_wrap(~category) + 
    labs(x = "Password Rank",
         y = "Password Strength", 
         title = "Exploring Passwords for Tidy Tuesday") +
    theme_bw() + theme(legend.position="bottom") -> password_plot

password_plot
