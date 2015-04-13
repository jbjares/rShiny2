
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





shinyServer(function(input, output) {

  #set.seed(1)
  #if(!exists("example_data")) example_data <- matrix(runif(x*y*z),ncol=3)

  getX <- reactive({
    mongoHelper$findOneCache(input$selectX,input$selectY,input$selectZ)$getX()
  })
  
  getY <- reactive({
    mongoHelper$findOneCache(input$selectX,input$selectY,input$selectZ)$getY()
  })
  
  getZ <- reactive({
    mongoHelper$findOneCache(input$selectX,input$selectY,input$selectZ)$getZ()
  })
  
  
  observe({
    print(input$selectZ)
    if(input$selectZ=="Select"){
      output$plotGraphics <- renderPlot({ 
        plot.new()
        plot(getX(),getY(),xlab=input$selectX,ylab=input$selectY,type="o")
      }) 
      output$scatterplot <- renderScatterplotThree({
        scatterplot3js <- NULL
      })
    }else{
      output$plotGraphics <- renderPlot({ 
        plot.new()
        scatterplot3d(x,y,z, main="3D View")
      }) 
      
      output$scatterplot <- renderScatterplotThree({
        scatterplot3js <- scatterplot3js(getX(),getY(),getZ(), color=rainbow(length(z)))
      })
    }
  })



})
