
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

source("mainScript.R")
source("mongo.R")
library(shiny)
library("scatterplot3d")
library("threejs")

shinyUI(navbarPage("",
                   tabPanel(
                     selectInput("selectX", label = h3("coord x"), choices = attribs, selected = 1)
                   ),
                   tabPanel(
                     selectInput("selectY", label = h3("coord y"), choices = attribs, selected = 1)
                   ),
                   tabPanel(
                     selectInput("selectZ", label = h3("coord z"), choices = attribs, selected = 1)
                   ),

  mainPanel(
    br(),
    br(),
    br(),
    br(),
    br(),
    br(),
    hr(),
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
  
,position="fixed-top"))
