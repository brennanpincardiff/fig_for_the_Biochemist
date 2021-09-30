# look at variants

# viz the changes of the UK variant in S1 spike protein....
library(drawProteins)
library(ggplot2)
library(tidyverse)
library(stringr)

# download protein data from
# Uniprot link: https://www.uniprot.org/uniprot/P0DTC2
drawProteins::get_features("P0DTC2") -> spike_sars
drawProteins::feature_to_dataframe(spike_sars) -> spike_data

nrow(spike_data)
# 244

# how many of these are variants
spike_data_variants <- filter(spike_data, type == "VARIANT") 
nrow(spike_data_variants)
# 42 variants... 

# how can I automate pulling those variant out? 
# how will it compare to the hard coding?

# need to mutate description column to remove "in strain:"
spike_data_variants$description %>%
    str_remove("in strain: ") %>%
    str_remove("in strain ")  %>%
    str_remove("frequently ") %>%
    tibble() -> spike_var
    
colnames(spike_var) <- c("var_desc")

# put everything after first semi colon into separate column
spike_var %>%
    separate(var_desc, into = c("just_strains", "info"), sep = ";") -> spike_var

# we have commas separating strain names... 
# pull these out into separate colunms
# need to find the row with the most variants = most comma plus 1
# str_count() function counts them and max() give the largest
most_var <- 1 + max(str_count(spike_var$just_strains, ','))
# in this example it is 9 but may be more in the future. 

# this will create a vectors of column names of the correct length...
paste0("variant_", letters[1:most_var])

# split strains in wide format...
spike_var %>%
    separate(just_strains, 
             into = paste0("variant_", letters[1:most_var]),
             sep = ",") -> variants_wide

spike_data_variants <- bind_cols(spike_data_variants, variants_wide)

# new we have these in a wide format but need in a long format, I think...


spike_data_variants %>%
    pivot_longer(starts_with("variant_"),
                 values_drop_na = TRUE)  %>%
    mutate(value = str_trim(value, side = c("both"))) %>% 
    select(type, begin, end, length, accession, 
           entryName, 
           value) -> variant_long

names <- colnames(variant_long)
names[7] <- "strain"
colnames(variant_long) <- names

length(unique(variant_long$strain))
# 13 different variants


variant_long %>%
    # filter to B variants.. 
    filter(str_detect(strain, "B\\.\\d")) %>%
    # pull variants in S1 chain... begins 13 ends: 685
    filter(begin > 12 & end < 686) -> b_variants_s1

# need to give them a numbering system... 
# make a list of unique b-variants... 
b_s1_var_names <- unique(b_variants_s1$strain)
b_s1_var_n <- length(b_s1_var_names)
# 6 different variants


# pull out S1 chain... begins 13 ends: 685
spike_data %>%
    filter(begin > 12 & end < 686) -> s1
s1$order <- b_s1_var_n + 1
s1_start <- s1
# replicate this and put order = 2

for(i in 1:b_s1_var_n){
    this_s1 <- s1
    this_s1$order <- i
    this_s1type <- b_s1_var_names[i]
    s1_start <- rbind(s1_start, this_s1)
}

plot_names <- c("S1 protein", b_s1_var_names)

# draw canvas, chains & regions
draw_canvas(s1_start) -> p
p <- draw_chains(p, s1_start, labels = plot_names)
p <- draw_regions(p, s1_start)

# need to find correct order for each variant 
# then find list of protein changes
# then plot them... 
# create the object first and then plot or just plot each time?

var_plot <- NULL
for(i in 1:b_s1_var_n){
    b_variants_s1 %>%
        filter(strain == b_s1_var_names[i]) -> var_plot_this
    var_plot_this$order <- i
    var_plot <- rbind(var_plot, var_plot_this)
}

# overlay information about the variants
p <- p + geom_point(data = var_plot,
                    aes(x = begin,
                        y = order+0.2), 
                    size = 4, 
                    colour = "red")

# style the plot a bit...
p <- p + theme_bw(base_size = 14) + # white background
    theme(panel.grid.minor=element_blank(), 
          panel.grid.major=element_blank()) +
    theme(axis.ticks = element_blank(), 
          axis.text.y = element_blank()) +
    theme(panel.border = element_blank()) +
    theme(legend.position = "bottom") +
    theme(legend.text=element_text(size=8))

p <- p + labs(title = "Schematic of SARS-CoV-2 S1 protein variants",
              subtitle = "Source: Uniprot (https://www.uniprot.org/uniprot/P0DTC2)")
p


# to combine with Hex Sticker I need a PNG file... 
ggsave("fig_4B.png")
#       width = 15, height = 10, units = c("cm"),
#       dpi = 300)

