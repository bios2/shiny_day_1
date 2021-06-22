### ----------------------------------------------
### ----------------------------------------------
### This is an example of a simple Shiny app which
### makes a figure that is customisable based on
### some user input(s)
### ----------------------------------------------
### ----------------------------------------------

### GOAL: learn how to lay out a shiny app
### Can add Sidebarlayout to help organization

# PACKAGES & DATA PREP: Source tabs --------------------------------------------
# source the script that uploads and cleans data, and loads packages

library(shiny)
# USER INTERFACE (how the app looks) -------------------------------------------

ui <- fluidPage(

        # Application title ----
        titlePanel("Exploring volcano explosivity"),

        # Input interface ----
    
        sliderInput("years", # this is important! it's the id your server needs to use the selected value
                    label = h3("Years"),
                    min = 1900, max = 2020, # maximum range that can be selected
                    value = c(2010, 2020) # this is the default slider position
        ),
    
        # Show the outputs from the server ---------------
    
        # print out the years that were chosen
          verbatimTextOutput("year_chosen") 

    )


# SERVER (how the app works) ---------------------------------------------------
# Define server logic required to make your output(s)

server <- function(input, output) {

    output$year_chosen <- renderPrint({input$years}) 
    
}

# Run the application
shinyApp(ui = ui, server = server)