#str函數可以查看任何函數的結構以及它的內容參數
str(str)
str(lm)
str(ls)
str(rnorm)
x <- rnorm(100,2,4)  #x為樣本數100平均數為2標準差為4的常態
summary(x) #可以看到x的min,max,Q1.2.3.
str(x)   #可以跑出前五個數字，讓你知道這個分配是長怎樣
num [1:100]
#每種分布都有以下四種函數
rnorm(n, mean=0, sd=1) #常態分配n樣本
dnorm(x ,mean=0, sd=1, log=FALSE) #(density)如果已經知道平均跟標準差的話可以知道機率密度
pnorm(q, mean=0, sd=1, lower.tail = ture) #可以看累積的機率(左尾)
qnorm(p, mean=0, sd=1, lower.tail = ture) #可以看分位數
#gamma就有(dgamma,rgamma,pgamma,qgamma)
#pois(dpois,rpois,ppois,qpois)
rnorm(10)  #樣本為10的標準常態
rnorm(20,10,2) #樣本20平均數10標準差為2
rpois(10,1)  #樣本10平均發生次數為1的普瓦松分配
rpois(10,2)
rpois(10,20)

#y=b0+b1x+e
set.seed(20)
x <-rnorm(100)
e <-rnorm(100,0,2)
y <- 0.5+2*x+e
summary(y)   #y的平均數是0.68左右，範圍在-6~6之間
plot(x,y)

#sample function 抽出不放回
set.seed(1)
sample(1:10,4)
sample(letters, 5)   #也可以抽英文字母
sample(1:10)   #隨機排列，每次都不一樣
sample(1:10,replace=TRUE)   #取出放回

