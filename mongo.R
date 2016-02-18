if(!("rmongodb" %in% rownames(installed.packages()))){
  library(devtools)
  #install_github(repo = "mongosoup/rmongodb")
  install.packages("rmongodb")  
}
parametersSchemaVar <- "sifem.TransformationTO"
dataSetCacheSchemaVar <- "sifem.DataSetHashCacheTO"
#projectNameVar <- "PROJECTTEST"
#simulationNameVar <- "SIMULATIONUNITTEST"
# hostDesenv <- "192.168.3.13:27017"
# usernameDesenv <-"deri"
# passwordDesenv <- "n1kon,c@mera"



#desenv
hostDesenv <- "127.0.0.1:27017"
usernameDesenv <-""
passwordDesenv <- ""
dbDesenv = "sifem"
xValues <- list()
yValues <- list()
zValues <- list()




mongoHelper <- list(

  library(rmongodb), 
    connect = function(){
     mongo <- mongo.create(host = hostDesenv, username = usernameDesenv, password = passwordDesenv, db = dbDesenv, timeout = 0L)
     return(mongo)
    },
                                                                                                      
    findOneCache = function(xName,yName,zName=NULL,projectId=projectId,simulationName=simulationNameVar,conn=mongo,dataSetCache=dataSetCacheSchemaVar){

      #browser()
      
      if(xName=="Select"){
        print("You must select at least Y and Z to show 2D view.")
        return(NULL)
      }
      if(yName=="Select"){
        print("You must select at least Y and Z to show 2D view.")
        return(NULL)
      }
      

      buf <- mongo.bson.buffer.create()
      if(!is.null(projectId) && projectId!=""){
        mongo.bson.buffer.append(buf, "projectId",projectId)
      }

      
      mongo.bson.buffer.append(buf, "xName", xName)
      mongo.bson.buffer.append(buf, "yName", yName)
      if(!is.null(zName) && zName!="" && zName!="Select"){
        mongo.bson.buffer.append(buf, "zName", zName)
      }
      if(is.null(zName) || zName=="Select"){
        print("Try select Z option to show 3D view.")
      }
      
      
      
      query <- mongo.bson.from.buffer(buf)
      yAndYQueryReturn <- mongo.find.one(conn,dataSetCache,query)
      

      
      if(class(yAndYQueryReturn)!="mongo.bson"){
        print(paste0("into map"))
        buf <- NULL
        query <- NULL
        buf <- mongo.bson.buffer.create()
        # mongo.bson.buffer.append(buf, "projectId",projectId)
        mongo.bson.buffer.append(buf, "xName",NULL)
        mongo.bson.buffer.append(buf, "yName",NULL)
        
        query <- mongo.bson.from.buffer(buf)
        tmp <- mongo.find.one(conn,dataSetCache,query)
        tmpList <- mongo.bson.to.list(tmp)["viewTO"]
        viewTOList <- tmpList$viewTO
        
        if(length(viewTOList$xView)>0){
          print("Data set is not properly well defined. Try contact the system admin, and ask about code [ERR0001]")
          return(NULL)
        }
        if(length(viewTOList$yView)>0){
          print("Data set is not properly well defined. Try contact the system admin, and ask about code [ERR0002]")
          return(NULL)
        }
        if(length(viewTOList$zView>0)){
          print("Data set is not properly well defined. Try contact the system admin, and ask about code [ERR0003]")
          return(NULL)
        }
        if(length(viewTOList$dimValMap)<=0){
          print("Data set is not properly well defined. Try contact the system admin, and ask about code [ERR0004]")
          return(NULL)
        }
        
        map <- viewTOList$dimValMap
        newAttributes <- as.list(names(map))
        
        xValues <- map[xName]
        yValues <- map[yName]
        zValues <- map[zName]
        
        
        
        if(class(tmp)!="mongo.bson"){
          print("Result not defined for query.")
          return(NULL)
        }
        
        
        
      }
      
      return(
        
        list(
            getX = function(){
              if(length(xValues)==0 && class(yAndYQueryReturn)=="mongo.bson"){
                doubleList <- mongo.bson.to.list(yAndYQueryReturn)
                doubleListX = doubleList$viewTO$xView
                doubleListXNumeric = as.numeric(unlist(doubleListX))
                return(doubleListXNumeric)
              }
              if(length(xValues)>0){
                xValuesResult <- as.numeric(unlist(xValues))
                return(xValuesResult)
              }

            },
            getY = function(){
              if(length(yValues)==0 && class(yAndYQueryReturn)=="mongo.bson"){
                doubleList <- mongo.bson.to.list(yAndYQueryReturn)
                doubleListY = doubleList$viewTO$yView
                doubleListYNumeric = as.numeric(unlist(doubleListY))
                return(doubleListYNumeric)
              }
              if(length(yValues)>0){
                yValuesResult <- as.numeric(unlist(yValues))
                return(yValuesResult)
              }

            },
            getZ = function(){
              if(length(zValues)==0 && class(yAndYQueryReturn)=="mongo.bson"){
                doubleList <- mongo.bson.to.list(yAndYQueryReturn)
                doubleListZ = doubleList$viewTO$zView
                doubleListZNumeric = as.numeric(unlist(doubleListZ))
                return(doubleListZNumeric)
              }
              if(length(zValues)>0){
                zValuesResult <- as.numeric(unlist(zValues))
                return(zValuesResult)
              }

            },
            
            #1 - BMVelocityMagnitudeButton
            getBMVelocityMagnitudeX = function(){
              if(length(xValues)==0 && class(yAndYQueryReturn)=="mongo.bson"){
                doubleList <- mongo.bson.to.list(yAndYQueryReturn)
                doubleListX = doubleList$viewTO$xView
                doubleListXNumeric = as.numeric(unlist(doubleListX))
                return(doubleListXNumeric)
              }
              if(length(xValues)>0){
                xValuesResult <- as.numeric(unlist(xValues))
                return(xValuesResult)
              }
              
            },
            getBMVelocityMagnitudeY = function(){
              if(length(yValues)==0 && class(yAndYQueryReturn)=="mongo.bson"){
                doubleList <- mongo.bson.to.list(yAndYQueryReturn)
                doubleListY = doubleList$viewTO$yView
                doubleListYNumeric = as.numeric(unlist(doubleListY))
                return(doubleListYNumeric)
              }
              if(length(yValues)>0){
                yValuesResult <- as.numeric(unlist(yValues))
                return(yValuesResult)
              }
              
            },
            
            #2 - BMVelocityPhaseButton
            getBMVelocityPhaseX = function(){
              if(length(xValues)==0 && class(yAndYQueryReturn)=="mongo.bson"){
                doubleList <- mongo.bson.to.list(yAndYQueryReturn)
                doubleListX = doubleList$viewTO$xView
                doubleListXNumeric = as.numeric(unlist(doubleListX))
                return(doubleListXNumeric)
              }
              if(length(xValues)>0){
                xValuesResult <- as.numeric(unlist(xValues))
                return(xValuesResult)
              }
              
            },
            getBMVelocityPhaseY = function(){
              if(length(yValues)==0 && class(yAndYQueryReturn)=="mongo.bson"){
                doubleList <- mongo.bson.to.list(yAndYQueryReturn)
                doubleListY = doubleList$viewTO$yView
                doubleListYNumeric = as.numeric(unlist(doubleListY))
                return(doubleListYNumeric)
              }
              if(length(yValues)>0){
                yValuesResult <- as.numeric(unlist(yValues))
                return(yValuesResult)
              }
              
            },
            
            #3 - PressureRealPartButton
            getPressureRealPartX = function(){
              if(length(xValues)==0 && class(yAndYQueryReturn)=="mongo.bson"){
                doubleList <- mongo.bson.to.list(yAndYQueryReturn)
                doubleListX = doubleList$viewTO$xView
                doubleListXNumeric = as.numeric(unlist(doubleListX))
                return(doubleListXNumeric)
              }
              if(length(xValues)>0){
                xValuesResult <- as.numeric(unlist(xValues))
                return(xValuesResult)
              }
              
            },
            getPressureRealPartY = function(){
              if(length(yValues)==0 && class(yAndYQueryReturn)=="mongo.bson"){
                doubleList <- mongo.bson.to.list(yAndYQueryReturn)
                doubleListY = doubleList$viewTO$yView
                doubleListYNumeric = as.numeric(unlist(doubleListY))
                return(doubleListYNumeric)
              }
              if(length(yValues)>0){
                yValuesResult <- as.numeric(unlist(yValues))
                return(yValuesResult)
              }
              
            },
            
            #4 - PressureImaginaryPartButton
            getPressureImaginaryPartX = function(){
              if(length(xValues)==0 && class(yAndYQueryReturn)=="mongo.bson"){
                doubleList <- mongo.bson.to.list(yAndYQueryReturn)
                doubleListX = doubleList$viewTO$xView
                doubleListXNumeric = as.numeric(unlist(doubleListX))
                return(doubleListXNumeric)
              }
              if(length(xValues)>0){
                xValuesResult <- as.numeric(unlist(xValues))
                return(xValuesResult)
              }
              
            },
            getPressureImaginaryPartY = function(){
              if(length(yValues)==0 && class(yAndYQueryReturn)=="mongo.bson"){
                doubleList <- mongo.bson.to.list(yAndYQueryReturn)
                doubleListY = doubleList$viewTO$yView
                doubleListYNumeric = as.numeric(unlist(doubleListY))
                return(doubleListYNumeric)
              }
              if(length(yValues)>0){
                yValuesResult <- as.numeric(unlist(yValues))
                return(yValuesResult)
              }
              
            },
            #5 - CenterlineButton
            getCenterlineX = function(){
              if(length(xValues)==0 && class(yAndYQueryReturn)=="mongo.bson"){
                doubleList <- mongo.bson.to.list(yAndYQueryReturn)
                doubleListX = doubleList$viewTO$xView
                doubleListXNumeric = as.numeric(unlist(doubleListX))
                return(doubleListXNumeric)
              }
              if(length(xValues)>0){
                xValuesResult <- as.numeric(unlist(xValues))
                return(xValuesResult)
              }
              
            },
            getCenterlineY = function(){
              if(length(yValues)==0 && class(yAndYQueryReturn)=="mongo.bson"){
                doubleList <- mongo.bson.to.list(yAndYQueryReturn)
                doubleListY = doubleList$viewTO$yView
                doubleListYNumeric = as.numeric(unlist(doubleListY))
                return(doubleListYNumeric)
              }
              if(length(yValues)>0){
                yValuesResult <- as.numeric(unlist(yValues))
                return(yValuesResult)
              }
              
            }

          )
        
      )
      
    },
  

  
  
  findAllAttributes = function(parametersSchema=parametersSchemaVar,ids=ids,conn=mongo){
    buf <- mongo.bson.buffer.create()
    if(!is.null(ids)){
      mongo.bson.buffer.append(buf, id,ids )
    }
    query <- mongo.bson.from.buffer(buf)  
    bson <- mongo.find.one(conn,parametersSchemaVar,query)
    #makeList
    vec <- mongo.bson.to.list(bson)$parameters
    len <- length(vec[-1])
    out <- suppressWarnings(as.list(rep(as.numeric(vec[1]), len)))
    names(out) <- as.character(vec[-1])
    return(out)
  }


)

mongo <- mongoHelper$connect()