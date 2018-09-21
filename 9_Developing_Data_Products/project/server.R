# Check and install packages as necessary
if(!("shiny" %in% rownames(installed.packages()))) {install.packages("shiny")}
if(!("lattice" %in% rownames(installed.packages()))) {install.packages("lattice")}
if(!("ggplot2" %in% rownames(installed.packages()))) {install.packages("ggplot2")}
if(!("e1071" %in% rownames(installed.packages()))) {install.packages("e1071")}
if(!("caret" %in% rownames(installed.packages()))) {install.packages("caret")}
if(!("randomForest" %in% rownames(installed.packages()))) {install.packages("randomForest")}

# Initialise
library(shiny)
library(lattice)
library(ggplot2)
library(e1071)
library(caret)
library(randomForest)
set.seed(69)

# Random Forest model
buildRFModel <- function() {
  fitControl <- trainControl(method = "cv", number = 5)
  fitRF <- train(Species ~ ., data = iris, method = "rf", trControl = fitControl)
  return(fitRF)
}

# Fit to model
predictIris <- function(trainedModel, inputs) {
  prediction <- predict(trainedModel, newdata = inputs, type = "prob", predict.all = TRUE)
  return(renderTable(prediction))
}

# Server
shinyServer(
  function(input, output, session) {
    data(iris)
    
    # Lengths
    output$outputSepalWidth <- renderText(input$sepalWidth)
    output$outputSepalLength <- renderText(input$sepalLength)
    output$outputPetalWidth <- renderText(input$petalWidth)
    output$outputPetalLength <- renderText(input$petalLength)
    
    # SDs        
    output$outputSepalWidthSD <- renderText(sd(iris$Sepal.Width))
    output$outputSepalLengthSD <- renderText(sd(iris$Sepal.Length))
    output$outputPetalWidthSD <- renderText(sd(iris$Petal.Width))
    output$outputPetalLengthSD <- renderText(sd(iris$Petal.Length))
    
    # Means        
    output$outputSepalWidthMean <- renderText(mean(iris$Sepal.Width))
    output$outputSepalLengthMean <- renderText(mean(iris$Sepal.Length))
    output$outputPetalWidthMean <- renderText(mean(iris$Petal.Width))
    output$outputPetalLengthMean <- renderText(mean(iris$Petal.Length))
            
    output$plotSepalWidth <- renderPlot({
      ggplot(iris, aes(x = Sepal.Width, group = Species, fill = as.factor(Species))) + 
        geom_density(position = "identity", alpha = 0.5) +
        scale_fill_discrete(name = "Species") +
        theme_void() +
        xlab("Sepal Width") +
        geom_vline(xintercept = input$sepalWidth, color = "red", size = 1) +
        scale_x_continuous(limits = c(round(min(iris$Sepal.Width) / 2, 1), round(max(iris$Sepal.Width) * 1.25, 1)))
      })
            
    output$plotSepalLength <- renderPlot({
      ggplot(iris, aes(x = Sepal.Length, group = Species, fill = as.factor(Species))) + 
        geom_density(position = "identity", alpha = 0.5) +
        scale_fill_discrete(name = "Species") +
        theme_void() +
        xlab("Sepal Length") +
        geom_vline(xintercept = input$sepalLength, color = "red", size = 1) +
        scale_x_continuous(limits = c(round(min(iris$Sepal.Length) / 2, 1), round(max(iris$Sepal.Length) * 1.25, 1)))
      })
            
    output$plotPetalWidth <- renderPlot({
      ggplot(iris, aes(x = Petal.Width, group = Species, fill = as.factor(Species))) + 
        geom_density(position = "identity", alpha = 0.5) +
        scale_fill_discrete(name = "Species") +
        theme_void() +
        xlab("Petal Width") +
        geom_vline(xintercept = input$petalWidth, color = "red", size = 1) +
        scale_x_continuous(limits = c(round(min(iris$Petal.Width) / 2, 1),
        round(max(iris$Petal.Width) * 1.25, 1)))
      })
            
    output$plotPetalLength <- renderPlot({
      ggplot(iris, aes(x = Petal.Length, group = Species, fill = as.factor(Species))) + 
        geom_density(position = "identity", alpha = 0.5) +
        scale_fill_discrete(name = "Species") +
        theme_void() +
        xlab("Petal Length") +
        geom_vline(xintercept = input$petalLength, color = "red", size = 1) +
        scale_x_continuous(limits = c(round(min(iris$Petal.Length) / 2, 1), round(max(iris$Petal.Length) * 1.25, 1)))
      })
            
    builtModel <- reactive({
      buildRFModel()
      })
            
    observeEvent(
      eventExpr = input[["submitBtn"]],
      handlerExpr = {
        withProgress(message = 'Just a moment...', value = 0, {
          myModel <- builtModel()
          })
        Sepal.Length <- input$sepalLength
        Sepal.Width <- input$sepalWidth
        Petal.Length <- input$petalLength
        Petal.Width <- input$petalWidth
        myEntry <- data.frame(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width)
        myPrediction <- predictIris(myModel, myEntry)
        output$prediction <- myPrediction
        })
            
    observeEvent(input[["resetBtn"]], {
      updateNumericInput(session, "sepalWidth", value = round(mean(iris$Sepal.Width), 1))
      updateNumericInput(session, "sepalLength", value = round(mean(iris$Sepal.Length), 1))
      updateNumericInput(session, "petalWidth", value = round(mean(iris$Petal.Width), 1))
      updateNumericInput(session, "petalLength", value = round(mean(iris$Petal.Length), 1))
      })
  }
)