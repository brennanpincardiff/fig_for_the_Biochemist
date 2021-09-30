# putting together plots... 

# Figure 3
# volcanos plot   object = v
# password plots     object = p
# scooby plot    object = s


library(ggpubr)
ggarrange(v,
          password_plot,
          scooby_plot,
          ncol = 1, nrow = 3,
          # add letters 
          labels = c("A.",
                     "B.",
                     "C.")) %>%
    ggexport(filename = "Figure 3.png",
             width = 2000,
             height = 3000, 
             pointsize = 12,
             res = 300)
    


# need to set ratio. 

# add titles on each the same... 


# http://www.sthda.com/english/articles/24-ggpubr-publication-ready-plots/81-ggplot2-easy-way-to-mix-multiple-graphs-on-the-same-page/
# https://rpkgs.datanovia.com/ggpubr/reference/ggexport.html