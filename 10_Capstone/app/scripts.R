# Setup
rm(list = ls())
options(java.parameters = "-Xmx8000m") # Deals w/ Java heap space error)
setwd("~/Dropbox/git/datasciencecoursera/10_Capstone")
library(NLP)
library(tm)
library(rJava)
library(RWeka)

# Import raw data
blogs <-   readLines(file("./final/en_US/en_US.blogs.txt", open = "rb"), 
                     encoding = "UTF-8", skipNul=TRUE)
news <-    readLines(file("./final/en_US/en_US.news.txt", open = "rb"), 
                     encoding = "UTF-8", skipNul=TRUE)
twitter <- readLines(file("./final/en_US/en_US.twitter.txt", open = "rb"),
                     encoding = "UTF-8",skipNul=TRUE)

# Sampling to make data manageable
set.seed(69)
portion <- .03

sampletext <- function(textbody, portion) {
  taking <- sample(1:length(textbody), length(textbody)*portion)
  Sampletext <- textbody[taking]
  Sampletext
}

sampleTwitter <- sampletext(twitter, portion)
sampleNews <- sampletext(news, portion)
sampleBlogs <- sampletext(blogs, portion)

textSample <- c(sampleTwitter,sampleNews,sampleBlogs)
writeLines(textSample, "./data/textsample/textSample.txt")
rm(sampleTwitter, sampleNews, sampleBlogs)
rm(twitter, news, blogs)

# Data Cleansing 
cleanSample <- VCorpus(DirSource("./data/textSample", encoding = "UTF-8"))

removeURL <- function(x) gsub("http[[:alnum:]]*", "", x) 
profanityWords <- readLines("./data/profanityWords.txt")
cleansing <- function (textcp) {
  textcp <- tm_map(textcp, content_transformer(tolower))
  textcp <- tm_map(textcp, content_transformer(removePunctuation), preserve_intra_word_dashes = TRUE)
  textcp <- tm_map(textcp, stripWhitespace)
  textcp <- tm_map(textcp, content_transformer(removeNumbers))
  textcp <- tm_map(textcp, content_transformer(removeURL))
# textcp <- tm_map(textcp, removeWords, stopwords("english"))
  textcp <- tm_map(textcp, removeWords, profanityWords)
  textcp
}

cleanSample <- cleansing(cleanSample)
saveRDS(cleanSample, file = "./data/cleanSample.Rds")
rm(textSample, profanityWords)

# Function to make N-grams
tdm_Ngram <- function (textcp, n) {
  NgramTokenizer <- function(x) {
    RWeka::NGramTokenizer(x, 
                          RWeka::Weka_control(min = n,
                                              max = n,
                                              delimiters = " \\r\\n\\t.,;:\"()?!")
    )
  }
  tdm_ngram <- TermDocumentMatrix(textcp, control = list(tokenizer = NgramTokenizer))
  tdm_ngram
}

# Function to extract and sort N-grams
ngram_sorted_df <- function (tdm_ngram) {
  tdm_ngram_m <- as.matrix(tdm_ngram)
  tdm_ngram_df <- as.data.frame(tdm_ngram_m)
  colnames(tdm_ngram_df) <- "Count"
  tdm_ngram_df <- tdm_ngram_df[order(-tdm_ngram_df$Count), , drop = FALSE]
  tdm_ngram_df
}

# Calculate N-Grams
tdm_1gram <- tdm_Ngram(cleanSample, 1)
tdm_2gram <- tdm_Ngram(cleanSample, 2)
tdm_3gram <- tdm_Ngram(cleanSample, 3)
tdm_4gram <- tdm_Ngram(cleanSample, 4)

# Extract term-count tables from N-Grams and sort 
tdm_1gram_df <- ngram_sorted_df(tdm_1gram)
tdm_2gram_df <- ngram_sorted_df(tdm_2gram)
tdm_3gram_df <- ngram_sorted_df(tdm_3gram)
tdm_4gram_df <- ngram_sorted_df(tdm_4gram)

# Save data frames into r-compressed files
quadgram <- data.frame(rows = rownames(tdm_4gram_df), count = tdm_4gram_df$Count)
quadgram$rows <- as.character(quadgram$rows)
quadgram_split <- strsplit(as.character(quadgram$rows),split = " ")
quadgram <- transform(quadgram,
                      first = sapply(quadgram_split,"[[",1),
                      second = sapply(quadgram_split,"[[",2),
                      third = sapply(quadgram_split,"[[",3), 
                      fourth = sapply(quadgram_split,"[[",4))
quadgram <- data.frame(unigram = quadgram$first,
                       bigram = quadgram$second, 
                       trigram = quadgram$third, 
                       quadgram = quadgram$fourth, 
                       freq = quadgram$count,stringsAsFactors=FALSE)
write.csv(quadgram[quadgram$freq > 1,],"./data/quadgram.csv",row.names=F)
quadgram <- read.csv("./data/quadgram.csv",stringsAsFactors = F)
saveRDS(quadgram,"./app/quadgram.RData")

trigram <- data.frame(rows=rownames(tdm_3gram_df),count=tdm_3gram_df$Count)
trigram$rows <- as.character(trigram$rows)
trigram_split <- strsplit(as.character(trigram$rows),split=" ")
trigram <- transform(trigram,
                     first = sapply(trigram_split,"[[",1),
                     second = sapply(trigram_split,"[[",2),
                     third = sapply(trigram_split,"[[",3))
trigram <- data.frame(unigram = trigram$first,
                      bigram = trigram$second, 
                      trigram = trigram$third, 
                      freq = trigram$count,stringsAsFactors=FALSE)
write.csv(trigram[trigram$freq > 1,],"./data/trigram.csv",row.names=F)
trigram <- read.csv("./data/trigram.csv",stringsAsFactors = F)
saveRDS(trigram,"./app/trigram.RData")

bigram <- data.frame(rows=rownames(tdm_2gram_df),count=tdm_2gram_df$Count)
bigram$rows <- as.character(bigram$rows)
bigram_split <- strsplit(as.character(bigram$rows),split=" ")
bigram <- transform(bigram,
                    first = sapply(bigram_split,"[[",1),
                    second = sapply(bigram_split,"[[",2))
bigram <- data.frame(unigram = bigram$first,
                     bigram = bigram$second, 
                     freq = bigram$count,stringsAsFactors=FALSE)
write.csv(bigram[bigram$freq > 1,],"./data/bigram.csv",row.names=F)
bigram <- read.csv("./data/bigram.csv",stringsAsFactors = F)
saveRDS(bigram,"./app/bigram.RData")

unigram <- data.frame(rows=rownames(tdm_1gram_df),count=tdm_1gram_df$Count)
unigram$rows <- as.character(unigram$rows)
unigram_split <- strsplit(as.character(unigram$rows),split=" ")
unigram <- transform(unigram,
                     first = sapply(unigram_split,"[[",1))
unigram <- data.frame(unigram = unigram$first,
                      freq = unigram$count,
                      stringsAsFactors=FALSE)
write.csv(unigram[unigram$freq > 1,],"./data/unigram.csv",row.names=F)
unigram <- read.csv("./data/unigram.csv",stringsAsFactors = F)
saveRDS(unigram,"./app/unigram.RData")