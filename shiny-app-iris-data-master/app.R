
# load libraries
library(ggplot2)
library(shiny)
library(dplyr)

# load iris dataset locally
iris <- read.csv("Iris.csv")

# create a summary of each species and save as separate dataframe
iris_summary <- iris %>%
  group_by(Species) %>%
  summarise("Average sepal length" = mean(SepalLengthCm),
            "Average sepal width" = mean(SepalWidthCm),
            "Average petal length" = mean(PetalLengthCm),
            "Average petal length" = mean(PetalWidthCm))

ui <- fluidPage(
  # title of the page
  titlePanel("Iris data set visualization in Shiny"),
  sidebarLayout(
    sidebarPanel(
      # Select variable for y-axis
      selectInput(
        inputId = "y",
        label = "y-axis",
        choices = c("SepalLengthCm", "SepalWidthCm", "PetalLengthCm", "PetalWidthCm"),
        selected = "SepalLengthCm"
      ),
      
      # Select variable for x-axis
      selectInput(
        inputId = "x",
        label = "x-axis",
        choices = c("SepalLengthCm", "SepalWidthCm", "PetalLengthCm", "PetalWidthCm"),
        selected = "SepalWidthCm"
      ),

      # select species to be dynamically displayed in graph, by default all species are selected
      checkboxGroupInput(
        inputId = "species",
        label = "Select Species", 
        choices = c("Iris-setosa", "Iris-versicolor", "Iris-virginica"),
        selected = c("Iris-setosa", "Iris-versicolor", "Iris-virginica")
        )
    ),
    
    
    mainPanel(
      tags$h3("Scatter Plot"), 
      plotOutput(outputId = "scatterplot"),
      tags$h2("Data Table"), 
      tableOutput('table')

    )

     
  )
)


server <- function(input, output) {
  # create a reactive dataframe to help with visualization
  df <- reactive({
    iris %>%
      filter(Species %in% input$species)
  })

  # table of summary data
  output$table <- renderTable(iris_summary)
  
  # scatter plot of species data
  output$scatterplot <- renderPlot({
    ggplot(
      df(), 
      aes_string(x = input$x, y = input$y)) + 
      geom_point(aes(col = df()$Species), size=3) + scale_color_discrete(name ="Species") +
      geom_smooth(aes(group=df()$Species, color = df()$Species), method='lm')

  })

  
}

# combine ui and server in a shinyApp
shinyApp(ui = ui, server = server)