Coursera Data Science: Capstone Project
========================================================
author: Nick Plummer (@nickopotamus)
date: November 1, 2018
autosize: True

Overview
========================================================

- [The Shiny app](https://nickopotamus.shinyapps.io/capstone/) uses Natural Language Processing techniques to try to preduce the next word as a user types a sentence, similar to the way most smart phone keyboards are implemented today.

- Data was derived from the English language [Heliohost Corpora](http://www.corpora.heliohost.org/) blogs, news, and Twitter databases.

- Data was subset (for memory handling issued), cleaned and processed, tokenized, and n-grams devired as described in the [Milestone Report](https://rpubs.com/nickopotamus/422734). 

How to use
========================================================

- [Visit the app](https://nickopotamus.shinyapps.io/capstone/) and enter a word or phrase. The next predicted word is displayed along with the N-gram used to generate it.
![Instructions](./app.png)


Acquiring, cleaning, and processing of data
========================================================

- [scripts.R](https://github.com/nickopotamus/datasciencecoursera/blob/master/10_Capstone/app/scripts.R) contains code used to process the data.
- A subset of the original data was sampled from the three sources (blogs,twitter and news) and merged. 3% of the original Corpus was used due to memory handling issues by Java and R.
- Data cleaning was performed by conversion to lowercase, striping punctuation and white space, discarding numbers and urls, and removing [profanity words](http://www.cs.cmu.edu/~biglou/resources/). Note stopwords were not stripped, as in the milestone report, as this lead to loops and poor predictions.
- The corresponding n-grams are then created (Quadgram, Trigram and Bigram) and term-count tables extracted and sorted according to frequency.
- The n-gram objects are saved as R-Compressed files which can be accessed by the app.

Predicition algorithm
========================================================

- The alrogithm uses an N-gram model with ["Stupid Backoff"](http://www.cs.columbia.edu/~smaskey/CS6998-0412/supportmaterial/langmodel_mapreduce.pdf), which checks if highest-order n-gram has been seen, and degrades to a lower-order model if not. 
- n=4 was used due to the cap on ShinyApps size.


```r
predictWord <- function(the_word) {
  # word_add <- clean(the_word)
  the_word <- strsplit(word_add, " ")[[1]]
  n <- length(the_word)
  # Back off algorithm
    if (n>= 3) {} # Display 4-gram }
    else if (n == 2){} # Display 3-gram
    else if (n == 1){ # Display 2-gram
    # Otherwise return "it"
  }
}
```


Comments and further development
========================================================

- The complete code used is available on [GitHub](https://github.com/nickopotamus/datasciencecoursera/tree/master/10_Capstone/app).
- The primary weakness of this approach is lack of long-range context, as the algorithm discards contextual information past 4-grams. This is due to a combination of ShinyApp limits on data, and the lack of meaningful 5-grams generated from only 3% of the corpora, used due to memory handling issues by Java and R.
- Future development should focus on clustering underlying training data and predicting what cluster the entire sentence would fall into, which would enable prediction using only the subset of the data which fits the long-range context of the sentence, while still preserving the performance characteristics of an n-gram and Stupid Backoff model.
