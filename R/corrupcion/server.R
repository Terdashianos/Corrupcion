
server <- function(input, output, session) {
  
  
  
  hc_evangelion <- function(...) {
    theme <-
      hc_theme(colors = c("#9474c1", "#46bd4f", "#d94424", "#dddfe7", "#55a2b6", 
                          "#c71647", "#5e8ea4", "#955cab", "#55a2b6", "#ac3c64",
                          "#2b44a6", "#c23d64", "#28a690", "#5c526f", "#e0ca77",
                          "#ee974a", "#386fce", "#265352", "#d43d29", "#4c545b"), ### Importante para modificar todos los colores
               chart = list(
                 backgroundColor =  'transparent', #'rgba(255, 255, 166,0.1)'   'transparent'
                 style = list(
                   fontFamily = "Inconsolata",
                   font = '15pt "Inconsolata", Verdana, sans-serif',
                   color = "#101010" #  "#negro101010" #blancoFFFFFF
                 )
               ),
               title = list(
                 style = list(
                   color = "#101010"
                 ),
                 align = "left"
               ),
               subtitle = list(
                 style = list(
                   color = "#101010"
                 ),
                 align = "left"
               ),
               legend = list(
                 labels = list(style = list(color = "#101010")),
                 align = "right",
                 verticalAlign = "bottom",
                 itemStyle = list(
                   fontWeight = "normal",
                   fontSize =
                     "15px",
                   color = "#101010",
                   tickWidth = 100
                 )
               ),
               yrcy = list(
                 align = "right",
                 verticalAlign = "bottom",
                 itemStyle = list(
                   fontWeight = "normal",
                   fontSize = "20px",
                   color = "#101010"
                 )
               )
               ,
               xAxis = list(
                 title = list(style = list(color = "#101010")),
                 labels = list(style = list(color = "#101010")),
                 gridLineDashStyle = "Dot",
                 gridLineWidth = 1,
                 gridLineColor = "#101010",
                 lineColor = "#101010",
                 minorGridLineColor = "#101010",
                 tickColor = "#101010",
                 tickWidth = 1),
               
               yAxis = list(
                 title = list(style = list(color = "#101010")),
                 labels = list(style = list(color = "#101010")),
                 gridLineDashStyle = "Dot",
                 gridLineColor = "#101010",
                 lineColor = "#101010",
                 minorGridLineColor = "#101010",
                 tickColor = "#101010",
                 tickWidth = 1
               ),
               caption = list(
                 style = list(
                   color = "#101010"
                 ),
                 align = "left"
               ),
               tooltip = list(
                 backgroundColor = 'transparent', ### you must be 'transparent'
                 style = list(
                   color = "#101010",
                   fontSize = "15px"
                 )
               )
      )
    
    theme <- structure(theme, class = "hc_theme")
    
    if (length(list(...)) > 0) {
      theme <- hc_theme_merge(
        theme,
        hc_theme(...)
      )
    }
    
    theme
  }
  
  observeEvent(c(input$picker_dep_i), {
    inahilitados <- inhabilitacion_shiny %>% filter(dependencia==input$picker_dep_i)
    
    updatePickerInput(session = session, inputId = "picker_cau_i",
                      choices=c(unique(inahilitados$causa)))
  })
  
  observeEvent(c(input$picker_clus), {
    c_1 <- cluster_fshiny %>% filter(cluster==input$picker_clus)
    
    updatePickerInput(session = session, inputId = "picker_clus_dep", selected = "Agricultura",
                      choices=c(unique(c_1$dependencia)))
  })
  
  observeEvent(c(input$picker_dep_m), {
    multas_1 <- multas_shiny %>% filter(dependencia==input$picker_dep_m)
    
    updatePickerInput(session = session, inputId = "picker_cau_m",
                      choices=c(unique(multas_1$causa)))
  })
  
  output$bar_inhabi<-renderHighchart({
    inhabi_out <- inhabilitacion_shiny %>% filter(dependencia==input$picker_dep_i)
    
    highchart() %>% 
      hc_title(
        text = "<b>Duración Promedio de la Inhabilitación por Causa</b>",
        style = list(color = "#17202A", useHTML = TRUE)
      ) %>%
      hc_chart(type = "column") %>%
      hc_xAxis(categories = inhabi_out$causa) %>%
      hc_add_series(data = inhabi_out$san_hombres, name = "Hombres", color = "#138D75")%>%
      hc_add_series(data = inhabi_out$san_mujeres, name = "Mujeres", color = "#CD5C5C")%>%
      hc_exporting(
        enabled=TRUE
      )%>%
      hc_add_theme(
        hc_evangelion()
      )
  })
  
  output$scatter_multas<-renderHighchart({
    scat_multa1 <- multas_shiny %>% filter(dependencia==input$picker_dep_m) %>% filter(causa==input$picker_cau_m)
    
    hc <- multas_shiny %>% 
      hchart('scatter', hcaes(x = ingreso, y = multa, group = puesto)) %>%
      hc_colors(c("#196F3D", "#17A589", "#7D3C98", "#D35400", "#939693", "#27AE60", "#C0392B", "#34495E", "#FA8072"))%>%
      hc_exporting(
        enabled=TRUE
      )%>%
      hc_add_theme(
        hc_evangelion()
      )
  })
  
  output$bar_c_val<-renderHighchart({
    cluster_bar1 <- cluster_fshiny %>% filter(cluster==input$picker_clus )%>% filter(dependencia==input$picker_clus_dep)
    
    highchart() %>% 
      hc_title(
        text = "<b>Número de Personas que Comietieron Faltas</b>",
        style = list(color = "#17202A", useHTML = TRUE)
      ) %>%
      hc_chart(type = "column") %>%
      hc_xAxis(categories = cluster_bar1$falta) %>%
      hc_add_series(data = cluster_bar1$Hombre, name = "Hombres", color = "#138D75")%>%
      hc_add_series(data = cluster_bar1$Mujer, name = "Mujeres", color = "#CD5C5C")%>%
      hc_exporting(
        enabled=TRUE
      )%>%
      hc_add_theme(
        hc_evangelion()
      )
    
  })
  
  output$bar_c_inc <- renderHighchart({
    cluster_bar2 <- c_mean_income %>% filter(cluster==input$picker_clus_income )%>% filter(sancion==input$picker_clus_sanc)
    
    highchart() %>% 
      hc_title(
        text = "<b>Ingresos Promedio por Puesto</b>",
        style = list(color = "#17202A", useHTML = TRUE)
      ) %>%
      hc_chart(type = "column") %>%
      hc_xAxis(categories = cluster_bar2$puesto) %>%
      hc_add_series(data = cluster_bar2$Hombre, name = "Hombres", color = "#138D75")%>%
      hc_add_series(data = cluster_bar2$Mujer, name = "Mujeres", color = "#CD5C5C")%>%
      hc_exporting(
        enabled=TRUE
      )%>%
      hc_add_theme(
        hc_evangelion()
      )
  })
  
  waiter_hide()

}


