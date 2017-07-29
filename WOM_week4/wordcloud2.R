# library
library(wordcloud2) 

# have a look to the example dataset
head(demoFreq)
wordcloud2(demoFreq, size=1.6)

# Gives a proposed palette
wordcloud2(demoFreq, size=1.6, color='random-dark')

# or a vector of colors. vector must be same length than input data
wordcloud2(demoFreq, size=1.6, color=rep_len( c("green","blue"), nrow(demoFreq) ) )

# Change the background color
wordcloud2(demoFreq, size=1.6, color='random-light', backgroundColor="black")

# Change the shape:
wordcloud2(demoFreq, size = 0.7, shape = 'star')
# Change the shape using your image
wordcloud2(chinese, figPath = "/home/slave1/桌面/aaa.png", size = 1.5, color = "skyblue", backgroundColor = 'black')

#try chinese
library(magrittr)
chinese=read.csv('demoFreqC.csv') %>% .[,-1]
chinese$V1=round(log2(chinese$V1)+2)

wordcloud2(chinese, size = 1, fontFamily = "微软雅黑", color = "random-light", backgroundColor = "grey")

letterCloud( chinese, size = 0.8, word = "戴光", color='random-light' , backgroundColor="black")
letterCloud( chinese, size = 0.65, word = "吳宛玲", color="white", backgroundColor="black")
letterCloud( chinese, word = "TMR行銷資料科學", color = "random-dark", fontFamily = "微软雅黑", backgroundColor="white")
letterCloud( chinese, word = "戴光", color = "random-dark", fontFamily = "微软雅黑", backgroundColor="white")
letterCloud( chinese, word = "戴光", color = "random-light", fontFamily = "微软雅黑", backgroundColor="black")
letterCloud( chinese, word = "戴光", color="random-dark", size = 0.8)
