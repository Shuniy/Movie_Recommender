#server.R
library(plyr)
library(dplyr)

source("Working.R")
# Loading data
movies <- read.csv("movies.csv", header = TRUE, stringsAsFactors=FALSE)
movies <- movies[with(movies, order(title)), ]
ratings <- read.csv("ratings100k.csv", header = TRUE)

movie.ratings <- merge(ratings, movies)
movie_ratings <- movie.ratings %>% group_by(title) %>% 
  mutate(Average_Ratings = round(sum(rating)/length(rating), 2))

movie_ratings <- movie_ratings[-c(1,2,3,4)] %>% unique()

# shiny server
shinyServer(function(input, output) {
  
  # Text for the 3 boxes showing average scores
    formulaText1 <- reactive({
      paste(input$select)
    })
    formulaText2 <- reactive({
      paste(input$select2)
    })
    formulaText3 <- reactive({
      paste(input$select3)
    })

    output$movie1 <- renderText({
      formulaText1()
    })
    output$movie2 <- renderText({
      formulaText2()
    })
    output$movie3 <- renderText({
      formulaText3()
    })
    
  
    # Table containing recommendations
    output$table <- renderTable({
      
      # Filter for based on genre of selected movies to enhance recommendations
      cat1 <- subset(movies, title == input$select)
      cat2 <- subset(movies, title == input$select2)
      cat3 <- subset(movies, title == input$select3)
      
      # If genre contains 'Sci-Fi' then  return sci-fi movies 
      # If genre contains 'Children' then  return children movies
      if (grepl("Sci-Fi", cat1$genres) | grepl("Sci-Fi", cat2$genres) | grepl("Sci-Fi", cat3$genres)) {
        movies2 <- (movies[grepl("Sci-Fi", movies$genres) , ])
      } else if (grepl("Children", cat1$genres) | grepl("Children", cat2$genres) | grepl("Children", cat3$genres)) {
        movies2 <- movies[grepl("Children", movies$genres), ]
      } else {
        movies2 <- movies[grepl(cat1$genres, movies$genres) | grepl(cat2$genres, movies$genres) | grepl(cat3$genres, movies$genres), ]
      }
      # User based collaborative filtering
      movie_recommendation(input$select, input$select2, input$select3, movies2, ratings, movie_ratings)

    })
    output$tableRatings1 <- renderValueBox({
      movie.avg1 <- summarise(subset(movie.ratings, title == input$select),
                              Average_Rating1 = mean(rating, na.rm = TRUE))
      valueBox(
        value = format(movie.avg1, digits = 3),
        subtitle = input$select,
        icon = if (movie.avg1 >= 3) icon("thumbs-up") else icon("thumbs-down"),
        color = if (movie.avg1 >= 3) "purple" else "red"
      )
      
    })
    
    output$tableRatings2 <- renderValueBox({
      movie.avg2 <- summarise(subset(movie.ratings, title == input$select2),
                              Average_Rating = mean(rating, na.rm = TRUE))
      valueBox(
        value = format(movie.avg2, digits = 3),
        subtitle = input$select2,
        icon = if (movie.avg2 >= 3) icon("thumbs-up") else icon("thumbs-down"),
        color = if (movie.avg2 >= 3) "purple" else "red"
      )
    })
    output$tableRatings3 <- renderValueBox({
      movie.avg3 <- summarise(subset(movie.ratings, title == input$select3),
                              Average_Rating = mean(rating, na.rm = TRUE))
      valueBox(
        value = format(movie.avg3, digits = 3),
        subtitle = input$select3,
        icon = if (movie.avg3 >= 3) icon("thumbs-up") else icon("thumbs-down"),
        color = if (movie.avg3 >= 3) "purple" else "red"
      )
    })
    
    # Generate a table summarizing each players stats
    output$myTable <- renderDataTable({
      movie_ratings[c("title", "genres", "Average_Ratings")]
    })  
}
)

