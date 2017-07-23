
####################    1. loop funtion - apply相關函數應用   ####################


######## 1.1 apply ########
#apply:一個對數組進行行或列運算的函數。
#apply(X, MARGIN, FUN, ...)
#MARGIN = 1 保留所有的列(第一個維度)，消除所有的行
#MARGIN = 2 保留所有的行(第二個維度)，消除所有的列
#EX:建立matrix，並將矩陣中行或列運算
thematrix<- matrix(1:9, nrow = 3)
#每一行的總和，兩種方法可得一樣的結果
apply(thematrix, 2, sum)
colSums(thematrix)
#每一列的總和
apply(thematrix, 1, sum)
rowSums(thematrix)
#計算每一列或行總和
rowMeans(thematrix)
colMeans(thematrix)


######## 1.2 lapply ########
#lapply:對列表中每個元素套用函數，回傳結果以list呈現。
#lapply(X, FUN, ...)
#EX:建立列表進行，並將列表中的矩陣進行加總
theList<- list(A = matrix(1:9, 3), B = 1:5, C = matrix(1:4, 2), D = 2)
lapply(theList, sum)


######## 1.3 sapply ########
#sapply:簡化了lapply()的結果，會回傳一個包含所有元素的向量。
#sapply(X, FUN, ...)
#EX:沿用上一個例子
sapply(theList, sum)


######## 1.4 mapply ########
#mapply:對好幾個list中的每個元素套用所指定的函數，是lapply()的多變量版本。
#mapply: (FUN, ..., MoreArgs = NULL, SIMPLIFY = TRUE, USE.NAMES = TRUE)
#函數的參數數量至少要等於傳遞給mapply()的列表的數量
#EX:建立兩list，元素對元素做檢測是否相同
firstList <- list(A = matrix(1:16, 4), B = matrix(1:16, 2), C = 1:5)
secondList <- list(A = matrix(1:16, 4), B = matrix(1:16, 8), C = 15:1)
mapply(identical, firstList, secondList)
#EX:建立一個簡單的函數把各元素的列的數量(長度)加起來，並應用到list
simpleFunc <- function(x, y)
{
   NROW(x) + NROW(y)
}
mapply(simpleFunc, firstList, secondList)
mapply(simpleFunc, firstList, secondList, SIMPLIFY = TRUE, USE.NAMES = TRUE)
mapply(simpleFunc, firstList, secondList, SIMPLIFY = FALSE, USE.NAMES = FALSE)


######## 1.5 tapply ########
#tapply:是table apply()的縮寫，它將向量分解後進行指定函數後，再重新組合。
#tapply(X, INDEX, FUN = NULL, ..., simplify = TRUE)
#INDEX是另一個向量，長度與第一個向量相同，用來表明第一個向量中的各元素分別屬於哪一組(例如:性別)
#EX:將向量分組做平均數(正態隨機變量、均勻隨機變量、均值為1正態隨機變量)
x <- c(rnorm(10), runif(10), rnorm(10, 1))
#用gl函數產生三個level, 每個level 重複10次
f <- gl(3, 10)
tapply(x, f, mean)
tapply(x, f, mean, simplify = FALSE)
#使用range 計算觀測值的範圍
tapply(x, f, range)


######## 1.6 split ########
#split(非循環函數):把對象x根據f進行分組，並回傳list，可以跟lapply和sapply合用。
#split (x, f, drop = FALSE, ...)
#x可以是 vector, list, data frames
#因子變量f，被用來指定分組的水平（level），把對象x根據f進行分組
#split與tapply類似，但split無法計算概括統計量
#split把對象進行分組後回傳一個列表，可對獨立的組使用lapply和sapply
#EX:將向量分組做平均數(正態隨機變量、均勻隨機變量、均值為1正態隨機變量)
x <- c(rnorm(10), runif(10), rnorm(10, 1))
f <- gl(3, 10)
split(x, f)
split(x, f, drop = FALSE)
lapply(split(x, f), mean)
#此方法與tapply的結果相同，使用tapply相對緊湊

#split好處:分解類型複雜的對象
#EX:加載數據集，觀察空質量的臭氧、溫度等在一個月內的平均值
library(datasets)
head(airquality)
#按月份分組，使用colMeans計算不同行變量的平均值
s <- split(airquality, airquality$Month)
lapply(s, function(x) colMeans(x[, c("Ozone", "Solar.R", "Wind")]))
sapply(s, function(x) colMeans(x[, c("Ozone", "Solar.R", "Wind")]))
#將列表簡化成矩陣(三個變量的平均觀察值)，並將NA拿掉
sapply(s, function(x) colMeans(x[, c("Ozone", "Solar.R", "Wind")], na.rm = TRUE))




############################    2. Debugging Tools    ############################


######## 2.1 Diagnosing the problem ########
#'#1. message: 為診斷訊息，它告知有事發生，但不會阻止函數的執行。
#'#2. warning: 是一種提示，意味著發生了某些出乎意料的事情，它不一定是個問題。
#EX:
log(-1)

#'#3. error: 錯誤會終止函數的執行，錯誤訊息是通過stop函數產生的。
#三種之中只有error會使函數停止運行。
#EX:
printmessage <- function(x) {
  if(x > 0)
    print("x is greater than zero")
  else
    print("x is less than or equal to zero")
  invisible(x)  
}
#'#4. invisible 阻止自動輸出的函數
printmessage(1)
printmessage(NA)

#'#5. condition: 上述三種提示都是條件，可自行創造另一種條件，它既不是錯誤、警告，也不是訊息。




##### 2.2 Basic Tools & Using the Tools ####
#交互工具，可以在控制台上進行一些操作。
#'#1. traceback: 它會印出function call stack，告訴你一共調用了幾個函數，以及錯誤發生在哪。
#EX:
mean(Q)
traceback()
#注意!在出現錯誤後要馬上執行traceback()，因為它只能給出上一次執行的錯誤。

#'#2. debug: 你要給它傳遞一個函數作為參考，它標記這函數，進入debug模式。
#debug()總是從函數一開始就一行行地運行
#每當執行到這函數時，都會暫停執行，停在這函數的第一行。

#'#3. browser: 你能在代碼的任何地方調用browser()。
#browser()讓你能在代碼的任何地方開始，函數會一直運行到哪個節點才會停止。
#EX:
debug(lm)
lm(y ~ x)
#重複按n，不斷調用debug直到找到錯誤，但不會自動修復錯誤

#'#4. trace: 它允許你在函數中插入調試代碼，以避免編輯函數本身，函數執行完再關掉即可。
#'#5. recover:是一個錯誤處理函數，無論函數在什麼地方發生錯誤，R會停止執行但不會直接回到控制台。
#它會停在函數出錯的地方，並輸出function call stack(菜單)讓你瀏覽函數環境。
#EX:使用options將recover設為錯誤處理器
#只要退出R，它會消失，R也不會保存。
options(error = recover)
read.csv("nosuchfile")


#'#6. 調試工具不能取代你的思考！
#應該多思考代碼寫得怎樣，而不是隨便丟給調適工具，等它幫你找出問題。