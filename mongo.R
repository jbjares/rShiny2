
mongoHelper <- list(
  library(rmongodb),
  source("util.R"),
    connect = function(){

     mongo <- mongo.create(host = "127.0.0.1", username = "",
                          password = "", db = "sifem", timeout = 0L)
     return(mongo)
    },
  
    findOneCache = function(mongo=connect()){
      buf <- mongo.bson.buffer.create()
      mongo.bson.buffer.append(buf, "projectName", "PROJECTTEST")
      mongo.bson.buffer.append(buf, "xName", "DISTANCEFROMTHECOCHLEAAPEX")
      mongo.bson.buffer.append(buf, "yName", "FREQUENCYATSTAPLES")
      query <- mongo.bson.from.buffer(buf)
      

      bson <- mongo.find.one(mongo, "sifem.DataSetHashCacheTO",query)
      
      return(
        
        list(
            doubleList <- mongo.bson.to.list(bson),      
            getX = function(){
              doubleListX = doubleList$viewTO$xView;
              doubleListXNumeric = as.numeric(unlist(doubleListX))
              return(doubleListXNumeric);
            },
            getY = function(){
              doubleListY = doubleList$viewTO$yView;
              doubleListYNumeric = as.numeric(unlist(doubleListY))
              return(doubleListYNumeric);
            }
          
          )
        
      )
      
    },
  
  findAllAttributes = function(mongo=connect()){
    buf <- mongo.bson.buffer.create()
    mongo.bson.buffer.append(buf, "projectName", "TheOne")
    query <- mongo.bson.from.buffer(buf)  
    bson <- mongo.find.one(mongo, "sifem.TransformationTO",query)
    return(makeList(mongo.bson.to.list(bson)$parameters))
  }
    

)

