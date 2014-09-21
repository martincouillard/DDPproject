library(shiny)
library(ggplot2)
dsmall =diamonds[ sample (1: dim(diamonds)[1] ,5000) ,]


modelP <- function(x){
  
  #out=lm( price~0+carat+I(carat^2)+I(carat^3) , x )
# return exp()  
  out = lm(log(price)~log(carat), x)
  return(out)
  
}
shinyServer(
  function(input, output) {
    output$mpgId <- renderPrint({
      dselect <- dsmall[(dsmall$color == input$dcol),]
      M1=modelP(dselect)
      price_prediction <- predict(M1, data.frame(carat = input$carat))
      paste("The predicted value for a carat value of ", input$carat, " is $", price_prediction)
    })
    output$text1 <- renderText({paste("The Diamond Color selected for the fit is: ", input$dcol)})
    

    output$DvC <- renderPlot({
      dselect <- dsmall[(dsmall$color == input$dcol),]
      M1=modelP(dselect)
      carat.range <- seq(0,3,0.01)
      temp <- predict (M1 ,data.frame( carat = carat.range))
      price.predict <- data.frame(carat.range, exp(temp))
      colnames(price.predict) = names(dselect)[c(1,7)]
      
      p1 <- ggplot(NULL, aes(carat,price)) + coord_cartesian(xlim = c(0,3), ylim = c(0,20000)) + geom_point(data=dsmall, shape=1) 
      p1b <- geom_point(data=dselect, col="red")
      p1c <- geom_line(data=price.predict, col = "blue", size = 2)
      print(p1+p1b+p1c)
      
      
    })
    
    output$table1 <- renderTable({
      dselect <- dsmall[(dsmall$color == input$dcol),]
      M1=modelP(dselect)
      test <- data.frame(summary(M1)$coef[,1:2])
      test
      
#      str1 <- paste("model call:", M1$call)
#      str2 <- paste("coefficient (carat): ", M1$coefficients[1])
#      str3 <- paste("coefficient (carat^2): ", M1$coefficients[2])
#      print(str1)
    })
})