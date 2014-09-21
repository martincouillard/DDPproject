library(shiny)
shinyUI(
  fluidPage(
    titlePanel("Analysis of Diamond Dataset (Price vs Carat for different color)"),
    

    sidebarLayout( 
      

      
      sidebarPanel(      
        radioButtons("dcol", "Diamond color:",
                   c("D" = "D",
                     "E" = "E",
                     "F" = "F",
                     "G" = "G",
                     "H" = "H",
                     "I" = "I",
                     "J" = "J")),
      
        numericInput("carat", 'Carat input (value between 0 and 2): ', 1, min = 0, max = 2, step = 0.1),
      
        submitButton("Predict"),
        
        br(), br(),
        h4('DOCUMENTATION:'),
        p('The dataset consists of a randown subset (for speed) of the diamonds dataset in the ggplot2 library.'),
        p('The application subset the data according to the diamond color (input on left panel), 
          and fits a linear regression model (log(price)~log(carat)).  '),
        p('On the plot, diamonds of the selected color are shown in red 
          (all other point are in black), and the results of the fit is shown as a blue line.  
          The coefficients of the fit are shown below the plot.'),
        p('A prediction is also shown above the plot for the carat value enter an an input on the left panel.')
        
      ),
    
      mainPanel(
        h4("Linear Regression fit for the selected diamond color"),
        verbatimTextOutput("mpgId"),
      
        textOutput("text1"),
      
        plotOutput("DvC"),
      
        p("The summary of the linear regression fit (log(price) ~ log(carat):"),
        tableOutput("table1")
      )
    )  
  ))