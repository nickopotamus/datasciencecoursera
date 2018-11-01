# Set up shiny server
library(shiny)
library(stringr)
library(tm)

# Load n-gram frequencies words matrixes
quadgram <- readRDS("quadgram.RData");
trigram <- readRDS("trigram.RData");
bigram <- readRDS("bigram.RData");
message <- "" ## cleaning message


# Function to predict the next word
predictWord <- function(the_word) {
  # Clean input word
  word_add <- stripWhitespace(
    removeNumbers(
      removePunctuation(
        tolower(the_word),
        preserve_intra_word_dashes = TRUE)))
  the_word <- strsplit(word_add, " ")[[1]]
  n <- length(the_word)
  # Back off algorithm
  if (n>= 3) {
    the_word <- tail(the_word,3)
    if (identical(character(0),head(quadgram[quadgram$unigram == the_word[1] & quadgram$bigram == the_word[2] & quadgram$trigram == the_word[3], 4],1))){
      predictWord(paste(the_word[2],the_word[3],sep=" "))
    }
    else {message <<- "Next word is predicted using 4-gram."; head(quadgram[quadgram$unigram == the_word[1] & quadgram$bigram == the_word[2] & quadgram$trigram == the_word[3], 4],1)}
  }
  else if (n == 2){
    the_word <- tail(the_word,2)
    if (identical(character(0),head(trigram[trigram$unigram == the_word[1] & trigram$bigram == the_word[2], 3],1))) {
      predictWord(the_word[2])
    }
    else {message<<- "Next word is predicted using 3-gram."; head(trigram[trigram$unigram == the_word[1] & trigram$bigram == the_word[2], 3],1)}
  }
  else if (n == 1){
    the_word <- tail(the_word,1)
    if (identical(character(0),head(bigram[bigram$unigram == the_word[1], 2],1))) {message<<-"No n-gram match found - returning the most used English word 'it'"; head("it",1)}
    else {message <<- "Next word is predicted using 2-gram."; head(bigram[bigram$unigram == the_word[1],2],1)}
  }
}

# Shiney server code to call predictWord
shinyServer(function(input, output) {
  output$prediction <- renderPrint({
    result <- predictWord(input$inputText)
    output$sentence2 <- renderText({message})
    result
  });
  output$sentence1 <- renderText({
    input$inputText});
}
)