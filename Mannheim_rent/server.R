library(shiny)
library(tidyverse)

ManData <- data.frame(size = c(20, 40, 60, 80, 100, 120, 150), 
                      cold = c(18.1, 14.6, 10.9, 10.5, 11.2, 10.9, 12.8),
                      extra = c(3,3,3,3,3,3,3))

DeData <- data.frame(size = c(40, 60, 80, 100, 120, 150), 
                     cold = c(11.8, 8.7, 8.8, 8.4, 9.5, 9.5),
                     extra = c(3,3,3,3,3,3))

BwData <- data.frame(size = c(20,40, 60, 80,100, 120, 140, 150),
                     cold = c(25.8, 15, 11.6, 10.8, 10.5, 10.4, 10,10),
                     extra = c(3, 3, 3, 3,3,3,3,3))

searchPrice <- function(df, s){
        df$size <- as.numeric(df$size)
        out <- df %>% 
                arrange(size) %>%
                filter(size >= s) %>%
                head(1)
        out <- if(nrow(out) == 0){
                tail(df, 1)
        } else {
                out
        }
        
        out <- data.frame(cold = out$cold * s,
                          extra = out$extra * s,
                          warm = out$cold * s + out$extra * s)
        out       
}

comPlotter <- function(Germany = NULL, BW = NULL, man){
        compDat <- data.frame(Region = "Mannheim", Rent = man$warm)
        compDat <-if(is.null(Germany)){ 
                compDat
        } else {
                rbind(compDat, data.frame(Region = "Germany", Rent = Germany))}
        compDat <-if(is.null(BW)){ 
                compDat
        } else {
                rbind(compDat, data.frame(Region = "Baden-Wuerttemberg", Rent = BW))}
        g <- ggplot(compDat, aes(x= Region, y= Rent, fill = Region)) +
                geom_col() +
                ylim(0,2500) +
                geom_text(aes(label = Rent), vjust = -.2)
        g
}

shinyServer(
        function(input, output, session) {
                resultM <- reactive({searchPrice(ManData, input$size)})
                Germany <- reactive({
                        if("Germany" %in% input$comp){
                                searchPrice(DeData, input$size)$warm
                        } else {
                                NULL
                        }})
                BW <- reactive({
                        if("Baden-Wuerttemberg" %in% input$comp){
                                searchPrice(BwData, input$size)$warm
                        } else {
                                NULL
                        }})
                output$ExpCold <- renderText({resultM()$cold})
                output$ExpEx <- renderText({resultM()$extra})
                output$ExpWarm <- renderText({resultM()$warm})
                output$comPlot <- renderPlot({comPlotter(Germany(), BW(), resultM())
                })
        }
)

