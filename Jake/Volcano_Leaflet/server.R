



function(input, output, session) {
    
    # make reactive dataset
    # ------------------------------------------------
    # subset volcano data with input check boxes
    selected_volcanoes <- reactive({
        volcano %>%
            # select only volcanoes in the selected volcano type (by checkboxes in the UI)
            filter(volcano_type_consolidated %in% input$volcano_type) %>%
        
            # change volcano type into factor (this makes plotting it more consistent)
            mutate(volcano_type_consolidated = factor(volcano_type_consolidated,
                                                      levels = c("Stratovolcano" , "Shield",  "Cone",   "Caldera", "Volcanic Field",
                                                                 "Complex" ,  "Other" ,  "Lava Dome" , "Submarine" ) ) )
    })
    
    

    # make output element for continents ggplot 
    #------------------------------------------------------------
   output$continentplot <- renderPlot({
        
      # create basic barplot
       barplot <- ggplot(data = volcano,
                         aes(x=continent,
                             fill = volcano_type_consolidated))+
           # update theme and axis labels:
           theme_bw()+
           theme(plot.background = element_rect(color="transparent",fill = "transparent"),
                 panel.background = element_rect(color="transparent",fill="transparent"),
                 panel.border = element_rect(color="transparent",fill="transparent"))+
           labs(x=NULL, y=NULL, title = NULL) +
           theme(axis.text.x = element_text(angle=45,hjust=1))
       
       
       # update ggplot if selected volcanoes object exists 
       # basically this makes it not mess up when nothing is selected
       if(nrow(selected_volcanoes()) >1){ 
           barplot <- barplot +
               geom_bar(data = selected_volcanoes(), show.legend = F) +
               scale_fill_manual(values = RColorBrewer::brewer.pal(9,"Set1"), 
                                 drop=F) +
               scale_x_discrete(drop=F)
           
       }

       # print the plot
       barplot
   }, bg="transparent")
   
    
    
    
    # make output element for volcano map
    #------------------------------------------------------------
    output$volcanomap <- renderLeaflet({

        # add blank leaflet map 
        leaflet('map', options = leafletOptions(minZoom = 0, maxZoom = 10, zoomControl = TRUE)) %>%
            addProviderTiles("CartoDB.VoyagerNoLabels") %>%
            setView(lng = -30, lat = 40, zoom = 3)

    })

#  # add proxy for showing volcanoes of a certain type 
  observe({
      pal <- colorFactor(RColorBrewer::brewer.pal(9,"Set1"), 
                         domain = NULL)

    #  selected_volcanoes <- 
    #      volcano %>%
    #      filter(volcano_type_consolidated %in% input$volcano_type)
    #  
      leafletProxy("volcanomap") %>%
          clearMarkers() %>%
          addCircleMarkers(
              data = selected_volcanoes(),
              lng = ~longitude,
              lat = ~latitude,
              radius = ~6,
              color = ~pal(volcano_type_consolidated),
              stroke = FALSE, fillOpacity = 0.9,
              popup = ~paste("<b>",volcano_name,"</b>",
                             "<br>",
                             "<b> Type: </b>",volcano_type_consolidated, "<br>",
                             "<b> Continent: </b>",continent, "<br>",
                             "<b> Elevation: </b>", elevation, "ft."
                             )
          )
  })
    
    
}