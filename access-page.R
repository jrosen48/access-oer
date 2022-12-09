access_title <- function(h) {
  
  print(str_c("Accessing: ", h))
  my_html <- h %>% 
    read_html()
  
  title <- my_html %>% 
    html_nodes(".material-title a") %>% 
    html_text()
  
  title
}

access_stats <- function(h) {
  
  print(str_c("Accessing: ", h))
  
  my_html <- h %>% 
    read_html()
  
  stars <- my_html %>% 
    html_nodes(".stars") %>% 
    html_text()
  
  stars <- str_extract_all(stars, ".*?([0-9]+).*")[[1]] %>% 
    str_trim()
  
  views <- my_html %>% 
    html_nodes(".fa-eye~ span") %>% 
    html_text()
  
  views <- views[2]
  
  saves <- my_html %>% 
    html_nodes(".fa-save~ span") %>% 
    html_text()
  
  saves <- saves[2]
  
  comments <- my_html %>% 
    html_nodes(".js-comments-count") %>% 
    html_text()
  
  return(list(stars, views, saves, comments))
  
}

access_other_main_stuff <- function(h) {
  
  print(str_c("Accessing: ", h))
  
  my_html <- h %>% 
    read_html()
  
  # DESCRIPTION
  
  overview <- my_html %>% 
    html_nodes(".materials-details-abstract .text") %>% 
    html_text()
  
  subject <- my_html %>% 
    html_nodes("dd:nth-child(2) span") %>% 
    html_text()
  
  level <- my_html %>% 
    html_nodes("dd:nth-child(4)") %>% 
    html_text()
  
  grades <- my_html %>% 
    html_nodes("dd:nth-child(6)") %>% 
    html_text()
  
  material_type <- my_html %>% 
    html_nodes("dd:nth-child(8) span") %>% 
    html_text()
  
  date_added <- my_html %>% 
    html_nodes(".materials-details-first-part .text") %>% 
    html_text()
  
  license <- my_html %>% 
    html_nodes(".text a") %>% 
    html_text()
  
  return(list(overview, subject, level, grades, material_type, date_added, license))
  
}


# EVALUATIONS

access_evaluations <- function(h) {
  
  my_html <- h %>% 
    read_html()
  
  es1 <- my_html %>% 
    html_nodes(".score-value") %>% 
    html_text()
  
  es1[1:7] %>% 
    as.list()

  # es2 <- my_html %>% 
  #   html_nodes("tr:nth-child(2) .score-value") %>% 
  #   html_text()
  # 
  # es3 <- my_html %>% 
  #   html_nodes("tr:nth-child(3) .score-value") %>% 
  #   html_text()
  # 
  # es4 <- my_html %>% 
  #   html_nodes("tr:nth-child(4) .score-value") %>% 
  #   html_text()
  # 
  # es5 <- my_html %>% 
  #   html_nodes("tr:nth-child(5) .score-value") %>% 
  #   html_text()
  # 
  # es6 <- my_html %>% 
  #   html_nodes("tr:nth-child(6) .score-value") %>% 
  #   html_text()
  # 
  # es7 <- my_html %>% 
  #   html_nodes("tr:nth-child(7) .score-value") %>% 
  #   html_text()
  
  es1
}


# ENDORSEMENT

access_endorsement <- function(h) {
  
  my_html <- h %>% 
    read_html()
  
  endorsement <- my_html %>% 
    html_nodes(".endorsement-name") %>% 
    html_text()
  
  endorsement
  
}

access_standards <- function(h) {
  
  my_html <- h %>% 
    read_html()
  
  standards <- my_html %>% 
    html_nodes(".alignment-tag-link") %>% 
    html_text()
  
  standards_alignment <- my_html %>% 
    html_nodes(".alignment-tag-info-score") %>% 
    html_text()
  
  return(list(standards, standards_alignment))
}

