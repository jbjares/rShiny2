
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#
source("mainScript.R")
source("mongo.R")
library(shiny)
library("scatterplot3d")
library("threejs")
library(jsonlite)
library(curl)



shinyServer(function(input, output,session) {
  interpretationHostNameVar <- NULL
  workspacePathVar <- NULL
  projectName <- NULL
  simulationName <- NULL
  xName <- NULL
  yName <- NULL

  getQueryArgumentValues <- reactive({
    query <- parseQueryString(session$clientData$url_search)
    return(query)
  })

   getInterpretationHostNameVar <- reactive({
     argumentValues <- getQueryArgumentValues()
     interpretationHostNameVar <- paste0("http://",argumentValues["interpretationHostName"],"/Sifem/rest/semanticInterpretation/show/")
     return(interpretationHostNameVar)
   })

  getWorkspacePathVar <- reactive({
    argumentValues <- getQueryArgumentValues()
    return(argumentValues["workspacePath"])
  })

  getProjectNameVar <- reactive({
    argumentValues <- getQueryArgumentValues()
    return(argumentValues["getProjectName"])
  })

  getSimulationNameVar <- reactive({
    argumentValues <- getQueryArgumentValues()
    return(argumentValues["simulationName"])
  })



  getCompletedServiceEndpoint <- reactive({
    baseURL <- getInterpretationHostNameVar()
    if(grepl("NULL",baseURL)){
      return(NULL)
    }
    baseURL <- paste0(baseURL,"?")
    regexToFindIfUrlEndsWithInterrogationPoint <- "[(?)]$"
    workspacePathVar = getWorkspacePathVar()
    if(!is.null(workspacePathVar) && workspacePathVar!="NULL" && workspacePathVar!=""){
      baseURL <- paste0(baseURL,"workspacePath=",workspacePathVar)
    }
    
    if(!grepl(regexToFindIfUrlEndsWithInterrogationPoint,baseURL)){
      baseURL <- paste0(baseURL,"&")
    }

    projectNameVar = getProjectNameVar()
    if(!is.null(projectNameVar) && projectNameVar!="NULL" && projectNameVar!=""){
      baseURL <- paste0(baseURL,"projectName=",projectNameVar)
    }

    if(!grepl(regexToFindIfUrlEndsWithInterrogationPoint,baseURL)){
      baseURL <- paste0(baseURL,"&")
    }
    
    simulationNameVar = getSimulationNameVar()
    if(!is.null(simulationNameVar) && simulationNameVar!="NULL" && simulationNameVar!=""){
      baseURL <- paste0(baseURL,"simulationName=",simulationNameVar)
    }

    if(!grepl(regexToFindIfUrlEndsWithInterrogationPoint,baseURL)){
      baseURL <- paste0(baseURL,"&")
    }
    
    xNameVar <- input$selectX
    if(!is.null(xNameVar) && xNameVar!="NULL" && xNameVar!="" && xNameVar!="Select"){
      baseURL <- paste0(baseURL,"xName=",xNameVar)
    }

    if(!grepl(regexToFindIfUrlEndsWithInterrogationPoint,baseURL)){
      baseURL <- paste0(baseURL,"&")
    }
    
    YNameVar <- input$selectY
    if(!is.null(YNameVar) && YNameVar!="NULL" && YNameVar!="" && YNameVar!="Select"){
      baseURL <- paste0(baseURL,"YName=",YNameVar)
    }
    
  })


  

  getX <- reactive({
    mongoHelper$findOneCache(input$selectX,input$selectY,input$selectZ)$getX()
  })
  
  getY <- reactive({
    mongoHelper$findOneCache(input$selectX,input$selectY,input$selectZ)$getY()
  })
  
  getZ <- reactive({
    mongoHelper$findOneCache(input$selectX,input$selectY,input$selectZ)$getZ()
  })
  
  callService <- reactive({
    print(interpretationHostNameVar)
    showInterpretationContent <- jsonlite::fromJSON(getCompletedServiceEndpoint(), simplifyVector = FALSE)  
    return(showInterpretationContent)
  })
  
  observe({
    
    print("plot")
    
    #observer coord selection changed
    if(input$selectZ=="Select"){
      output$plotGraphics <- renderPlot({ 
        plot.new()
        print(input$selectX)
        print(input$selectY)
        plot(getX(),getY(),xlab=input$selectX,ylab=input$selectY,type="o")
      }) 
      output$scatterplot <- renderScatterplotThree({
        scatterplot3js <- NULL
      })
    }else{
      output$plotGraphics <- renderPlot({ 
        plot.new()
        scatterplot3d(getX(),getY(),getZ(), main="3D View")
      }) 
      
      output$scatterplot <- renderScatterplotThree({
        scatterplot3js <- scatterplot3js(getX(),getY(),getZ(), color=rainbow(length(getZ())))
      })
    }
    


    
  })

  observe({
    #obersver show interpretation changed
    endpoint <- getCompletedServiceEndpoint()    
    print(endpoint)
    print("1")
    if(!is.null(endpoint) && endpoint!="" && !grepl("NULL",endpoint)){
      print("2")
      if (input$showInterpretationButton > 0){
        showInterpretationContent <- callService()
        print(showInterpretationContent$content)
        paste(showInterpretationContent$content)
        createAlert(session, "showInterpretationAlert_anchorId", "showInterpretationAlert_Id", title = "Semantic Interpretation", content = paste(showInterpretationContent$content), append = T)
      }
    }
    
  })



})
