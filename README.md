# CAS_RPM_2017
# These are the install instructons for CAS RPM Workshop 6 - Advanced Predictive Modelling

## System Requirements
    - You will need a laptop with R version 3.3.3 (2017-03-06)
    - You will need atleast 4G of Memory(RAM). Preferably 8G.
    - You will need to install the packages below and initialize with the library function. 
### Install Path
     -The following two commands remove any previously installed H2O packages for R.
if ("package:h2o" %in% search()) { detach("package:h2o", unload=TRUE) }
if ("h2o" %in% rownames(installed.packages())) { remove.packages("h2o") }

     -Next, we download packages that H2O depends on.
pkgs <- c("methods","statmod","stats","graphics","RCurl","jsonlite","tools","utils")
for (pkg in pkgs) {
  if (! (pkg %in% rownames(installed.packages()))) { install.packages(pkg) }
}

      -Now we download, install, and initialize the H2O package for R. 
      -In this case we are using rel-tverberg 2 (3.10.3.2).
install.packages("h2o", type="source", repos=(c("http://h2o-release.s3.amazonaws.com/h2o/rel-tverberg/2/R")))
install.packages("sparklyr")
install.packages("rsparkling")
library(h2o)
library(rsparkling)
library(sparklyr)
library(dplyr)

       -Test connection
localH2O = h2o.init(ip = 'localhost', port = 54321, max_mem_size = '4g',nthreads=-1)
h2o.clusterStatus()
h2o.shutdown(prompt = FALSE) # test the connection

# Set your SPARK path
        Make sure you configure the version you have downloaded
spark_available_versions()
Sys.setenv(SPARK_HOME="D:/spark-2.0.0-bin-hadoop2.7/spark-2.0.0-bin-hadoop2.7") 
options(rsparkling.sparklingwater.version = "2.0.5") 
spark_install(version = "2.0.0") 

# Check your connection
        Make sure you configure the version you have downloaded
#sc <- spark_connect(master = "local", version = "2.0.0")
#h2o_context(sc)
#spark_log(sc, n = 100)


# Install Other Packages

#install.packages("class");install.packages("RANN");install.packages("nng");install.packages("FastKNN");install.packages("FNN")#install.packages("dbscan");install.packages("igraph");
#install.packages("sna");install.packages("GGally")#install.packages("statnet")
install.packages("drat", repos="https://cran.rstudio.com")
drat:::addRepo("dmlc")
install.packages("mxnet")
install.packages("ElemStatLearn")
install.packages("HighDimOut")

library(readr)
library("ElemStatLearn")
library(readr)
library(HighDimOut)
library(mxnet)
library(class);library(RANN);library(FastKNN);library(FNN);library(dbscan);library(igraph);library(sna);library(GGally);library(statnet)



   
