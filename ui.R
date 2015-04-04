
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library("scatterplot3d")
source("mongo.R")
library("threejs")
mongo <- mongoHelper$connect()
attribs <- c("Select",names(mongoHelper$findAllAttributes(mongo)))


shinyUI(fluidPage(
  
  hr(),

  sidebarLayout(
    column(12,
      sidebarPanel(
      selectInput("selectX", label = h3("Select x"), choices = attribs, selected = 1)
      ),
      sidebarPanel(
        selectInput("selectY", label = h3("Select y"), choices = attribs, selected = 1)
      ),
      sidebarPanel(
        selectInput("selectZ", label = h3("Select z"), choices = attribs, selected = 1)
      )
  ),

    
  mainPanel(
    column(12,
      textOutput("selectX"),
      textOutput("selectY"),
      textOutput("selectZ")
    ),
    column(12,
      plotOutput("plotGraphics")
    ),
    column(12,
    scatterplotThreeOutput("scatterplot")
    )
    
  )
  
)))
