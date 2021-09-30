### START 
## ----download_from_Bioconductor-----------------------------------
# install BiocManager
# install.packages("BiocManager")
# BiocManager::install("flowCore")

library("flowCore")
library(ggplot2)


link <- "https://github.com/brennanpincardiff/R4Biochemists201/blob/master/data/cfse_data_20111028_Bay_d7/A01.fcs?raw=true"

download.file(url=link, destfile="file.fcs", mode="wb")
data <- flowCore::read.FCS("file.fcs", alter.names = TRUE)


#with colours indicating density
colfunc <- colorRampPalette(c("white", "lightblue", "green", "yellow", "red"))
# this colour palette can be changed to your taste 

vals <- as.data.frame(exprs(data))
ggplot(vals, aes(x=FSC.A, y=SSC.A)) +
    ylim(0, 500000) +
    xlim(0,5000000) +
    stat_density2d(geom="tile", aes(fill = ..density..), contour = FALSE) +
    scale_fill_gradientn(colours=colfunc(400)) + # gives the colour plot
    geom_density2d(colour="black", bins=5) # draws the lines inside


# there are lots of small pieces of debris. There is a blue cloud of cells too.  

# exclude debris using the filter package
vals_f <- dplyr::filter(vals, FSC.A>1000000)
# we still have 25,499 events. 

# repeat the plot
f <- ggplot(vals_f, aes(x=FSC.A, y=SSC.A)) +
    ylim(0, 500000) +
    xlim(0,5000000) +
    theme(axis.text.x = element_text(angle = 45, hjust=1)) +
    stat_density2d(geom="tile", aes(fill = ..density..), contour = FALSE) +
    scale_fill_gradientn(colours=colfunc(400)) + # gives the colour plot
    geom_density2d(colour="black", bins=5) + # draws the lines inside
    labs(title = "Simple flow cytometry plot")

