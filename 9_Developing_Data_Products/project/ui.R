# Check and install packages as necessary
if(!("shiny" %in% rownames(installed.packages()))) {install.packages("shiny")}
if(!("markdown" %in% rownames(installed.packages()))) {install.packages("markdown")}

# Initialise
library(shiny)
library(markdown)

shinyUI(
  navbarPage("Flower species predictor",
    tabPanel("Use the App",
      sidebarPanel(
        width = 8,
        h3("Use the sliders to plot your flower against species from the iris dataset"),
        
        # Graphs
        fluidRow(
          splitLayout(cellWidths = c("25%", "25%", "25%", "25%"),
            plotOutput("plotSepalWidth", height = "180px"),
            plotOutput("plotSepalLength", height = "180px"),
            plotOutput("plotPetalWidth", height = "180px"),
            plotOutput("plotPetalLength", height = "180px")
          )),
                 
        # Sliders
        fluidRow(
          splitLayout(cellWidths = c("25%", "25%", "25%", "25%"),
            sliderInput("sepalWidth", 
              "Width of sepal:", 
              min = round(min(iris$Sepal.Width) / 2, 1),
              max = round(max(iris$Sepal.Width) * 1.25, 1),
              value = round(mean(iris$Sepal.Width), 1)),
            sliderInput("sepalLength", 
              "Length of sepal:",
              min = round(min(iris$Sepal.Length) / 2, 1),
              max = round(max(iris$Sepal.Length) * 1.25, 1),
              value = round(mean(iris$Sepal.Length), 1)),
            sliderInput("petalWidth", 
              "Width of petal:", 
              min = round(min(iris$Petal.Width) / 2, 1),
              max = round(max(iris$Petal.Width) * 1.25, 1),
              value = round(mean(iris$Petal.Width), 1)),
            sliderInput("petalLength", 
              "Length of petal:",
              min = round(min(iris$Petal.Length) / 2, 1),
              max = round(max(iris$Petal.Length) * 1.25, 1),
              value = round(mean(iris$Petal.Length ), 1))
            )),
        
        # Actions        
        actionButton(
          inputId = "submitBtn",
          label = "Classify your flower"
          ),
        actionButton(
          inputId = "resetBtn",
          label = "Reset"
          )
        ),
   
      mainPanel(
        width = 4,
        tabsetPanel(
          tabPanel(p(icon("table"), "Classify your iris"),                             
            h1("Prediction"),
            p("Choose your measurements using the sliders and press 'Classify your flower'."),
            p("Probabilities shown below for being a member of each species of iris"),
            tableOutput("prediction")
          )
        )
      )
    ),
    tabPanel(p(icon("info"), "Documentation"), mainPanel(includeMarkdown("about.Rmd")))
  )
)
