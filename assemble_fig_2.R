# putting together plots... 

# Figure 2
# volcano plot   object = v
# LD50 plot     object = p
# flow data    object = f

library(ggpubr)
ggarrange(v, p, f, ncol = 1, nrow = 3,
          # add letters 
          labels = c("A.",
                     "B.",
                     "C.")) %>%
    ggexport(filename = "Figure 2.png",
             width = 1000,
             height = 3000, 
             pointsize = 12,
             res = 300)
    
ggexport(
    filename = "Figure 2.png",

    pointsize = 12,
    res = 300,
    verbose = TRUE
)


# need to set ratio. 

# add titles on each the same... 


# http://www.sthda.com/english/articles/24-ggpubr-publication-ready-plots/81-ggplot2-easy-way-to-mix-multiple-graphs-on-the-same-page/
# https://rpkgs.datanovia.com/ggpubr/reference/ggexport.html