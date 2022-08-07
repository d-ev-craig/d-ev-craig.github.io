#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(shinythemes)
library(shiny)

# Define UI for application that draws a histogram
shinyUI(shinyUI(fluidPage(
  
  # Application title
  titlePanel("Dota 2: Quick Look at NP in 7.31"),
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      uiOutput("info"),
      sliderInput("bins",
                  "Number of bins:",
                  min = 1,
                  max = 1000,
                  value = 30),
      numericInput("alpha","Alpha Parameter", value = 1),
      numericInput("gamma", "Gamma Parameter", value = 5),
      actionButton("submit", h3("Change Something")),
      numericInput("maxBins", "Select the max number of bins", value=50,min=1,max=1000)
      
      
    ),
    
    # Show a plot of the generated distribution
    mainPanel("Stuff",
              plotOutput("uitestDat"),
              plotOutput("varHist")
      )
        )
      
    )
  )
)
           
           
