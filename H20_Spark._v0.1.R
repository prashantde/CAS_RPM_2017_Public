
# The following two commands remove any previously installed H2O packages for R.
#if ("package:h2o" %in% search()) { detach("package:h2o", unload=TRUE) }
#if ("h2o" %in% rownames(installed.packages())) { remove.packages("h2o") }

# Next, we download packages that H2O depends on.
#pkgs <- c("methods","statmod","stats","graphics","RCurl","jsonlite","tools","utils")
#for (pkg in pkgs) {
#  if (! (pkg %in% rownames(installed.packages()))) { install.packages(pkg) }
#}

# Now we download, install, and initialize the H2O package for R. 
# In this case we are using rel-tverberg 2 (3.10.3.2).
#install.packages("h2o", type="source", repos=(c("http://h2o-release.s3.amazonaws.com/h2o/rel-tverberg/2/R")))
#install.packages("sparklyr")
#install.packages("rsparkling")

library(h2o)
library(rsparkling)
library(sparklyr)
library(dplyr)


localH2O = h2o.init(ip = 'localhost', port = 54321, max_mem_size = '4g',nthreads=-1)
h2o.clusterStatus()
#h2o.shutdown(prompt = FALSE)


spark_available_versions()
#Sys.setenv(SPARK_HOME="D:/spark-2.0.0-bin-hadoop2.7/spark-2.0.0-bin-hadoop2.7")
#options(rsparkling.sparklingwater.version = "2.0.5")
#spark_install(version = "2.0.0")


#sc <- spark_connect(master = "local", version = "2.0.0")
#h2o_context(sc)
#spark_log(sc, n = 100)


######################################################################################################################
## Import Data
######################################################################################################################
library(readr)
prostate <- read_delim("https://statweb.stanford.edu/~tibs/ElemStatLearn/datasets/prostate.data", "\t", escape_double = FALSE, trim_ws = TRUE)

#train <- read_csv("C:/Users/pde/Google Drive/CAS/Deep_Learning_NeuralNets/Data/MNIST/train.csv")
#test<- read_csv("C:/Users/pde/Google Drive/CAS/Deep_Learning_NeuralNets/Data/MNIST/test.csv")


######################################################################################################################
## Train Autoencoder
######################################################################################################################
prostate<-prostate[,-1]
prostate

prostate_train<-prostate[which(prostate$train==TRUE),]
y_train <- prostate_train$lpsa
prostate_train<-prostate_train[,-9]
prostate_train<-prostate_train[,-9]

prostate_test<-prostate[which(prostate$train==FALSE),]
y_test <- prostate_test$lpsa
prostate_test<-prostate_test[,-9]
prostate_test<-prostate_test[,-8]

prostate_train.hex<-as.h2o(prostate_train, destination_frame="prostate_train.hex")
prostate_test.hex<-as.h2o(prostate_test, destination_frame="prostate_test.hex")

#train.hex<-as.h2o(train, destination_frame="train.hex")
#test.hex<-as.h2o(test, destination_frame="test.hex")


# training data, y ignored
model = h2o.deeplearning(
  x = 1:8,
  training_frame = prostate_train.hex,
  hidden = c(40, 20, 10, 2,10, 20, 40 ),
  epochs = 300,
  activation = 'Tanh',
  autoencoder = TRUE
)

# Compute reconstruction error with the Anomaly
# detection app (MSE between output and input layers)
 recon_error <- h2o.anomaly(model, prostate_test.hex)

# Pull reconstruction error data into R and
# plot to find outliers (last 3 heartbeats)
recon_error <- as.data.frame(recon_error)
 recon_error
 plot.ts(recon_error)

# Note: Testing = Reconstructing the test dataset
test_recon <- h2o.predict(model, prostate_test.hex)
head(test_recon)


 # Graph the data in the 2D layer
library(ggplot2) 
 train_supervised_features2 = h2o.deepfeatures(model , prostate_train.hex, layer=4)
 plotdata2 = as.data.frame(train_supervised_features2)
 plot(plotdata2$DF.L4.C1,plotdata2$DF.L4.C2)
 plotdata2$label = as.vector(y_train)
# plotdata2$label = as.vector(y_test)
 qplot(DF.L4.C1, DF.L4.C2, data = plotdata2, colour=label, main = "Neural network: ")
 
 
 

######################################################################################################################
## Fraud Dataset
######################################################################################################################
 library(readr)
 creditcard <- read_csv("C:/Users/pde/Google Drive/CAS/Anomaly/Scaled_H20andR/creditcardfraud/creditcard.csv")
 set.seed(1729)
 test_pct = 0.25
 train_pct = 2/3
 test_index <- sample(1:nrow(creditcard),round(test_pct*nrow(creditcard)))
 Test <- creditcard[test_index,]
 Train <- creditcard[-test_index,]
 
 y_train<-Train$Class
 y_test<-Test$Class
 
 Train <-  Train[ , ! colnames(Train) %in% c("Class","Amount","Time") ]
 Test <-  Test[ , ! colnames(Test) %in% c("Class","Amount","Time") ]
 
 fraud_train.hex<-as.h2o(Train, destination_frame="fraud_train.hex")
 fraud_test.hex<-as.h2o(Test, destination_frame="fraud_test.hex")
 
 
 # training data, y ignored
 model = h2o.deeplearning(
   x = 1:28,
   training_frame = fraud_train.hex,
   hidden = c(40, 20, 10, 2,10, 20, 40 ),
   epochs = 600,
   activation = 'Tanh',
   autoencoder = TRUE
 )
 
 # Compute reconstruction error with the Anomaly
 # detection app (MSE between output and input layers)
 recon_error <- h2o.anomaly(model, fraud_test.hex)
 
 # Pull reconstruction error data into R and
 # plot to find outliers (last 3 heartbeats)
 recon_error <- as.data.frame(recon_error)
 recon_error
 plot.ts(recon_error)
 
 # Note: Testing = Reconstructing the test dataset
 test_recon <- h2o.predict(model,fraud_test.hex)
 head(test_recon)
 
 
 # Graph the data in the 2D layer
 library(ggplot2) 
 train_supervised_features2 = h2o.deepfeatures(model , fraud_test.hex, layer=4)
 plotdata2 = as.data.frame(train_supervised_features2)
 plot(plotdata2$DF.L4.C1,plotdata2$DF.L4.C2)
 #plotdata2$label = as.vector(y_train)
 plotdata2$label = as.vector(y_test)
 qplot(DF.L4.C1, DF.L4.C2, data = plotdata2, colour=label, main = "Neural network: ")
 
 

 R.version

######################################################################################################################
## Shutdown
######################################################################################################################

spark_disconnect(sc)
