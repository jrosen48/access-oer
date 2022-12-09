library(tidyverse)
library(rvest)
library(xml2)

# access_links <- function(start_page, subject_index) {
#   
#   h0 <- 'https://www.oercommons.org/browse?batch_size=100&batch_start='
#   h1 <- '&f.general_subject='
#   subject <- c('applied-science', 'arts-and-humanities', 'business-and-communication', 'career-and-technical-education', 
#                'education', 'english-language-arts', 'history', 'law', 'life-science', 
#                'mathematics', 'physical-science', 'social-science')
#   
#   print(str_c("accessing ", start_page, " for ", subject[subject_index]))
#   
#   h <- str_c(h0, start_page, h1, subject[subject_index])
#   
#   out <- h %>% 
#     read_html() %>% 
#     html_nodes(".js-item-link") %>% 
#     html_attr('href')
#   
#   print(str_c("accessed ", start_page, " for ", subject[subject_index]))
#   
#   print("sleeping")
#   
#   Sys.sleep(2.5)
#   
#   tibble(links = out,
#          subject = subject[subject_index])
#   
# }
# 
# n_links <- c(9492, 6947, 2009, 2162, 6326, 4044, 3079, 336, 10980, 7036, 8074, 5568)
# 
# access_subject <- function(index) {
#   seq(1, n_links[index], by = 100) %>% 
#     map_df(access_links, subject_index = index)
# }
# 
# # accessing
# 
# s1 <- access_subject(1)
# s2 <- access_subject(2)
# s3 <- access_subject(3)
# s4 <- access_subject(4)
# s5 <- access_subject(5)
# s6 <- access_subject(6)
# s7 <- access_subject(7)
# s8 <- access_subject(8)
# s9 <- access_subject(9)
# s10 <- access_subject(10)
# s11 <- access_subject(11)
# s12 <- access_subject(12)
# 
# source("access-page.R")
# 
# all_subjects <- bind_rows(s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12)
# 
# all_subjects %>% write_csv("all-subjects-oer.csv")
#
# all_subjects <- all_subjects %>% mutate(id = row_number())
# write_csv(all_subjects, "all-subjects-oer.csv")

d <- read_csv("all-subjects-oer.csv")

d <- d[6200:nrow(d), ]

read_and_write_html <- function(d, id) {
  print(str_c("accessing: ", id))
  h <- read_html(d$links[d$id == id])
  write_xml(h, file = str_c("html/file-", id, ".html"))
  Sys.sleep(1)
}

d$id %>% 
  map(possibly(read_and_write_html, otherwise = NULL), d = d)
