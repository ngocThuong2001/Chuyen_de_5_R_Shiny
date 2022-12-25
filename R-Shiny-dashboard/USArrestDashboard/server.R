## Shiny Server component for dashboard

function(input, output, session){
  
  
  ##====================XỬ lý dữ liệu============================
  # Data table Output
  output$dataT <- renderDataTable(my_data)

  
  # Rendering the box header  
  output$head1 <- renderText(
    paste("5 states with high rate of", input$var2, "Arrests")
  )
  
  # Rendering the box header 
  output$head2 <- renderText(
    paste("5 states with low rate of", input$var2, "Arrests")
  )
  
  
  # Bảng kết xuất với 5 tiểu bang có số vụ bắt giữ cao đối với loại tội phạm cụ thể
  output$top5 <- renderTable({
    
    my_data %>% 
      select(State, input$var2) %>% 
      arrange(desc(get(input$var2))) %>% 
      head(5)
    
  })
  
  # Rendering table with 5 states with low arrests for specific crime type
  output$low5 <- renderTable({
    
    my_data %>% 
      select(State, input$var2) %>% 
      arrange(get(input$var2)) %>% 
      head(5)
    
    
  })
  
  
  ##====================Làm sạch dữ liệu============================
  # Cấu trúc đầu ra
  output$structure <- renderPrint({
    my_data %>% 
      str()
  })
  
  
  # xuất Tổng
  output$summary <- renderPrint({
    my_data %>% 
      summary()
  })
  
  ##====================Vẽ Biểu đồ============================
  
  # For Biểu đồ tần số - sự phân bổ biểu đồ
  output$histplot <- renderPlotly({
    p1 = my_data %>% 
      plot_ly() %>% 
      add_histogram(x=~get(input$var1)) %>% 
      layout(xaxis = list(title = paste(input$var1)))
    
    
    p2 = my_data %>%
      plot_ly() %>%
      add_boxplot(x=~get(input$var1)) %>% 
      layout(yaxis = list(showticklabels = F))
    
    # xếp chồng các stack lên nhau
    subplot(p2, p1, nrows = 2, shareX = TRUE) %>%
      hide_legend() %>% 
      layout(title = "Distribution chart - Histogram and Boxplot",
             yaxis = list(title="Frequency"))
  })
  
  
  ### Biểu đồ thanh - Xu hướng khôn ngoan của nhà nước
  output$bar <- renderPlotly({
    my_data %>% 
      plot_ly() %>% 
      add_bars(x=~State, y=~get(input$var2)) %>% 
      layout(title = paste("Statewise Arrests for", input$var2),
             xaxis = list(title = "State"),
             yaxis = list(title = paste(input$var2, "Arrests per 100,000 residents") ))
  })
  
  
  ### Biểu đồ phân tán 
  output$scatter <- renderPlotly({
    p = my_data %>% 
      ggplot(aes(x=get(input$var3), y=get(input$var4))) +
      geom_point() +
      geom_smooth(method=get(input$fit)) +
      labs(title = paste("Relation b/w", input$var3 , "and" , input$var4),
           x = input$var3,
           y = input$var4) +
      theme(  plot.title = element_textbox_simple(size=10,
                                                  halign=0.5))
      
    
    # Áp dụng ggplot để làm cho nó tương tác
    ggplotly(p)
    
  })
  
  
  ## biểu đồ tương quan
  output$cor <- renderPlotly({
    my_df <- my_data %>% 
      select(-State)
    
    # Tính toán ma trận tương quan
    corr <- round(cor(my_df), 1)
    
    # Tính toán ma trận các giá trị p tương quan
    p.mat <- cor_pmat(my_df)
    
    corr.plot <- ggcorrplot(
      corr, 
      hc.order = TRUE, 
      lab= TRUE,
      outline.col = "white",
      p.mat = p.mat
    )
    
    ggplotly(corr.plot)
    
  })
  
  
    # Bản đồ Choropleth
  output$map_plot <- renderPlot({
      new_join %>% 
      ggplot(aes(x=long, y=lat,fill=get(input$crimetype) , group = group)) +
      geom_polygon(color="black", size=0.4) +
      scale_fill_gradient(low="#73A5C6", high="#001B3A", name = paste(input$crimetype, "Arrest rate")) +
      theme_void() +
      labs(title = paste("Choropleth map of", input$crimetype , " Arrests per 100,000 residents by state in 1973")) +
      theme(
        plot.title = element_textbox_simple(face="bold", 
                                            size=18,
                                            halign=0.5),
        
        legend.position = c(0.2, 0.1),
        legend.direction = "horizontal"
        
      ) +
      geom_text(aes(x=x, y=y, label=abb), size = 4, color="white")
    
    
 
  })
  
  
  
}

