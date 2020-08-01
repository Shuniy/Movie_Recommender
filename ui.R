## ui.R
library(shiny)
library(shinydashboard)
library(proxy)
library(recommenderlab)
library(reshape2)
library(plyr)
library(dplyr)
library(DT)
library(RCurl)
library(shinythemes)

movies <- read.csv("movies.csv", header = TRUE, stringsAsFactors=FALSE)
movies <- movies[with(movies, order(title)), ]

ratings <- read.csv("ratings100k.csv", header = TRUE)


shinyUI(dashboardPage(skin = "purple",
                      dashboardHeader(title = "Movie Recommendation"),
                      dashboardSidebar(
                        sidebarMenu(
                          menuItem("Movies", tabName = "movies", icon = icon("star")),
                          menuItem(
                            list(
                              selectInput("select", label = h5("Select 3 Movies That You Like"),
                                          choices = as.character(movies$title[1:length(unique(movies$movieId))]),
                                          selectize = FALSE,
                                          selected = "Shawshank Redemption, The (1994)"),
                              selectInput("select2", label = "",
                                          choices = as.character(movies$title[1:length(unique(movies$movieId))]),
                                          selectize = FALSE,
                                          selected = "Insomnia (2002)"),
                              selectInput("select3", label = "",
                                          choices = as.character(movies$title[1:length(unique(movies$movieId))]),
                                          selectize = FALSE,
                                          selected = "3 Idiots (2009)"),
                              submitButton("Submit")
                            )
                          )
                        )
                      ),
                      dashboardBody(
                        tabItems(
                          tabItem(tabName = "movies",
                                  fluidRow(
                                    box(
                                      width = 8, status = "info", solidHead = TRUE,
                                      title = "Movies You Might Like",
                                      tableOutput("table")),
                                    valueBoxOutput("tableRatings1"),
                                    valueBoxOutput("tableRatings2"),
                                    valueBoxOutput("tableRatings3"),
                                    box(DT::dataTableOutput("myTable", width = "100%", height = "auto"), title = "All Movies", width = 12, collapsible = TRUE)
                                )
                            )
                        )
                    )
              )
          )              