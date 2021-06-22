### ----------------------------------------------
### ----------------------------------------------
### This is an example of a simple Shiny app which
### makes a figure that is customisable based on
### some user input(s)
### ----------------------------------------------
### ----------------------------------------------

# This app script was created by opening RStudio, File > New Project > Shiny Web Application.
# This is the default header that appears when you initialize the app:

# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#


# PACKAGES & DATA PREP: Source tabs --------------------------------------------
# source the script that uploads and cleans data, and loads packages

library(shiny)
library(ggridges)
library(ggplot2)
library(here)
library(readr)


# USER INTERFACE (how the app looks) -------------------------------------------
# Define UI for application that plots the Volcano Explosivity Index
# for the most eruptive volcanoes in a chosen time slot

ui <- fluidPage(

    # Application title ----
    titlePanel("Exploring volcano explosivity"),

    # Input interface ----

    # Sidebar with a slider range input
    sidebarLayout(
        sidebarPanel(
            sliderInput("years", # this is important! it's the id your server needs to use the selected value
                        label = h3("Years"),
                        min = 1900, max = 2020, # maximum range that can be selected
                        value = c(2010, 2020) # this is the default slider position
            ),
            br(),
            strong("Space for your addition here:"),
            br()
            
            # space for your addition here:
            #---------------------------------------------
            # some suggestions: 
            # 1. sliderInput or numericInput to select volcanoes that have erupted X number of times
            # 2. checkboxGroupInput to select eruption category
            # 4. radioButtons to select the method used to date the eruption (evidence_method_dating)
            
            # HINT: see how to add control widgets here: https://shiny.rstudio.com/tutorial/written-tutorial/lesson3/
            ),

        # Show the outputs from the server ---------------
        mainPanel(
            
            # if you want to print the input value of "years" to check which values are being selected
            #---------------------------------------------
            #verbatimTextOutput("years") 
            
            # ggplot of selected volcanoes' explosivity index
            #---------------------------------------------

            tableOutput("erupt_table")
            
        )
    )
)

# SERVER (how the app works) ---------------------------------------------------
# Define server logic required to make your output(s)
server <- function(input, output) {

  eruptions <- readr::read_rds(here::here("data", "eruptions.rds"))
    # If you wanted to check which values were being input, you could
    # uncomment this line along with line 65.
    #output$years <- renderPrint({ input$years })
  
  # filter the dataset to avoid overloading the plot (static right now)
  # -----------------------------------------------------------
  # option to make this reactive (see the UI suggestions above!)
  # subset to volcanoes that have erupted more than X times
  eruptions <- eruptions[which(eruptions$volcano_name %in% names(which(table(eruptions$volcano_name) > 30))),]
  
    
  
    # make reactive dataset
    # ----------------------------------------------------------
    # subset volcano data with input year range
    eruptions_filtered <- reactive({
      
      subset(eruptions, start_year >= input$years[1] & end_year <= input$years[2])
      
      })
    
    output$erupt_table <- renderTable({
      head(eruptions_filtered())
      })
    
}

# Run the application
shinyApp(ui = ui, server = server)
