
parametersSchemaVar <- "sifem.TransformationTO"
dataSetCacheSchemaVar <- "sifem.DataSetHashCacheTO"
projectNameVar <- "PROJECTTEST"
hostDesenv <- "127.0.0.1"
usernameDesenv <-""
passwordDesenv <- ""
dbDesenv = "sifem"


mongoHelper <- list(

  library(rmongodb), 
    connect = function(){
     mongo <- mongo.create(host = hostDesenv, username = usernameDesenv, password = passwordDesenv, db = dbDesenv, timeout = 0L)
     return(mongo)
    },
                                                                                                      
    findOneCache = function(xName,yName,zName=NULL,projectName=projectNameVar,conn=mongo,dataSetCache=dataSetCacheSchemaVar){
      buf <- mongo.bson.buffer.create()
      if(!is.null(projectName) && projectName!=""){
        mongo.bson.buffer.append(buf, "projectName",projectName)
      }

      if(xName=="Select"){
        #paste("You must select at least Y and Z to show 2D view.")
        validate(
          need(xName,"You must select at least Y and Z to show 2D view.")
        )
        stop()
      }
      if(yName=="Select"){
        #paste("You must select at least Y and Z to show 2D view.")
        validate(
          need(yName,"You must select at least Y and Z to show 2D view.")
        )
        stop()
      }
      mongo.bson.buffer.append(buf, "xName", xName)
      mongo.bson.buffer.append(buf, "yName", yName)
      if(!is.null(zName) && zName!="" && zName!="Select"){
        mongo.bson.buffer.append(buf, "zName", zName)
      }
      if(is.null(zName) || zName=="Select"){
        #paste("Try select Z option to show 3D view.")
        validate(
          need(zName,"Try select Z option to show 3D view.")
        )
      }
      

      query <- mongo.bson.from.buffer(buf)
      bson <- mongo.find.one(conn,dataSetCache,query)
      if(class(bson)!="mongo.bson"){
        #paste("Result not defined for query: ",query)
        validate(
          need(query,"Result not defined for query")
        )
        stop()
      }
      
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
            },
            getZ = function(){
              doubleListZ = doubleList$viewTO$zView;
              doubleListZNumeric = as.numeric(unlist(doubleListZ))
              return(doubleListZNumeric);
            }
          
          )
        
      )
      
    },
  
#  makeList = function(vec) {
#    vec <- mongo.bson.to.list(bson)$parameters
#    len <- length(vec[-1])
#    out <- as.list(rep(as.numeric(vec[1]), len))
#    names(out) <- as.character(vec[-1])
#    out
#  },
  
  findAllAttributes = function(parametersSchema=parametersSchemaVar,projectName="TheOne",conn=mongo){
    buf <- mongo.bson.buffer.create()
    mongo.bson.buffer.append(buf, "projectName",projectName )
    query <- mongo.bson.from.buffer(buf)  
    bson <- mongo.find.one(conn,parametersSchemaVar,query)
    #makeList
    vec <- mongo.bson.to.list(bson)$parameters
    len <- length(vec[-1])
    out <- suppressWarnings(as.list(rep(as.numeric(vec[1]), len)))
    names(out) <- as.character(vec[-1])
    return(out)
  }
#,
#   isFindOneCacheInputValid = function(xName=NULL,yName=NULL,zName=NULL,projectName,conn,dataSetCache){
#     if(!mongo.is.connected(conn)){
#       print("Mongo connection is not available.")
#       return(F)
#     }
#   
#     if(is.null(dataSetCache) || dataSetCache==""){
#       print("Please, input the name of the db and table.")
#       return(F)
#     }
#     
#     if(is.null(xName) || xName==""){
#       print("Please, input the xName.")
#       return(F)
#     }
#     if(is.null(yName) || yName==""){
#       print("Please, input the yName")
#       return(F)
#     }
# 
#     if(is.null(projectName) || projectName==""){
#       print("Please, input the projectName")
#       return(F)
#     }
# 
#     return(TRUE)
#   }
    

)

mongo <- mongoHelper$connect()