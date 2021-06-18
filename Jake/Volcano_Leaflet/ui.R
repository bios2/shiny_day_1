
# Source tabs -------------------------------------------------------------
# source the script that uploads and cleans data, and installs packages
source("00_initialize_app.R")

# make dashboard header
header <- dashboardHeader(
    title = "Exploring Volcanoes of the World",
    titleWidth = 350 # since we have a long title, we need to extend width element in pixels
)


# create dashboard body - this is the major UI element
body <- dashboardBody(
    
    # make first row of elements
    fluidRow(
        
        # make first column, 25% of page - 3 of 12 columns
        column(width = 3,
               
               
               # box 1 : input for selecting volvano type
               #-----------------------------------------------
               box(width = NULL, status = "primary",
                   title  = "Selection Criteria", solidHeader = T, 
                   
                   # Widget specifying the species to be included on the plot
                   checkboxGroupButtons(
                       inputId = "volcano_type",
                       label = "Volcano Type",
                       choices = c("Stratovolcano" , "Shield" ,"Cone" ,   "Caldera" ,    "Volcanic Field",
                                    "Complex" , "Other",   "Lava Dome"  , "Submarine"    ),
                       checkIcon = list(
                           yes = tags$i(class = "fa fa-check-square", 
                                        style = "color: steelblue"),
                           no = tags$i(class = "fa fa-square-o", 
                                       style = "color: steelblue"))
                   ),
                   
                   br(),
                   
                   strong("Space for your addition here:"),
                   
                   br(), br(), br(), br(), br(), br()
                   
                   # space for your addition here:
                   #-------------------------------------------
                   # some suggestions: 
                   # 1. slider bar of volcanoes by population within xx km
                   # 2. slider input of last eruption year
                   # 3. slider of elevation
                   # 4. checkbox input of evidence category
                   
                   # HINT: see available widgets here: http://shinyapps.dreamrs.fr/shinyWidgets/
                   
                   
               ), # end box 1
               
               
               
               # box 2: ggplot of selected volcanoes by continent
               #------------------------------------------------
               box(width = NULL, status = "primary",
                   solidHeader = TRUE, collapsible = T,
                   title = "Volcanoes by Continent",
                   plotOutput("continentplot",
                              height = 350)
               )
        ),
        
        # first column - 75% of page (9 of 12 columns)
        column(width = 9,
               
               # Box 3: leaflet map
               box(width = NULL, background = "light-blue", 
                   leafletOutput("volcanomap", height = 760)
               )
        )

    )
)


# compile dashboard elements
dashboardPage(
   # skin = "black",
    header = header,
    dashboardSidebar(disable = TRUE), # here, we only have one tab, so we don't need a sidebar
    body = body
)

