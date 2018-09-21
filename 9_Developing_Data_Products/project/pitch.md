Developing Data Products: Course project pitch
========================================================
author: Nick Plummer
date: September 21st, 2018
autosize: true

Introduction
========================================================

This presentation is part of the Developing Data Products Coursera.org course project submission. It is a pitch for my Shiny application, which allows the user to enter measured values for a flower and attempts to classify this into one of three species of iris.

Flower prediction app
========================================================

The Shiny app  classifies an iris flower as one of the 3 species available in the iris dataset, based on septal and petal lengths and widths input using the sliders, and outputting probabilities of the flower belonging to the species using a random forests model trained on the complete 'iris' dataset.


```r
RFModel <- function() {
  fitControl <- trainControl(method = "cv", number = 5)
  fitRF <- train(Species ~ ., data = iris, method = "rf", trControl = fitControl)
  return(fitRF)
}
```

Try the app
========================================================
- [Use the app on ShinyApps](https://nickopotamus.shinyapps.io/DDP_Project/)
- [Source code on Github](https://github.com/nickopotamus/datasciencecoursera/tree/master/9_Developing_Data_Products/project)
