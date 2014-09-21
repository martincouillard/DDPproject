---
title       : Course Project - Developping Data Products  
subtitle    : Analysis of Diamonds dataset
author      : MC (21 September 2014)
job         : 
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
---

## Introduction

This shiny app predicts the relationship between the price and the carat for diamonds of different colors.

The data consists of a random subset of the "diamonds" dataset in the ggplot2 library. 5000 entries were taken out of 53940 entries in the diamonds dataset simply to speed up the app.

The app consists of two files:
* ui.R
* server.R


---

## ui.R

This file produces the user interface.  It displays a side panel on the left, which includes the two inputs:  

1. diamond color (D, E, F, G, H, I, or J)
2. carat value

the side panel includes the documentation for the app.

The user interface also includes a main panel, which displays the outputs (from top to bottom):

1. The prediction for the diamond price based on the two inputs.
2. A plot of the price vs carat, displaying the diamonds with the selected color (red points), the other diamonds (black circles), and the result of the linear regression fit (blue line).
3. A table displaying the coefficients of the fit.

---

## Computation

We first select the diamonds with the color specified as an input.  As an examples (for a diamond color: D)


```r
  library(ggplot2)
  dsmall =diamonds[ sample (1: dim(diamonds)[1] ,5000) ,]
  dselect <- dsmall[(dsmall$color == "D"),]
```

We then perform a linear regression fit (log(price)~log(carat)) on the subset with the selected color, and we return the coefficients as follow:


```r
  modelP <- lm(log(price)~log(carat), dselect)
  summary(modelP)$coef[,1:2]
```

```
##             Estimate Std. Error
## (Intercept)    8.557    0.01441
## log(carat)     1.712    0.01876
```

---

## server.R

This file has two main components.  The first is the function for the linear regression model:


```r
  modelP <- function(x){
    out = lm(log(price)~log(carat), x)
    return(out)
  }
```

The second component is shinyServer(), which takes in the two inputs (input$carat and input$dcol), and computes the outputs.  For instance, the price prediction is performed as follow:


```r
    output$mpgId <- renderPrint({
      dselect <- dsmall[(dsmall$color == input$dcol),]
      M1=modelP(dselect)
      price_prediction <- predict(M1, data.frame(carat = input$carat))
      paste("The predicted value for a carat value of ", input$carat, " is $", price_prediction)
    })
```
