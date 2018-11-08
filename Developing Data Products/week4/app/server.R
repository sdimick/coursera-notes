library(shiny)
library(ggplot2)
library(dplyr)

data <- readRDS("data.rds")
probRain <- readRDS("probRain.rds")
isRain <- readRDS("isRain.rds")
data$Day <- as.numeric(format(data$DATE, '%d'))
data$Year <- as.numeric(format(data$DATE, '%Y'))

shinyServer(
    
    function (input, output) {
        
        output$rain <- renderText({
            userDF <- data.frame(
                MONTH_CHAR = input$month,
                PREV_RAIN = as.numeric(input$prevRain)
            )
            r <- predict(isRain, newdata = userDF)
            r <- ifelse(r=="No", "will NOT", "WILL")
            paste0(
                "It ", r, " rain tomorrow."
            )
        })
        
        output$probPlot <- renderPlot({
            userDF <- data.frame(
                MONTH_CHAR = input$month,
                PREV_RAIN = as.numeric(input$prevRain)
            )
            p <- predict(probRain, newdata = userDF, type = "response")
            barDF <- data.frame(
                prob = p,
                col = 1
            )
            barDF %>% ggplot(aes(x = col, y = prob)) +
                geom_col(fill = 'blue') +
                scale_y_continuous(limits = c(0, 1)) +
                theme(
                    panel.background = element_rect(fill = 'white'),
                    panel.grid.major.x = element_line(colour = 'black'),
                    panel.grid.minor.x = element_line(colour = 'grey25', linetype = 1),
                    axis.text = element_blank(),
                    axis.ticks = element_blank(),
                    axis.title = element_blank(),
                    plot.margin = margin(0, 0, 0, 0)
                ) +
                annotate(
                    "text", x = 1, y = p - 0.05, colour = 'white', size = 10,
                    label = paste0(round(p*100), "%")
                ) +
                coord_flip()},
            width = "auto",
            height = 75
        )
        
        output$histTitle <- renderText({
            m <- input$month
            y <- as.numeric(input$prevRain)
            paste0(
                m, ": History of Rain Tomorrow Given ",
                ifelse(y==0, "No", ""),
                " Rain Today"
            )
        })
        
        output$histPlot <- renderPlot({
            data %>% 
                filter(MONTH_CHAR == input$month) %>% 
                mutate(Key = factor(ifelse(PREV_RAIN==as.numeric(input$prevRain),
                                           ifelse(RAIN==1, "Rain", "No Rain"),
                                           "NA"),
                                    levels = c("Rain", "No Rain", "NA"))) %>% 
                ggplot(aes(x = Year, y = Day, fill = Key)) +
                geom_tile() +
                scale_fill_manual(values = c("blue", "khaki1", "grey90")) +
                theme(
                    panel.background = element_rect(fill = 'white'),
                    axis.ticks = element_blank(),
                    plot.margin = margin(0, 0, 0, 0)
                )
        })
    }
    
)