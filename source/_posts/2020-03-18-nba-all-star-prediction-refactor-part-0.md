---
layout: post
title: "NBA All-Star Prediction Project Refactor - Part 0"
date: 2020-03-19 20:00:00 -0400
comments: true
categories:
- NBA
- Data Science
- Analytics
---

For the project in the Data and Visual Analytics course of the MS Analytics program at Georgia Tech, our topic of choice was to experiement with data analytics techniques to predict the NBA All-Star selection of the 2020 season. Ever since the course was over, I've wanted to fully refactor and productionize the data pipeline and the machine learning models required to automate the prediction process, 

In the first part (0) of this series of posts, it serves as a summary of the project, including data sets we used to generate the model, approach we took, various model experimentations, and visualization of the results.

### Introduction
Our team's goal is to predict the 2019-2020 season’s NBA All-Star team using a player’s game performance and social presence metrics.
All-Star players are top-tier players selected by fans, a media panel, and coaches to participate in a mid-season exhibition game. As such, we hypothesized that a player's social influence would factor into his likelihood of being voted as an All-Star Starter.
Current models do not account for a player’s social influence. Marketers, NBA fans, or sports bettors may be interested in having fun with the results or using them in marketing activities.

### Data Collection

Primary data sets include:

* Player Performance Statistics
* Google Search Trend
* Wikipedia Page View Raw Count
* Twitter Followers Count and Tweet Count
* Instagram Follows Count and Posts Count

### Approach

### Model Experientation

Our experimentation included using TensorFlow to build neural network, as well as various traditional machine learning techniques like regression and decision trees using Scikit Learn.

### Results

### Presentation - Web Visualization
The web visualization layer is 

![Web UI](images/allstar-nba-img/web-ui-0.png)
