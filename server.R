
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library("scatterplot3d")
source("mongo.R")
library("threejs")



xyz <- read.csv(file="pakDatMesh_ztranslation.csv",header=FALSE,sep=";");
x <- xyz$V1
y <- xyz$V2
z <- xyz$V3


mongo <- mongoHelper$connect()

shinyServer(function(input, output) {

  set.seed(1)
  if(!exists("example_data")) example_data <- matrix(runif(x*y*z),ncol=3)

  getX <- reactive({
    mongoHelper$findOneCache(mongo)$getX()
  })
  
  getY <- reactive({
    mongoHelper$findOneCache(mongo)$getY()
  })
  

  
  
  observe({
    print(input$selectZ)
    if(input$selectZ=="Select"){
      output$plotGraphics <- renderPlot({ 
        plot.new()
        plot(getX(),getY(),xlab=input$selectX,ylab=input$selectY,type="o")
      }) 
    }else{
      output$plotGraphics <- renderPlot({ 
        plot.new()
        scatterplot3d(x,y,z, main="3D View")
      }) 
      
      output$scatterplot <- renderScatterplotThree({
        scatterplot3js(x,y,z, color=rainbow(length(z)))
      })
    }
  })



})
