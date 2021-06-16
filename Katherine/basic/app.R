#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# This app was created by opening RStudio, File > New Project > Shiny Web Application.

# Load packages
library(shiny)
library(ggplot2)
library(ggridges)
library(dplyr)

# Load dataset
eruptions <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-05-12/eruptions.csv')

# remove NAs in variables we care about
eruptions <- eruptions[-which(is.na(eruptions$vei) | is.na(eruptions$start_year) | is.na(eruptions$end_year)),]
# order volcano names by their mean explosivity index (vei)
df_sort <- eruptions %>% group_by(volcano_name) %>% summarise(mean_vei = mean(vei, na.rm = TRUE)) 
df_sort <- df_sort[order(df_sort$mean_vei),]
eruptions$volcano_name <- factor(eruptions$volcano_name, levels = df_sort$volcano_name)

# Define UI for application that plots the Volcano Explosivity Index for the most eruptive volcanoes
# in a chosen time slot

ui <- fluidPage(
    
    # Application title ----
    titlePanel("Explosivity"),
    
    
    # Input interface ----
    
    # Sidebar with a slider range input 
    sidebarLayout(
        sidebarPanel(
            sliderInput("years", # this is important! it's the id your server needs to use the selected value
                        label = h3("Years"), 
                        min = 1500, max = 2020, 
                        value = c(1800, 2020) # this is the default slider position
            )
        ),
        
        # Show the outputs from the server ----
        mainPanel(
            #verbatimTextOutput("years") # will print the input value of "years" to check which values are being selected
            plotOutput("ridgePlot", height = "600px")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    output$years <- renderPrint({ input$years })
    
    output$ridgePlot <- renderPlot({
        
        # subsetting the data ----
        
        # REACTIVE: Subset based on input$years from the UI
        df <- df[which(df$start_year >= input$years[1] & df$end_year <= input$years[2]),]
        
        # making a plot ----
        ggplot(data = df,
               aes(x = vei, 
                   y = volcano_name, 
                   fill = volcano_name)) +
            geom_density_ridges(
                alpha = .5, # transparency
                size = .1 # line width
                ) +
            labs(x = "Volcano Explosivity Index", y = "") +
            theme_classic() +
            theme(legend.position = "none")
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
