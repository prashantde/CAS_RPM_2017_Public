#install.packages("ElemStatLearn")
#install.packages("HighDimOut")
#install.packages("scales") ## If v0.40 needs to be updated
##############################################################################
#1 Import High dimensional data
###############################################################################
library("ElemStatLearn")
library(readr)
library(HighDimOut)
library(ggplot2)
prostate <- read_delim("https://statweb.stanford.edu/~tibs/ElemStatLearn/datasets/prostate.data", "\t", escape_double = FALSE, trim_ws = TRUE)
  

##############################################################################
#2 Outlier analysis
###############################################################################

##Considerations and findings:
#a The number of data elements outweights the number of records indicating sparse data
#b Using distance based, euclideanm, outlier detection is challenging in a sparse environment due to the curse of dimensionality: one finds extremely sparse space where outlier detection is not easily quantified
#c Subspace outlier detection, identifies relevant subspaces and then finds outliers in those subspaces allowing it to work in high dimensions
#d We find some records are possible outliers
#Source :"Outlier Detection in Axis-Parallel Subspaces of High Dimensional Data", Hans-Peter Kriegel, Peer Kr?oger, Erich Schubert, and Arthur Zimek

##Tasks:
#a Run a SOD analysis for high dimensional and sparse data and review the records 
res.SOD <- Func.SOD(data=prostate, k.nn = 10, k.sel = 5, alpha = 0.8)
plot(res.SOD,main = "Scatterplot of outliers by record index")
qplot(res.SOD,main = "Subspace Outlier records in data. Distance measured")

