library(tidyverse)

t <- read_rds("final-oer-commons-data.rds")

## stars, views, saves, comments
t %>% 
  mutate(stars = as.integer(stars)) %>% 
  select(stars:comments) %>% 
  skimr::skim()

## subjects
t %>% 
  unnest(subject) %>% 
  filter(subject != ", ") %>% 
  count(subject, sort = TRUE)

## level
t %>% 
  unnest(level) %>% 
  select(level) %>% 
  mutate(level = str_trim(level),
         level = str_split(level, ", ")) %>% 
  unnest(level) %>% 
  count(level, sort = TRUE) %>% 
  mutate(level = str_trim(level))

## grades
t %>% 
  unnest(grades) %>% 
  #unnest(grades) %>% 
  select(grades) %>% 
  mutate(grades = str_split(grades, ", ")) %>% 
  unnest(grades) %>% 
  mutate(grades = str_replace_all(grades, "\n          ", "")) %>% 
  mutate(grades = str_trim(grades)) %>% 
  count(grades, sort = TRUE)
  # filter(str_detect(grades, "Grade"))

## materials
t %>% 
  unnest(material_type) %>% 
  filter(material_type != ", ") %>% 
  count(material_type, sort = TRUE)

## date added
t %>% 
  unnest(date_added) %>% 
  select(date_added) %>% 
  mutate(date_added = lubridate::mdy(date_added)) %>% 
  mutate(year = lubridate::year(date_added)) %>% 
  count(year, sort = TRUE)

## license
t %>% 
  unnest(license) %>% 
  select(license) %>% 
  mutate(license = str_trim(license)) %>% 
  count(license, sort = TRUE)

## endorsements
t %>% 
  unnest(endorsements) %>% 
  select(endorsements) %>% 
  mutate(endorsements = str_replace_all(endorsements, "\n                    ", "")) %>% 
  mutate(endorsements = str_trim(endorsements)) %>% 
  mutate(endorsements = str_replace_all(endorsements, "   ", " ")) %>% 
  count(endorsements, sort = TRUE)

## evaluations
t %>% 
  unnest(evaluations) %>% 
  select(evaluations) %>% 
  mutate(evaluations = str_replace_all(evaluations, "\n                    ", "")) %>% 
  mutate(evaluations = str_trim(evaluations)) %>% 
  mutate(evaluations = str_replace_all(evaluations, "   ", " ")) %>% 
  separate(evaluations, into = c("rating", "n_raters"), sep = "  ") %>% 
  mutate(rating = as.integer(rating)) %>% 
  skimr::skim()

## standards
t %>% 
  unnest(standards) %>% 
  select(standards) %>% 
  unnest(standards) %>% 
  count(standards, sort = TRUE)
