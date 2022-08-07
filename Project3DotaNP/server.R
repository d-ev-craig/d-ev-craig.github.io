#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(readr)
library(dplyr)
library(randomForest)
library(caret)
library(ggplot2)
library(gbm)
library(ggsci)
library(shiny)

npData<- read_csv("\\_Projects\\Project3\\datasets\\NPBase.csv")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  newData <- reactive({
    data
  })
    
  
    output$distPlot <- renderPlot({

        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white')

    })
    
    output$boxPlot<- renderPlot({
      
      varHist <- ggplot(npData, aes(x=gold)) +  
        theme_bw() +                                                                     #Set classic bw plot theme
        geom_histogram(color="black", fill = "#34495E", alpha = 0.8, binwidth = 100) +   #Color options, binwidth set to 100 shares
        labs(x = "Win Or Lose", y = "Count", title = paste0("Counts of ", varname)) 
      
    })
    
    output$histPlot <- renderPlot({
      
      varHist <- ggplot(npData, aes(x=gold)) +  
        theme_bw() +                                                                     #Set classic bw plot theme
        geom_histogram(color="black", fill = "#34495E", alpha = 0.8, binwidth = 100) +   #Color options, binwidth set to 100 shares
        labs(x = "Win Or Lose", y = "Count", title = paste0("Counts of ", varname))                                  
      
      
      
    })
    
    output$uitestData <- renderDataTable(newData())
})
