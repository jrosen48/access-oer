library(tidyverse)

t <- read_rds("final-oer-commons-data.rds")

# library(rvest)
# standards <- "https://www.nextgenscience.org/overview-dci" %>% 
#   read_html() %>% 
#   html_nodes("#bootstrap-fieldgroup-accordion--accordion .even a") %>% 
#   html_text()
# 
# standards_1 <- standards %>% 
#   str_split("  ") %>% 
#   map_chr(~.[[1]])
# 
# standards_2 <- standards %>% 
#   str_split("  ") %>% 
#   map_chr(possibly(~.[[2]], NA))
# 
# tibble(standards_1, standards_2) %>% 
#   write_csv("standards.csv")

standards <- read_csv("standards.csv") %>% 
  mutate(code = tolower(code)) %>% 
  rename(standards = code)

t <- t %>% 
  distinct(unique_links, .keep_all = TRUE)

nrow(t) # 48496

## prop science

t %>% 
  unnest(subject) %>% 
  filter(subject %in% c("Applied Science", "Life Science", "Physical Science")) %>% 
  distinct(unique_links) # 8937

8937/48496 # .184

### good representation of science

## prop subject

t %>% 
  unnest(subject) %>% 
  filter(subject %in% c("Applied Science", "Life Science", "Physical Science")) %>% 
  group_by(subject) %>% 
  summarize(n = n(),
            mean_views = mean(views)) %>% 
  mutate(prop = n / 8937) %>% 
  arrange(desc(prop))

### lots of life science

## prop level

t %>% 
  unnest(subject) %>% 
  filter(subject %in% c("Applied Science", "Life Science", "Physical Science")) %>% 
  unnest(level) %>% 
  mutate(level = str_trim(level),
         level = str_split(level, ", ")) %>% 
  unnest(level) %>% 
  group_by(level) %>% 
  summarize(n = n(),
            mean_views = mean(views)) %>% 
  mutate(level = str_trim(level)) %>% 
  filter(level %in% c("Preschool", "Lower Primary",
                      "Upper Primary", "Middle School",
                      "High School", "Community College / Lower Division",
                      "College / Upper Division", 
                      "Graduate / Professional",
                      "Career / Technical", 
                      "Adult Education")) %>% 
  mutate(prop = n / 8937)

### different from TPT - more upper-level

## interactions

t %>% 
  unnest(subject) %>% 
  filter(subject %in% c("Applied Science", "Life Science", "Physical Science")) %>%
  mutate(stars = as.integer(stars)) %>% 
  select(stars:comments) %>% 
  skimr::skim()

# ## grades
# t %>% 
#   unnest(subject) %>% 
#   filter(subject %in% c("Applied Science", "Life Science", "Physical Science")) %>% 
#   unnest(grades) %>% 
#   #unnest(grades) %>% 
#   select(grades) %>% 
#   mutate(grades = str_split(grades, ", ")) %>% 
#   unnest(grades) %>% 
#   mutate(grades = str_replace_all(grades, "\n          ", "")) %>% 
#   mutate(grades = str_trim(grades)) %>% 
#   count(grades, sort = TRUE)
#   # filter(str_detect(grades, "Grade"))

## materials
t %>%
  unnest(subject) %>% 
  filter(subject %in% c("Applied Science", "Life Science", "Physical Science")) %>% 
  unnest(material_type) %>% 
  filter(material_type %in% c(
    "Activity/Lab",
    "Assessment",
    "Case Study",
    "Data Set",
    "Diagram/Illustration",
    "Full Course",
    "Game",
    "Homework/Assignment",
    "Interactive",
    "Lecture",
    "Lecture Notes",
    "Lesson", 
    "Lesson Plan",
    "Module",
    "Primary Source",
    "Reading", 
    "Simulation",
    "Student Guide",
    "Syllabus",
    "Teaching/Learning Strategy",
    "Textbook",
    "Unit of Study"
  )) %>% 
  unnest(material_type) %>% 
  filter(material_type != ", ") %>% 
  group_by(material_type) %>% 
  summarize(n = n(),
            mean_views = mean(views)) %>% 
  mutate(prop = n / 8937) %>% 
  arrange(desc(n))

## date added
t %>% 
  unnest(subject) %>% 
  filter(subject %in% c("Applied Science", "Life Science", "Physical Science")) %>% 
  unnest(date_added) %>% 
  mutate(date_added = lubridate::mdy(date_added)) %>% 
  mutate(year = lubridate::year(date_added)) %>% 
  group_by(year) %>% 
  summarize(n = n(),
            mean_views = mean(views)) %>%  
  mutate(prop = n / 8937) %>% 
  arrange(desc(n))

## license
t %>% 
  unnest(subject) %>% 
  filter(subject %in% c("Applied Science", "Life Science", "Physical Science")) %>% 
  unnest(license) %>% 
  mutate(license = str_trim(license)) %>% 
  group_by(license) %>% 
  summarize(n = n(),
            mean_views = mean(views)) %>% 
  arrange(desc(n)) %>% 
  mutate(prop = n / 8937)

## endorsements
t %>% 
  unnest(subject) %>% 
  filter(subject %in% c("Applied Science", "Life Science", "Physical Science")) %>% 
  unnest(endorsements) %>% 
  mutate(endorsements = str_replace_all(endorsements, "\n                    ", "")) %>% 
  mutate(endorsements = str_trim(endorsements)) %>% 
  mutate(endorsements = str_replace_all(endorsements, "   ", " ")) %>% 
  group_by(endorsements) %>% 
  summarize(n = n(),
            mean_views = mean(views)) %>%  
  mutate(prop = n / 8937) %>% 
  arrange(desc(n))

## standards
t %>% 
  unnest(subject) %>% 
  filter(subject %in% c("Applied Science", "Life Science", "Physical Science")) %>% 
  unnest(standards) %>% 
  unnest(standards) %>%
  mutate(standards = tolower(standards)) %>% 
  filter(str_detect(standards, "ngss")) %>% 
  mutate(standards = str_sub(standards, start = 6)) %>% 
  mutate(standards = str_replace_all(standards, "\\.", "-")) %>% 
  mutate(standards = str_sub(standards, end = -3)) %>% 
  group_by(standards) %>% 
  summarize(n = n(),
            mean_views = mean(views)) %>%  
  left_join(standards) %>% 
  mutate(prop = n / 8937) %>% 
  arrange(desc(n))

# ## evaluations
# t %>% 
#   unnest(subject) %>% 
#   filter(subject %in% c("Applied Science", "Life Science", "Physical Science")) %>% 
#   unnest(evaluations) %>% 
#   select(evaluations) %>% 
#   mutate(evaluations = str_replace_all(evaluations, "\n                    ", "")) %>% 
#   mutate(evaluations = str_trim(evaluations)) %>% 
#   mutate(evaluations = str_replace_all(evaluations, "   ", " ")) %>% 
#   separate(evaluations, into = c("rating", "n_raters"), sep = "  ") %>% 
#   mutate(rating = as.integer(rating))
