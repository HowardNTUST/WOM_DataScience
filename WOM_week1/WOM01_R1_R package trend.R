library(ggplot2)
library(grid)
library(rvest)
library(dplyr)
library(zoo)

url <- "https://cran.r-project.org/web/packages/available_packages_by_date.html"

page <- read_html(url)
page %>%
  html_node("table") %>%
  html_table() %>%
  mutate(count = rev(1:nrow(.))) %>%
  mutate(Date = as.Date(Date)) %>%
  mutate(Month = format(Date, format = "%Y-%m")) %>%
  group_by(Month) %>%
  summarise(published = min(count)) %>%
  mutate(Date = as.Date(as.yearmon(Month))) -> pkgs



gg <- ggplot(pkgs, aes(x = Date, y = published))
aa <- gg + geom_line(size = 1.5)+
  scale_y_log10( breaks = c(0, 10, 100, 1000, 10000),
                          labels = c("1", "10", "100", "1.000", "10.000"))+
 labs(x = "", y = "# Packages (log)", title = "R Packages 近10年產出量")+
  theme(panel.grid.major.x = element_blank())+
  geom_hline(yintercept = 0,
                      size = 1, colour = "#535353")+theme_bw()
aa



pkgs %>%
  filter(Date > as.Date("2014-12-31")) %>%
  mutate(publishedGrowth = c(tail(.$published,-1), NA) / published) %>%
  mutate(counter = 1:nrow(.)) -> new_pkgs


# gg2 <- ggplot(new_pkgs, aes(x = Date, y = published))
ggaa <- gg2 + geom_line(size = 1)+
 geom_line(data = new_pkgs, aes(y = (min(published) * 1.056 ^ counter)),
           color = 'red',size = .8, linetype = 1)+
 annotate("segment", x = as.Date("2015-08-01"), xend = as.Date("2015-11-01"), y = 500, yend = 500, colour = "red", size = 1)+
 annotate("text", x = as.Date("2015-04-01"), y = 500, label = "5.6% growth estimation", size = 3.5)+
 scale_y_continuous()+
 labs(y = "R Packages", x = "", title = "R Package 從 2013年開始的產量及評估")+
 theme(panel.grid.major.x = element_blank())+
 geom_hline(yintercept = 0, size = .6, colour = "blue")+
  theme_bw()

ggaa


library(caTools)
set.seed(101)

split = sample.split(df.train$Survived, SplitRatio = 0.70)

final.train = subset(df.train, split == TRUE)
final.test = subset(df.train, split == FALSE)

log.model <- glm(formula=Survived ~ . , family = binomial(link='logit'),data = df.train)

