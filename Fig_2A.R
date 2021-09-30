library(ggplot2)
library(grDevices)

link <- ("https://raw.githubusercontent.com/brennanpincardiff/RforBiochemists/master/data/mcp.M114.044479.csv")
data<-read.csv(link, header=TRUE)

##Identify the genes that have a p-value < 0.05
data$threshold = as.factor(data$P.Value < 0.05)

# make a title including italic
# https://stackoverflow.com/questions/32555531/how-to-italicize-part-one-or-two-words-of-an-axis-title
y_title <- expression(paste("minus log10 ", italic("p"), "-value"))

##Construct the plot object
v <- ggplot(data=data, 
            aes(x=Log2.Fold.Change, y =-log10(P.Value), 
            colour=threshold)) +
  geom_point(alpha=0.4, size=1.75) +
  xlim(c(-6, 6)) +
  labs(x = "log2 fold change",
       y = y_title, 
       title = "Volcano plot") +
  theme_bw() +
  theme(legend.position="none")

  

# The script gives a warning message: Removed 1 rows containing missing values (geom_point).

# but it still works....

# need to give data source here!

