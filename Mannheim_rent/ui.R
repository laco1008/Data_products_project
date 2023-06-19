

library(shiny)
shinyUI(fluidPage(
        titlePanel("Rent in Mannheim"),
        sidebarPanel(
                sliderInput("size",
                            "Size of your apartment (in m2)", 
                            value = 20,
                            min = 10, 
                            max = 150, 
                            step = 1),
                checkboxGroupInput("comp", 
                                   "Compare to average:",
                                   c("Germany", "Baden-Wuerttemberg")),
                h4("With this webapp you can calculate the expected rent in Mannheim, Germany. I decided to do this project, as I will soon relocate to Mannheim. "),
                h4("To use it, select the size of the apartment in m2 with the slider!"),
                h4("If you are interested, you can have a barchart comparing the averages of Mannheim to Germany and Baden-Württemberg."),
                h4("You can select which region you want to compare to."),
                h4("If nothing is selected, only Mannheim will be displayed on the plot."),
                h4("The source of the rent data is the Immowelt Mietspiegel as of 19.06.2023."),
                a(href = "https://www.immowelt.de/immobilienpreise/mannheim/mietspiegel", "Mannheim"),
                a(href = "https://www.immowelt.de/immobilienpreise/deutschland/mietspiegel", "Germany"),
                a(href = "https://www.immowelt.de/immobilienpreise/bl-baden-wuerttemberg/mietspiegel", "Baden-Württemberg")),
        mainPanel(
                h1("Results"),
                h3("Expected cold rent in €"),
                verbatimTextOutput("ExpCold"),
                h3("Expected extra costs in €"),
                verbatimTextOutput("ExpEx"),
                h3("Expected warm rent in €"),
                verbatimTextOutput("ExpWarm"),
                h1("Comparisons (if selected)"),
                plotOutput("comPlot")
        )
))
