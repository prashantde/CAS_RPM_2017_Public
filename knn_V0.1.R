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
#### KNN Data #####################################################################################################
###################################################################################################################

### 1 Data exploration
library(readr)
#arrhythmia <- read_csv("https://archive.ics.uci.edu/ml/machine-learning-databases/arrhythmia/arrhythmia.data", col_names = FALSE)
wine <- read_csv("http://archive.ics.uci.edu/ml/machine-learning-databases/wine/wine.data",col_names = FALSE)
### 2 Data view

#head(arrhythmia)
head(wine)


K<-10
### Distance Matrix
#D<-dist(arrhythmia)
D<-wine[,-1]
D<-scale(D, center = FALSE, scale = TRUE)

### Edge List

#arrhythmia <-as.matrix(arrhythmia)
D
D<-kNN(D, k=10, search="dist",sort=TRUE) ##Option 1 ;
kNNdistplot(wine[,-1], k=K)

#D<-knn.dist(data = D, k=K, algorithm=c("kd_tree")) ##Option 2
D$dist;D$id;


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
g<-graph_from_edgelist(edgelist[,1:2], directed = FALSE)
set.seed(1729)
g$weight<-as.numeric(as.character(edgelist[,3]))

layout1 <- layout.fruchterman.reingold(g,weights=E(g)$weight,niter=1000)
g <- simplify(g, remove.multiple = T, remove.loops = T) 
plot(g, layout=layout_with_kk,vertex.color="gray60", vertex.size = 0, edge.arrow.size = 0.5, edge.color = "gray80")
rm(g)



###############Testing + scratchPad
train <- rbind(iris3[1:25,,1], iris3[1:25,,2], iris3[1:25,,3])
test <- rbind(iris3[26:50,,1], iris3[26:50,,2], iris3[26:50,,3])
cl <- factor(c(rep("s",25), rep("c",25), rep("v",25)))
knn(train, test, cl, k = 3, prob=TRUE)
attributes(.Last.value)

x1 <- runif(100, 0, 2*pi)
x2 <- runif(100, 0,3)
DATA <- data.frame(x1, x2)
nearest <- nn2(DATA,DATA)



x <- matrix(runif(100),ncol=2)
G1 <- nng(x,k=1)
## Not run: 
par(mfrow=c(2,2))
plot(G1)

#install.packages("ElemStatLearn")
library(ElemStatLearn)
require(class)
x <- mixture.example$x
g <- mixture.example$y
xnew <- mixture.example$xnew
mod15 <- knn(x, xnew, g, k=15, prob=TRUE)
prob <- attr(mod15, "prob")
prob <- ifelse(mod15=="1", prob, 1-prob)
px1 <- mixture.example$px1
px2 <- mixture.example$px2
prob15 <- matrix(prob, length(px1), length(px2))
par(mar=rep(2,4))
contour(px1, px2, prob15, levels=0.5, labels="", xlab="", ylab="", main=
          "15-nearest neighbour", axes=FALSE)
points(x, col=ifelse(g==1, "coral", "cornflowerblue"))
gd <- expand.grid(x=px1, y=px2)
points(gd, pch=".", cex=1.2, col=ifelse(prob15>0.5, "coral", "cornflowerblue"))
box()


train <- matrix(sample(c("a","b","c"),12,replace=TRUE), ncol=2) # n x 2
n = dim(train)[1]
distMatrix <- matrix(runif(n^2,0,1),ncol=n) # n x n

# matrix of neighbours
k=3
nn = matrix(0,n,k) # n x k
for (i in 1:n)
  nn[i,] = k.nearest.neighbors(i, distMatrix, k = k)

nn




## ggplot example
ggnet2(edgelist[,1:2])
#ggnet2(edgelist[,1:2], color = "blue", color.legend = "period", palette = col,edge.alpha = 1/4, edge.size = "weight",size = "outdegree", max_size = 4, size.cut = 3,legend.size = 12, legend.position = "bottom") +coord_equal()
y = RColorBrewer::brewer.pal(9, "Set1")[ c(3, 1, 9, 6, 8, 5, 2) ]
names(y) = levels(x)
ggnet2(edgelist[,1:2], palette = y, alpha = 0.75, size = 4, edge.alpha = 0.5)
library(intergraph)

data(iris)
# finding kNN directly in data (using a kd-tree)
nn <- kNN(iris[,-5], k=5)
nn
# explore neighborhood of point 10
i <- 11
nn$id[i,]
plot(iris[,-5], col = ifelse(1:nrow(iris) %in% nn$id[i,], "red", "black"))
# show the k nearest neighbors as a graph.


plotNNgraph <- function(x, nn, main = "kNN graph", ...) {
  plot(x, main = main, ...)
  for(i in 1:nrow(nn$id)) {
    for(j in 1:length(nn$id[i,]))
      lines(x = c(x[i,1], x[nn$id[i,j],1]), y = c(x[i,2], x[nn$id[i,j],2]), ...)
  }
}
plotNNgraph(iris[, c(1,2)], nn)

###############

cl <- dbscan(iris, eps = .5, minPts = 4)
pairs(iris, col = cl$cluster+1L)
kNNdist(iris, k=10)

### 4 KNN
D<-iris[,1:3]

## 5 Visualize

as_adjacency_matrix(D, attr="weight")
data(iris)
# finding kNN directly in data (using a kd-tree)
nn <- kNN(wine[,-1], k=10)
nn$dist
nn$id
# explore neighborhood of point 10

plotNNgraph <- function(x, nn, main = "kNN graph", ...) {
  plot(x, main = main, ...)
  for(i in 1:nrow(nn$id)) {
    for(j in 1:length(nn$id[i,]))
      lines(x = c(x[i,1], x[nn$id[i,j],1]), y = c(x[i,2], x[nn$id[i,j],2]), ...)
  }
}
plotNNgraph(D, nn)

