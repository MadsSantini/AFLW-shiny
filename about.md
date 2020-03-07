---
title: "About the AFLW App"
date: "29 February 2020"
output: html_document
---

## About
This app was built in Shiny. I'm using the fitzRoy package to retrieve data for the AFLW. Unfortunately at the moment, there aren't too many nice tables of data other than the official AFL site, and that doesn't allow you to export data in a CSV file. However, fitzRoy lets you easily scrape data from the site, and puts it into a nice dataframe for further use. For more info, see their GitHub: https://github.com/jimmyday12/fitzRoy

As of 2020, the Stats page was moved to the womens.afl website and the format was changed. As a result, the stats cannot be updated via the fitzRoy package currently and I'm manually adding scores for each game (errors may exist). I'll be trying to update these on Sundays at a minimum.

This is a project to improve my own coding and visualisation skills. The official website of the AFLW is here: https://womens.afl/

### AFLW

AFLW is the Women's Australian Football League. Aussie Rules, or footy as it's mostly known in Australia, is a game where an odd-shaped ball is kicked and handballed across the field to score points. A goal, between the two central posts, is worth 6 points, while a behind is worth 1 point.

Tha AFLW started in 2017 (for comparison, the men's national professional competition, known as AFL, has been running since 1897). In 2017 there were 8 teams, in 2019 this grew to 10 teams, and for 2020 there are 14 teams. This is why some teams will have more data available than others. Also, older teams are generally more experienced and this is shown in their stats.

### Planned Improvements
* Team Data:
    + Add ability to select a second team for comparison
* Match Data:
    + Have a fixed minimum width of the shaded portion so that text in front of the data bar is always visible
    + 'Last time they met' feature for comparison
* Season Data 
    + Stop graph titles going off-screen
