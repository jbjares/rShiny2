
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library("scatterplot3d", lib.loc="~/R/win-library/3.1")
source("mongo.R")

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
    textOutput("selectX"),
    textOutput("selectY"),
    textOutput("selectZ"),
    plotOutput("plotGraphics")
  )
  
)))
