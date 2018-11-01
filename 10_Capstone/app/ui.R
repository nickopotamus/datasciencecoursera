library(shiny)
library(markdown)

shinyUI(
  fluidPage(
    titlePanel("Coursera Data Science Specialisation: Capstone Project"),
    sidebarLayout(
      sidebarPanel(
        helpText("Enter a word (or try a partial sentence) and the app predicts the next word"),
        hr(),
        textInput("inputText", "Enter text here",value = ""),
        hr(),
        helpText("After inputting text the next predicted word will be shown, along with the prediction model used to generate it.", 
                 hr(),
                 "Predictions derived from the ", a("Heliohost Corpora", href="http://www.corpora.heliohost.org/"), " using N-gram tokenization as part of the ", a("Coursera Data Science Specialisation.", href="https://www.coursera.org/specializations/jhu-data-science"),
                 hr(),
                 "Project pitch can be downloaded from ", a("RPubs", href="http://rpubs.com/nickopotamus/pitch"), " and sourcecode from ", a("Github", href="https://github.com/nickopotamus/datasciencecoursera/tree/master/10_Capstone/app")
                 ),
        hr()
      ),
      mainPanel(
        h2("Predicted next word:"),
        verbatimTextOutput("prediction"),
        strong("Text entered:"),
        textOutput('sentence1'),
        br(),
        strong("Prediction model:"),
        textOutput('sentence2'),
        hr()
      )
    )
  )
)


