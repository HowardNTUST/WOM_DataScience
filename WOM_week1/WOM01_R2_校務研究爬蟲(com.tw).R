
suppressPackageStartupMessages({
  library(plyr)
  library(httr)
  library(rvest)
  library(XML)
  library(dplyr)
  library(stringr)
  library(httr)
  library(rvest)
  library(XML)
  library(dplyr)
  library(stringr)
  library(arules)
  library(arulesViz)
  library(RColorBrewer)
  library(reshape2)
  library(plotly)
  library(visNetwork)
  library(igraph)
  library(geosphere)
  library(ggmap)
  library(tidyverse)
})



url <- "http://www.com.tw/cross/university_list105.html"
# 校榜單 url
gg=GET(url,
       #add_headers(Referer = "http://www.family.com.tw/marketing/inquiry.aspx"), # remember to add Referer
       user_agent("Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.87 Safari/537.36"))

html_tmp <- read_html(gg)
html_list <- list()
html_list <- append( html_list, html_attr( html_nodes( html_tmp, xpath = '//div[@align="left"]/a'), "href"))
url_tmp <- paste0('http://www.com.tw/cross/', html_list, seq='')


dep_url <- list()
dep_info_url<- list()
tmp_error_url<- list()


#length(url_tmp)
for(i in 1:3){
  
  tryCatch({
    dep_url_temp <- read_html(GET(url_tmp[i],
                                  user_agent("Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.87 Safari/537.36")), encoding = "UTF-8") %>%
      html_nodes(xpath = '//div[@align="center"]//a') %>%
      html_attr("href")
    dep_url[[i]] <- paste0('http://www.com.tw/cross/', dep_url_temp[grep("^check|NO_1", dep_url_temp)], seq='')
    dep_info_url[[i]] = dep_url_temp[grep('(?=.*caac)(?=.*htm)', dep_url_temp, perl = TRUE)]
    
    print(i/3)
  }, error=function(e){
    message('error')
    tmp_error_url[i]<<-list(url_tmp[i])
  }  
  )
  
  
}
# 
# stu_no <- read_html(GET("http://www.com.tw/cross/check_001012_NO_1_105_0_3.html", 
#                     user_agent("Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.87 Safari/537.36"),
#                     encoding = "UTF-8")) %>%
#   html_nodes(xpath = '//td[(((count(preceding-sibling::*) + 1) = 3) and parent::*)]') %>%
#    html_text()


### 以下是針對取回來的 html 進行處裡

# url_list <- list.files("105_all")


unlist_dep_url=unlist(dep_url)
unlist_dep_info_url=unlist(dep_info_url)


all_all <- list()
count_school_all<- list()
error_url=list()
#personal info of school selection ----
# 1:length(unlist_dep_url)
for(i in 1:3){
  
  tryCatch({
    
    dt <-  GET(unlist_dep_url[i], 
               user_agent("Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.87 Safari/537.36")) %>% 
      read_html() %>%
      html_nodes(xpath = "//table") %>%
      as.character %>%
      XML::readHTMLTable(skip.rows = 1:2, encoding = "UTF-8") %>%
      .[[4]]
    
    dt[] <- lapply(dt, as.character) 
    
    for(x in 1:length(grep('考區',dt$V3))){
      
      if(x!=length(grep('考區',dt$V3))){
        dt$V4[grep('考區',dt$V3)[x]: (grep('考區',dt$V3)[x+1]-1) ]=dt$V3[grep('考區',dt$V3)[x]]  
      }else{
        dt$V4[grep('考區',dt$V3)[x]: length(dt$V1) ]=dt$V3[grep('考區',dt$V3)[x]]  
      }
      
    }
    
    dt=dt[dt$V2!='',] %>% .[.['V2']!='正取',] %>% .[.['V2']!='備.*',] 
    dt$V5=NULL; dt$V1=NULL
    dt=dt[-grep('^備.*|-備.*|-正取.*',dt$V2),] 
    
    # dt2 <- dplyr::filter(dt, V5 != "NA")
    # dt_all <-  dt
    # dt$id=gsub("\\D", "", dt$V3)
    
    aa= GET(unlist_dep_url[i], 
            user_agent("Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.87 Safari/537.36")) %>% 
      read_html() %>%
      html_nodes(css = "tr")%>%as.character()%>% 
      grep('分發錄取',.,value = T) %>% gsub(".*\"center\">(.*?)      \r\n.*", "\\1",.) %>% gsub(".*?html\">(.*?)</a></div>.*", "\\1",.)
    
    #name and univ selected fina
    
    jj=c()
    dd=c()
    for(r in seq(1,length(aa),2)){
      jj[r]=aa[r] 
      dd[r]=aa[r+1]
    }
    
    oo=cbind(no=jj,enroll=dd) %>% na.omit() %>% as.data.frame()
    
    # oo_all <- rbind(oo_all, dt2)
    
    dt$V4 <- gsub("\\s+", "", dt$V4)
    dt$no <- sapply(str_split(dt$V4, "考區:"), head, n=1)
    dt$area <- sapply(str_split(dt$V4, "考區:"), tail, n=1)
    # dt$school <- gsub(" {1,}", ",", gsub("\\s+", " ", dt$V5))
    
    
    
    all=merge(oo, dt, by='no', all=T)
    all=all[!is.na(all$no),] 
    all$enroll=as.character(all$enroll)
    all$enroll[is.na(all$enroll)]='No'
    
    #colplit
    all=cbind(all,
              colsplit(string = all$V2, pattern = '\r', names = c('school', 'dept')))
    
    
    all$school_gov=ifelse(grepl('國立',all$school), '國立','私立')
    
    
    
    # aa=aggregate(all$path_km, by=list(all$no, all$school_gov), FUN=mean)
    bb=ftable(all$school_gov~all$no) %>% data.frame() %>% spread(key=all.school_gov, value=Freq, data = .)
    
    #rbind
    
    all_all <- rbind(all_all, all)
    count_school_all<- rbind(count_school_all, bb)
    
    print(i/length(unlist_dep_url))
    
  }, error=function(e){
    message('error')
    error_url[i]<<-list(unlist_dep_url[i])
  }  
  )
  
  
}

