#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)

# Define UI for application that draws a histogram
ui <- fluidPage(

   # Application title
   titlePanel("INQStats API"),

   # Sidebar with parameters - data set
   sidebarLayout(
      sidebarPanel(
          selectInput(inputId = "input_dataset", label = "Choose data set", unique(resp$dataset)),
          checkboxGroupInput(inputId = "input_country", label = "Choose Country", unique(resp$country))
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
                "select country"
            } else {
            plot_df <- resp %>%
                filter(country == input$input_country,
                       dataset == input$input_dataset)
            
            # make ggplot
            ggplot(data = plot_df, aes(x = year, y = value, colour = country, group = country)) +
                geom_path() +
                geom_point()
            }
        })
    }


# Run the application 
shinyApp(ui = ui, server = server)

