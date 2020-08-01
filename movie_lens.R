# Loading libraries
library(recommenderlab)
library(reshape2)

#loading data
movies <- read.csv("movies.csv", header = TRUE, stringsAsFactors = FALSE)
ratings <- read.csv("ratings.csv", header = TRUE, stringsAsFactors = FALSE)

#Creating ratings matrix. Rows = userId, Columns = movieId
ratingmatrix <- dcast(ratings, userId ~ movieId, value.var = "rating", na.rm = FALSE)

# Removing userid and converting to matrix 
ratingmatrix <- as.matrix(ratingmatrix[,-1]) 

# Model

#Converting rating matrix into a recommenderlab sparse matrix
ratingmatrix <- as(ratingmatrix, "realRatingMatrix")

#Normalizeing the data
ratingmatrix_norm <- normalize(ratingmatrix)

#Creating UBCF Recommender Model. "UBCF" stands for User-Based Collaborative Filtering
recommender_model <- Recommender(ratingmatrix, method = "UBCF", param = list(method = "Cosine", nn = 30))

#Obtaining top 10 recommendations for 1st user in dataset
recom <- predict(recommender_model, ratingmatrix[1], n = 10)

#convert recommenderlab object to readable list
recom_list <- as(recom, "list")

#Obtaining Top-10 recommendations
recom_result <- matrix(0,10)

for (i in c(1:10)){
  recom_result[i] <- as.integer(recom_list[[1]][i])
}

recom_result <- as.data.frame(movies[recom_result,2])
colnames(recom_result) <- list("Top 10 Movies")
recom_result

# Performing 5-fold cross validation. given = 3 meaning 3 items withheld for evaluation
evaluation_scheme <- evaluationScheme(ratingmatrix, method = "cross-validation", k = 5, given = 3, goodRating = 5) 

# Algorithms to perform
algorithms <- list(
  "random items" = list(name = "RANDOM", param = NULL),
  "popular items" = list(name = "POPULAR", param = NULL),
  "user-based CF" = list(name = "UBCF", param = list(method = "Cosine", nn = 30))
)

# Evaluating algorithms
evaluation_results <- evaluate(evaluation_scheme, algorithms, n = c(1, 3, 5, 10, 15, 20))

# plotting the averaged ROC
plot(evaluation_results) 

# plotting the averaged prec/rec
plot(evaluation_results, "prec/rec") 

#getting results for all runs of 'popular items'
eval_results <- getConfusionMatrix(evaluation_results[[2]]) 

# Getting averaged result for 'popular items'
avg(evaluation_results[[2]])
