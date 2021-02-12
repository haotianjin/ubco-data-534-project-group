#' Return a period page view count of a specific project top ranking from wikipedia.
#' This function generate a data frame contains a specific project page view count within an entered period.
#'
#' @import tidyverse
#' @import httr
#' @import jsonlite
#' @import stringr
#' @import lubridate
#' @param project_title the project name, values from ISO language code(ISO 639-1) plus project type(e.g. en.wikipedia, ca.wikinews, zh.wikisource)
#' project_title refer to https://en.wikipedia.org/wiki/Main_Page (In other projects;languages)
#' @param tool access tool,values in ("all-access", "desktop", "mobile-app", "mobile-web") are allowed for tool, with default "all-access"
#' @param top #values in ("top", "top-by-country"), with default "top"
#' @param year year time with format YYYY, for example 2020, with the default value the year of the day before yesterday
#' @param mon month time with format MM, for example 01(January), with the default value the month of the day before yesterday
#' @param day day time with format DD, for example 03(third), with the default value the day before yesterday
#' @export
#' @examples
#' get_project_top("ja.wikisource", top = "top", year = "2018", mon = "12", day = "12")
get_project_top <- function(project_title, 
                            top = "top", 
                            tool = "all-access", 
                            year = substr(toString(Sys.Date()-2),1,4), 
                            mon = substr(toString(Sys.Date()-2),6,7), 
                            day = substr(toString(Sys.Date()-2),9,10)){
  #start time not earlier than 20150701
  url <- paste(
    "https://wikimedia.org/api/rest_v1/metrics/pageviews",
    #values in ["top", "top-by-country"]
    top,
    #values from ISO language code plus .wikisource
    #(e.g. en.wikisource, ca.wikisource, zh.wikisource, ja.wikisource)
    project_title,
    #values in ["all-access", "desktop", "mobile-app", "mobile-web"] is allowed for tool
    tool,
    #with format YYYY
    #date later than 2015/07
    year,
    #with format MM
    mon,
    #with format DD, or "all-days"
    sep = "/")
  #only for top, day value is useful
  if (top == "top"){
    url <- paste(url, day, sep = "/")
  }
  response <-GET(url)
  #  return(url)
  result <- fromJSON(content(response, as="text", encoding = "UTF-8"))
  #Catch bad request and send a reminder
  tryCatch({
    if(response$status_code != 200) {
      #self-determine error message when wrong top type entered
      if (top != "top" & top != "top-by-country") {
        cat("Wrong top type, please enter 'top' or 'top-by-country'")
      }
      cat(result$detail)
      cat("\n")
      stop()
    }}, error = function(err) {
      stop("bad request, please see above error message")
    })
  #
  if (top == "top") {
    result <- result$items[1,6]
  }
  else {
    result <- result$items[1,5]
  }
  result <- data.frame(result)
  return(result)
}