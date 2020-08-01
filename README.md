# Movie Recommender
***A Shiny application which recommends movies by the principle of Collaborative filtering. It works by predicting the similar movies by genre same as the movies selected by the user as per their interest.***

The data is collected from [here.](https://grouplens.org/datasets/movielens/)

>*The method used here was **UBCF(User Based Collaborative Filter)** and the **Similarity Calculation Method was based on Cosine Similarity.** The Nearest Neighbors was set to 30.The predicted item ratings of the user will be derived from the 5 nearest neighbors in its neighborhood. When the predicted item ratings are obtained, top 10 most highly predicted ratings will be returned as the recommendations.*

### Packages Used
- R
- Shiny
- shinythemes
- DT
- RCurl
- dplyr
- recommenderlab
- proxy
