library(tidyverse)
library(rvest)

l <- list.files("html", full.names = TRUE)

# titles <- l %>% 
#   map(access_title)
# 
# # titles <- unlist(titles)
# 
# stats <- l %>% 
#   map(possibly(access_stats, NA))
# 
# # return(list(stars, views, saves, comments))
# stars <- stats %>% map_chr(possibly(~.[[1]], NA))
# stars <- stars %>% map(str_sub, start = 1, end = 3)
# views <- stats %>% map_chr(possibly(~.[[2]], NA)) %>% as.integer()
# saves <- stats %>% map_chr(possibly(~.[[3]], NA)) %>% as.integer()
# comments <- stats %>% map_chr(possibly(~.[[4]], NA)) %>% as.integer()
# 
# t <- tibble(title = titles,
#        stars = stars,
#        views = views,
#        saves = saves,
#        comments = comments)
# 
# write_rds(t, "tibble-1.rds")

t <- read_rds("tibble-1.rds")

access_other_main_stuff(l[1])

other <- l %>% 
  map(possibly(access_other_main_stuff, NA))

# return(list(overview, subject, level, grades, material_type, date_added, license))

t$overview <- other %>% 
  map(~.[[1]])

t$subject <- other %>% 
  map(~.[[2]])

t$level <- other %>% 
  map(~.[[3]])

t$grades <- other %>% 
  map(~.[[4]])

t$material_type <- other %>% 
  map(~.[[5]])

t$date_added <- other %>% 
  map(~.[[6]])

t$license <- other %>% 
  map(~.[[7]])

t$evaluations <- l %>% map(possibly(access_evaluations, NA))

t$standards <- l %>% 
  map(possibly(access_standards, NA))

t$endorsements <- l %>% 
  map(possibly(access_endorsement, NA))

write_rds(t, "final-oer-commons-data.rds")



