#install.packages("class");install.packages("RANN");install.packages("nng");install.packages("FastKNN");install.packages("FNN")
#install.packages("dbscan");install.packages("igraph")
#install.packages("sna");install.packages("GGally");install.packages("statnet")



library(class);
library(RANN);library(FastKNN);
library(FNN);library(dbscan);library(igraph);
library(sna);library(GGally);
#library(statnet)
#install.packages("tidyverse")
###################################################################################################################
#### LOF Data #####################################################################################################
###################################################################################################################


### 1 Data exploration

library(readr)
#arrhythmia <- read_csv("https://archive.ics.uci.edu/ml/machine-learning-databases/arrhythmia/arrhythmia.data", col_names = FALSE)
wine <- read_csv("http://archive.ics.uci.edu/ml/machine-learning-databases/wine/wine.data",col_names = FALSE)

### 2 Data view
head(wine)


head(wine)

### Distance Matrix
#D<-dist(arrhythmia)
D<-wine[,-1]
D<-scale(D, center = FALSE, scale = TRUE)

### Edge List
K<-20
#arrhythmia <-as.matrix(arrhythmia)

D<-kNN(D, k=K, search="dist",sort=TRUE) ##Option 1 ;

D
D$id[1,]
D$dist[,1]

num_nodes <- K
num_edges <- nrow(D$id)*num_nodes
node_names <- rep("",num_nodes)

for(i in 1:num_nodes){
  node_names[i] <- paste("Neighbourhood",i,sep = "_")
}
print(node_names)

edgelist <- matrix("",nrow= num_edges, ncol = 4 )

z<-1
for(i in 1:nrow(D$id)){
  for(j in 1:num_nodes){
    
    edgelist[z,1] <- i
    edgelist[z,2] <- D$id[i,j]
    edgelist[z,3] <- D$dist[i,j]
    edgelist[z,4] <- node_names[j]
    z=z+1
    
  }
  
}

colnames(edgelist) <- c("from","to","Weight","Neighbour")
print(edgelist)


### 3 Data view

D
D$id
D$lrd_p <-rowSums(D$dist)/K
D$lrd_o<-rep(0,nrow(D$id))

#Define a function to find a row in D from the vector in i. Go through



store_sum_i <- as.vector(rep(0,K))
extract_lrd<- function(j,pointer){ 
return(sum(D$dist[pointer,]))

}  


for (i in 1:nrow(D$id)){
    for (j in 1:K){
      pointer<-D$id[i,j]
      store_sum_i <- extract_lrd(i,pointer)
      D$lrd_o[i] <- sum(store_sum_i)/K 
    
    }
}

small_k<-4  # Select Minimum neighbourhood
store_sum_i <- as.vector(rep(0,K))
for (i in 1:nrow(D$id)){

    for (j in 1:K){
    pointer<-D$id[i,j]
    
    #print(D$dist[pointer,][1:small_k])
    #print(D$dist[pointer,][small_k+1:(K-small_k)])
    
    
    store_sum_i[j]<-(sum(D$dist[pointer,][1:small_k])+sum(D$dist[pointer,][small_k+1:(K-small_k)]))/K
    #print(store_sum_i[j]) 
    
    }
    #print(sum(store_sum_i)/K)
    D$lrd_o[i] <- sum(store_sum_i)/K
    store_sum_i <- as.vector(rep(0,K))
}    

D$lrd_o/D$lrd_p
local_outliers<-subset(D$lrd_o/D$lrd_p,D$lrd_o/D$lrd_p==max(D$lrd_o/D$lrd_p ))
local_outliers<-subset(lof(wine[,-1],k = 4),lof(wine[,-1],k = 4)==max(lof(wine[,-1],k = 4)))
local_outliers
subset(lof(wine[,-1],k = 4),lof(wine[,-1],k = 4)==max(lof(wine[,-1],k = 4)))









library(DMwR)
# remove "Species", which is a categorical column
D <- wine[,-1]
outlier.scores <- lofactor(D, k=5)
plot(density(outlier.scores))
outliers <- order(outlier.scores, decreasing=T)[1:5]
# who are outliers
print(outliers)
nrow(D)
n <- nrow(D)
labels <- 1:n
labels[-outliers] <- "."
biplot(prcomp(D), cex=.8, xlabs=labels)


