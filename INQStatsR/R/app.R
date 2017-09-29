#' @title INQStats Shiny visualization
#' @field data a data frame
#' @description Visualize a time series of the data extracted from INQStats API
#' @export runShinyapp
#' @export


runShinyapp <- function(data){
    library(shiny)
    library(dplyr)
    library(ggplot2)
    # Define UI for application that draws a histogram
    ui <- fluidPage(
        
        # Application title
        titlePanel("INQStats API"),
        
        # Sidebar with parameters - data set
        sidebarLayout(
            sidebarPanel(
                selectInput(inputId = "input_dataset", label = "Choose data set", unique(data$dataset)),
                checkboxGroupInput(inputId = "input_country", label = "Choose Country", unique(data$country))
                # sliderInput(inputId = "input_date_range", label = "Select Years", min = min(resp$year), max = max(resp$year),
                #            value = c(min(resp$year), max(resp$year)), dragRange = TRUE, step = 1)
            ),
            
            # Show a plot of the generated distribution
            mainPanel(
                plotOutput("time_serie_plot")
            )
        )
    )
    
    # Server function
    server <- function(input, output) {
        
        output$time_serie_plot <- renderPlot({
            if (length(input$input_country) == 0) {
                
            } else {
                plot_df <- data %>%
                    filter(country %in% input$input_country,
                           dataset %in% input$input_dataset
                           #year %in% as.numeric(input$input_date_range)
                    )
                plot_df$values <- as.numeric(plot_df$values)
                
                # make ggplot
                ggplot(data = plot_df, aes(x = years, y = values, colour = country, group = country)) +
                    geom_path() +
                    geom_point()
            }
        })
    }
    
    
    # Run the application 
    shinyApp(ui = ui, server = server)
    
}


