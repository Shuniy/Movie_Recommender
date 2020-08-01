library(recommenderlab)
library(reshape2)

# user based collaborative filtering
movie_recommendation <- function(input,input2,input3, movies2, ratings, movie_ratings){
    row_num <- which(movies2[,2] == input)
    row_num2 <- which(movies2[,2] == input2)
    row_num3 <- which(movies2[,2] == input3)
    userSelect <- matrix(NA , length(unique(ratings$movieId)))
    userSelect[row_num] <- movie_ratings[which(movie_ratings$title == input),]$Average_Ratings
    userSelect[row_num2] <- movie_ratings[which(movie_ratings$title == input2),]$Average_Ratings
    userSelect[row_num3] <- movie_ratings[which(movie_ratings$title == input3),]$Average_Ratings
    userSelect <- as.data.frame(t(userSelect)) # transpose
    
    ratingmatrix <- reshape2::dcast(ratings, userId ~ movieId, value.var = "rating", na.rm = FALSE)
    ratingmatrix <- ratingmatrix[,-1]
    colnames(userSelect) <- colnames(ratingmatrix)
    
    ratingmatrix <- rbind(userSelect, ratingmatrix)
    ratingmatrix <- as.matrix(ratingmatrix)
    
    #Convert rating matrix into a sparse matrix
    ratingmatrix <- as(ratingmatrix, "realRatingMatrix")
    #Create Recommender Model
    recommender_model <- Recommender(ratingmatrix, method = "UBCF", param = list(method = "Cosine", nn = 10))
    # Predicting from the input
    recom <- predict(recommender_model, ratingmatrix[1], n = 30)
    recom_list <- as(recom, "list")
    recom_result <- data.frame(matrix(NA, 30))
    recom_result[1:30, 1] <- movies2[as.integer(recom_list[[1]][1:30]), 2]
    recom_result <- data.frame(na.omit(recom_result[order(order(recom_result)),]))
    recom_result <- data.frame(recom_result[1:10,])
    colnames(recom_result) <- "User-Based Collaborative Filtering Recommendations"
    return(recom_result)
}
