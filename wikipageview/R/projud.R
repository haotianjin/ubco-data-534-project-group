#' Return a project unique device count of a specific period for all sites.
#' This function generate a data frame contains a projet unique device count within an entered period.
#'
#' @import tidyverse
#' @import httr
#' @import jsonlite
#' @import stringr
#' @import lubridate
#' @param project_title the project name, values from ISO language code(ISO 639-1) plus project type(e.g. en.wikipedia, ca.wikinews, zh.wikisource)
#' project_title refer to https://en.wikipedia.org/wiki/Main_Page (In other projects;languages)
#' @param method method used to view page, values in ("all-sites", "desktop-site", "mobile-site") are allowed for method, with default "all-sites"
#' @param starting period start timestamp with format YYYYMMDD, for example 20200102(Jan 2nd, 2021), with the default value the timestamp of the day before yesterday
#' @param ending period start timestamp with format YYYYMMDD, for example 20200102(Jan 2nd, 2021), with the default value the timestamp of yesterday
#' @param period period type should be 'daily' or 'monthly', with the default value 'daily'
#' @return return a 4-column data frame
#' @export
#' @examples
#' get_project_ud("zh.wikipedia", method = "desktop-site", start = "20161010", end = "20171012")
get_project_ud <- function(project_title,
                           method = "all-sites",
                           starting = paste(substr(toString(Sys.Date()-2),1,4), substr(toString(Sys.Date()-2),6,7), substr(toString(Sys.Date()-2),9,10), sep = ""),
                           ending = paste(substr(toString(Sys.Date()-1),1,4), substr(toString(Sys.Date()-1),6,7), substr(toString(Sys.Date()-1),9,10), sep = ""),
                           period = "daily"){
  url <- paste(
    "http://wikimedia.org/api/rest_v1/metrics/unique-devices",
    #values in Wikipedia URL represents the article title
    #values from ISO language code plus .wikipedia(e.g. en.wikipedia, ca.wikipedia, zh.wikipedia)
    project_title,
    #values in ["all-sites", "desktop-site", "mobile-site"]
    method,
    #values in ["daily", "monthly"] is allowed for period
    period,
    #start time not earlier than 20150701
    #with format YYYYMMDD
    starting,
    #with format YYYYMMDD
    ending,
    sep = "/")
  #get response from url
  response <-GET(url)
  #read respond JSON file
  result <- fromJSON(content(response, as="text", encoding = "UTF-8"))
  #Catch bad request from URL if request fail and capture the fail message received
  tryCatch({
    if(response$status_code != 200) {
      cat(result$detail)
      cat("\n")
      stop()
      #    return()
    }}, error = function(err) {
      stop("bad request, please see above error message")
    })
  #transform dataset to data frame
  result <- data.frame(result)
  #pick timestamp and view count
  viewcount <- result[, 4:7]
  #transform timestamp to date value
  viewcount$items.timestamp <- ymd(viewcount$items.timestamp)
  return(viewcount)
}
