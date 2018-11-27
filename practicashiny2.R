library(shiny)
library(ggplot2)
library(plotly)

ui <- shinyUI(
  #Se ensancha tanto como el navegador del ordenador
  fluidPage(
    titlePanel(h2("Mi primer dashboard")),
    sidebarLayout(
      sidebarPanel(
        selectInput('selectinputX', 
                    label = "Variable X", 
                    choices = names(mtcars), 
                    multiple = FALSE),
        selectInput('selectinputY', 
                    label = "Variable Y", 
                    choices = names(mtcars), 
                    multiple = FALSE),
        selectInput('selectinputfacet',
                    label = 'Facet',
                    choices = names(mtcars),
                    multiple = FALSE),
        checkboxInput(inputId = 'checkboxFacet', 
                      label = 'Facet', 
                      value = FALSE),
        checkboxInput(inputId = 'checkboxPlotly',
                      label = 'Convertir a Plotly',
                      value = FALSE)
      ),
      
      mainPanel(h1("Gráfica"), ("Esta es la gráfica de Mtcars"),
        conditionalPanel(
          condition = "input.checkboxFacet && !input.checkboxPlotly",
          plotOutput("graficaFacet")
        ),
        conditionalPanel(
          condition = "!input.checkboxFacet && !input.checkboxPlotly",
          plotOutput("grafica")
        ),
        conditionalPanel(
          condition = "input.checkboxFacet && input.checkboxPlotly",
          plotlyOutput("graficaFacetPlotly")
        ),
        conditionalPanel(
          condition = "!input.checkboxFacet && input.checkboxPlotly",
          plotlyOutput("graficaPlotly")
        )
      )
    )
  )
)

server <- function(input, output) {
  
  output$grafica <- renderPlot({
    ggplot(mtcars, aes_string(x = input$selectinputX,y = input$selectinputY)) + geom_point(size = 6)
  })
  
  output$graficaFacet <- renderPlot({
    ggplot(mtcars, aes_string(x = input$selectinputX,y = input$selectinputY)) + geom_point(size = 6) + facet_grid(as.formula(paste(". ~", input$selectinputfacet)))
  })
  
  output$graficaFacetPlotly <- renderPlotly({
    ggplotly(ggplot(mtcars, aes_string(x = input$selectinputX,y = input$selectinputY))+ geom_point(size = 3) + facet_grid(as.formula(paste(". ~", input$selectinputfacet))))
  })
  
  output$graficaPlotly <- renderPlotly({
    ggplotly(ggplot(mtcars , aes_string(x =input$selectinputX,y = input$selectinputY))+ geom_point(size = 3))
  })
}

shinyApp(ui, server)