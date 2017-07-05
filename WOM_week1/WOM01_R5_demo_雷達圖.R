
#load file address: https://drive.google.com/file/d/0B1YGDF5b_RGxT3MyZ3NRQmowUU0/view?usp=sharing
library(tidyverse)
library(text2vec)
library(shiny)
library(radarchart)

# calculate the unit vector

#ptt.word.vec del terms, otherwise, this matrix can not be calculated
# ptt.word.vec=ptt.word.vec[,-101]

get_analogy_three = function(add1=king, add2= woman, deduct=man, display=150 ) {
  # establish an analogy logic, vec(queen) = vec(king) - vec(man) + vec(woman)
  # HINT: "ptt.word.vec" is the variable of word vectors from session_C_02_create_glove.R
  
  queen = ptt.word.vec[add1,, drop=F]  + ptt.word.vec[add2, , drop=F] - ptt.word.vec[deduct, ,drop=F]# please complete this!
  
  # calculte the cosine-similarity among vec(queen) and other word vectors
  # HINT: use text2vec:::cosine function to achieve
  
  cos.dist = text2vec:::sim2(x = queen, y = ptt.word.vec,
                             method = "cosine", norm = "l2")# please complete this!
  
  # Show the top-10 words for this analogy task
  head(sort(cos.dist[1,], decreasing = T), display)
}

# queen = ptt.word.vec['推薦',, drop=F]  + ptt.word.vec['補習', , drop=F] - ptt.word.vec['教材', ,drop=F]

######################## 2.get analogy two ##############################
get_analogy_two = function(add1=king,add2= woman,display=20) {
  # establish an analogy logic, vec(queen) = vec(king) - vec(man) + vec(woman)
  # HINT: "ptt.word.vec" is the variable of word vectors from session_C_02_create_glove.R
  
  queen = ptt.word.vec[add1, , drop=F]  + ptt.word.vec[add2, , drop=F] #- ptt.word.vec[deduct, ,drop=F]# please complete this!
  
  # calculte the cosine-similarity among vec(queen) and other word vectors
  # HINT: use text2vec:::cosine function to achieve
  
  cos.dist = text2vec:::sim2(x = queen, y = ptt.word.vec,
                             method = "cosine", norm = "l2")# please complete this!
  
  # Show the top-10 words for this analogy task
  head(sort(cos.dist[1,], decreasing = T), display)
}


#for internal comparison------
#name changed
brand_school=brand_label
brand_school=brand_school[,1:9]
names(brand_school)=c('keyword',"台科大","北大","清大","交大","中興",'台大',"中央","北科大")
brand_school=brand_school[1:6,]
brand_school$keyword=c('推薦','實務','正面口碑','負面口碑','里程數','新聞聲量')


#shiny


ser=shinyServer(function(input, output) {
  
  # Build the "call" statement
  # This is supposed to be the call made to chartJSRadar that would give the
  # current plot
  
  v <- reactiveValues( cmText = col2rgb(c("red", "forestgreen", "navyblue")))
  
  observeEvent(input$colButton, {
    if(!is.null(input$colMatValue)) {
      v$cmText <- eval(parse(text=input$colMatValue))
    } else {
      v$cmText <- NULL
    }
  })
  
  output$colMatText <- renderUI({
    cmValue <- reactive({
      if (input$colMat == "Named") {
        'col2rgb(c("red", "forestgreen", "navyblue"))'
      } else {
        "matrix(c(255, 0, 0, 34, 139, 34, 0, 0, 128), nrow = 3)"
      }
    })
    textInput("colMatValue", "Code: ", value=cmValue())
  })
  
  output$radarCall <- reactive({
    
    arguments <- c(
      
      # paste0("rows = ", as.character(input$selectedrows)),
      # paste0("brand_school[" ,
      #        paste0(paste0('"', input$selectedrows, '"'), collapse=", "), ",]",
      #        collapse=""),
      # 
      # paste0("brand_school[, c(\"Label\"," ,
      #        paste0(paste0('"', input$selectedPeople, '"'), collapse=", "), ")]",
      #        collapse=""),
      paste0("brand_school[brand_school[,1]%in%c(",  paste0(paste0('"', input$selectedrows, '"'), collapse=","),"), c(\"keyword\"," ,
             paste0(paste0('"', input$selectedPeople, '"'), collapse=", "), ")]",
             collapse=""),
      
      
      paste0("main = ", ifelse(input$main != "", input$main, "NULL")),
      
      paste0("maxScale = ", ifelse(input$maxScale>0, input$maxScale, "NULL")),
      
      paste0("scaleStepWidth = ", 
             ifelse(input$scaleStepWidth>0, input$scaleStepWidth, "NULL")),
      
      paste0("scaleStartValue = ", input$scaleStartValue),
      
      paste0("labelSize = ", input$labelSize),
      
      paste0("addDots = ", as.character(input$addDots)),
      
      paste0("showToolTipLabel = ", as.character(input$showToolTipLabel)),
      
      paste0("showLegend = ", as.character(input$showLegend)),
      
      paste0("lineAlpha = ", input$lineAlpha),
      
      paste0("polyAlpha = ", input$polyAlpha),
      
      paste0("responsive = ", as.character(input$responsive))
      
      # paste0("colMatrix = ", input$colMatValue)
    )
    
    arguments[1] <- paste0("chartJSRadar(", arguments[1])
    arguments[length(arguments)] <- paste0(arguments[length(arguments)], ")")
    
   # paste(arguments, sep="", collapse=", ")
    
  })
  
  
  # This is because the 0 represents NULL thing is hard to feed directly to the
  # chartJSRadar call
  output$radar <- renderChartJSRadar({
    
    
    # Convert zero to a NULL
    maxScaleR <- reactive({
      if (input$maxScale>0)
        input$maxScale
      else
        NULL
    })
    # Convert zero to a NULL
    scaleStepWidthR <- reactive({
      if (input$scaleStepWidth>0)
        input$scaleStepWidth
      else
        NULL
    })
    
    
    # The main call
    chartJSRadar(brand_school[brand_school[,1]%in%c(input$selectedrows), c("keyword", input$selectedPeople)], 
                 main = input$main,
                 maxScale = maxScaleR(),
                 scaleStepWidth = scaleStepWidthR(),
                 scaleStartValue = input$scaleStartValue,
                 responsive = input$responsive,
                 showLegend = input$showLegend,
                 labelSize = input$labelSize,
                 addDots = input$addDots,
                 lineAlpha = input$lineAlpha,
                 polyAlpha = input$polyAlpha,
                 showToolTipLabel=input$showToolTipLabel
                 # colMatrix = v$cmText
                 )
  })
  
})



ui=shinyUI(pageWithSidebar(
  headerPanel('學校-競爭雷達圖'),
  sidebarPanel(
    checkboxGroupInput('selectedPeople', '大學', 
                       names(brand_school)[-1], selected="台科大"),
    
    checkboxGroupInput('selectedrows', '變數', 
                       brand_school$keyword, selected="推薦"),
    
    textInput("main", "main (title)", value = ""),
    
    numericInput("maxScale", "maxScale - 0 for NULL (default)", value = 0.7, min = 0,
                 max = NA, step = 1),
    
    numericInput("scaleStepWidth", "scaleStepWidth - 0 for NULL (default)", 
                 value = 0, min = 0, max = NA, step = 1),
    
    numericInput("scaleStartValue", "scaleStartValue - 0 is the default", 
                 value = 0, min = NA, max = NA, step = 1),
    
    numericInput("labelSize", "labelSize", value = 18, min = 1, max = NA, step = 1),
    
    numericInput("lineAlpha", "lineAlpha", value = 0.8, min = 0, max = 1, step = 0.05),
    
    numericInput("polyAlpha", "polyAlpha", value = 0.2, min = 0, max = 1, step = 0.05),
    
    checkboxInput("addDots", "addDots", value = TRUE),
    
    checkboxInput("showLegend", "showLegend", value = TRUE),
    
    checkboxInput("showToolTipLabel", "showToolTipLabel", value = FALSE),
    
    checkboxInput("responsive", "responsive", value = TRUE),
    
    # radioButtons("colMat", "colMatrix", choices=c("Matrix", "Named"), 
    #              selected = "Named", inline = TRUE),
    
    # uiOutput("colMatText"),
    actionButton("colButton", "Update")
    
  ),
  mainPanel(
    p("以雷達圖比較學校競爭優劣"),
    chartJSRadarOutput("radar", width = "450", height = "300"), 
    code(textOutput("radarCall")), width = 7
  )
))

shinyApp(ui = ui,server = ser )


