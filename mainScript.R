source("mongo.R")

installRequiredPackages <- function(){
  if(!("rmongodb" %in% rownames(installed.packages()))){
    install.packages("rmongodb")  
  }
  if(!("rthreejs" %in% rownames(installed.packages()))){
    install.packages("rthreejs")  
  }
  if(!("shinyBS" %in% rownames(installed.packages()))){
    install.packages("shinyBS")  
  }
  if(!("jsonlite" %in% rownames(installed.packages()))){
    install.packages("jsonlite")  
  }
  if(!("curl" %in% rownames(installed.packages()))){
    install.packages("curl")  
  }
}



installRequiredPackages()





#mongo <- mongoHelper$connect()
attribs <- c("Select",names(mongoHelper$findAllAttributes(mongo)))
scatterplot3js <- NULL
