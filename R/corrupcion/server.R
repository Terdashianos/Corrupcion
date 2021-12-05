
server <- function(input, output, session) {
  
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
        hc_theme_bloom()
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
        hc_theme_bloom()
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
        hc_theme_bloom()
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
        hc_theme_bloom()
      )
  })

}

