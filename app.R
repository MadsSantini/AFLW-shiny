library(shiny)
library(tidyr)
library(readr)
library(dplyr)
library(ggplot2)
library(formattable)
customPurp <- '#3b1876'
customOrng <- '#ff5e45'
customGry <- '#6b748b'

aflw_score_stats <- read_csv("aflw_stats.csv")
metriclabels <- c(score = "Score", scorediff = "Score difference", ratio = "Goal to behind ratio")

# Define UI for application that draws a histogram
ui <- fluidPage(
  theme = shinythemes::shinytheme(theme="united"),
  navbarPage("AFLW Score Data",
    tabPanel("Team Data",  
       # Sidebar with a slider input for number of bins 
       sidebarLayout(
          sidebarPanel(
             sliderInput("bins",
                         "Number of bins:",
                         min = 1,
                         max = 20,
                         value = 10),
             selectInput("teams","Select a Team:",choices = aflw_score_stats$team,selected = "Carlton")
          ),
        
        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot")
        )
     )
    ),
    
    tabPanel("Match Data",
       # Sidebar with multiple inputs - season, round, and dynamic match selection.
       sidebarLayout(
         sidebarPanel(
           selectInput("seasons","Select a Season:",choices = aflw_score_stats$season,selected = "2020"),
           selectInput("rounds","Select a Round:",choices = aflw_score_stats$round_number,selected = 1),
           uiOutput("matchnames")
         ),
        # Will need to render plots here
        mainPanel(
          formattableOutput("matchTable")
        )
       )
    ),

    tabPanel("Season Data",
       # Sidebar with multiple inputs - season, round, and dynamic match selection.
       sidebarLayout(
         sidebarPanel(
           selectInput("metrics","Select a metric:",choices = c("Score" = "score","Score difference" = "scorediff","Goal to Behind Ratio" = "ratio"),selected = "score"),
           selectInput("lineseasons","Select a Season:",choices = aflw_score_stats$season,selected = "2020"),
           selectInput("teams1","Select the first Team:",choices = aflw_score_stats$team,selected = "Carlton"),
           selectInput("teams2","Select the second Team:",choices = aflw_score_stats$team,selected = "Adelaide Crows")
         ),
         #Render plots
         mainPanel(
           plotOutput("linePlot")
         )
       )
    ),
    tabPanel("About",
             fluidRow(column(10,
                             includeMarkdown('about.md')
                             )
                      )
             )
  )
)

# Define server logic required to draw the plots etc
server <- function(input, output) {
   
   output$distPlot <- renderPlot({
      # draw the histogram with the specified number of bins
      ggplot(data = filter(aflw_score_stats, team == input$teams), aes(score)) + 
        geom_histogram(bins = input$bins, fill = customPurp, colour = customGry) +
        theme_bw() +
        labs(title = paste('Histogram of', input$teams, 'Scores'),x = 'Score', y = 'Count') +
        theme(plot.title = element_text(face = 'bold', size = 20, color = customPurp))
   })
   output$linePlot <- renderPlot({
     ggplot(data = filter(aflw_score_stats, season == input$lineseasons, team == input$teams1 | team == input$teams2), 
         aes_string(x='round_number',y=input$metrics)) +
       geom_line(aes(color = team),size=1.5) +
       theme_bw() +
       labs(title = paste('Chart of',input$lineseasons, input$teams1, 'and',input$teams2,as.character(metriclabels[input$metrics])),
       x = 'Round', y=as.character(metriclabels[input$metrics])) +
       theme(plot.title = element_text(face = 'bold',size = 20,color = customPurp)) +
       scale_color_manual(values = c(customPurp,customOrng))
   })
   output$matchnames <- renderUI({
        match_name <- filter(aflw_score_stats,season == input$seasons,round_number == input$rounds)$match_title
        selectInput("matches","Choose a Match:",choices = match_name)
   })
   output$matchTable <- renderFormattable ({
     data <- filter(
       aflw_score_stats,
       season == input$seasons,
       round_number == input$rounds,
       match_title == req(input$matches)
     ) %>%
       select(team, score, goals, behinds, ratio) %>%
       mutate(ratio = format(ratio,digits = 2))
     formattable(data,col.names = c("Team","Score","Goals","Behinds","Goal to Behind Ratio"),
       list(`score` = formatter("span", style = ~ style(
         display = "inline-block",
         direction = "rtl",
         "border-radius" = "4px",
         "padding-right" = "2px",
         "background-color" = customPurp,
         width = percent(proportion(score)),
         color = '#ffffff'
         )),
       `team` = formatter('span', style = ~ style(font.weight = 'bold')),
       `goals` = color_bar(color = customOrng),
       `behinds` = color_bar(color = customOrng)
       ))
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

