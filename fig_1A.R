# Code for Figure 1
# Figure 1A is my first cluster diagram

# import the data
link <- ("https://raw.githubusercontent.com/brennanpincardiff/RforBiochemists/master/data/iTRAQPatientforCluster.csv")

data2 <- read.csv(link, header=TRUE)

attach(data2)  # attaching a data.frame means we can use the headings directly. 
head(data2)  # look at the top of the file. 

# first step is to calculate the distances using the dist() function. 
# various methods are possible - default is Euclidean. 
distances2 <- dist(rbind(P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12))
distances2
summary(distances2)

# make the cluster dendrogram object using the hclust() function
hc <- hclust(distances2)  
detach(data2) # good practice to detach data after we're finished.

# 1. Open jpeg file
png("fig_1A.png", width = 10, height = 10, 
    units = "cm", res = 300)

# plot the cluster dendrogram object using base graphics
plot(hc, xlab =expression(bold("Patient Samples")), ylab = expression(bold("Distance")))

# 3. Close the file
dev.off()





