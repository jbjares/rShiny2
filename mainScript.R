source("mongo.R")

installRequiredPackages <- function(){
  if(!("rmongodb" %in% rownames(installed.packages()))){
    install.packages("rmongodb")  
  }
  
  
  if(!("rthreejs" %in% rownames(installed.packages()))){
    install.packages("rthreejs")  
  }
}

installRequiredPackages()


#xyz <- read.csv(file="pakDatMesh_ztranslation.csv",header=FALSE,sep=";");
#x <- xyz$V1
#y <- xyz$V2
#z <- xyz$V3


#mongo <- mongoHelper$connect()
attribs <- c("Select",names(mongoHelper$findAllAttributes(mongo)))
scatterplot3js <- NULL
