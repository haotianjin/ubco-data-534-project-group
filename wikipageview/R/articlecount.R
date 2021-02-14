#' Return a period page view count of a specific article from wikipedia page view api.
#' This function generate a data frame contains a specific article page view count within an entered period.
#'
#' @import tidyverse
#' @import httr
#' @import jsonlite
#' @import stringr
#' @import lubridate
#' @param article_title the article name, selected from wikipedia For example: "https://en.wikipedia.org/wiki/Linear_algebra" article_title is "Linear_algebra"
#' @param starting period start timestamp with format YYYYMMDD, for example 20200102(Jan 2nd, 2021), with the default value the timestamp of the day before yesterday
#' @param ending period start timestamp with format YYYYMMDD, for example 20200102(Jan 2nd, 2021), with the default value the timestamp of yesterday
#' @param period period type should be 'daily' or 'monthly', with the default value 'daily'
#' @return return a 2-column data frame
#' @export
#' @examples
#' get_article_vc("Linear_algebra", "20150803", "20201002", "monthly")
get_article_vc <- function(article_title,
                           starting = paste(substr(toString(Sys.Date()-2),1,4), substr(toString(Sys.Date()-2),6,7), substr(toString(Sys.Date()-2),9,10), sep = ""),
                           ending = paste(substr(toString(Sys.Date()-1),1,4), substr(toString(Sys.Date()-1),6,7), substr(toString(Sys.Date()-1),9,10), sep = ""),
                           period = "daily"){
  url <- paste(
    "https://wikimedia.org/api/rest_v1/metrics/pageviews/per-article/en.wikipedia/all-access/all-agents",
    #values in Wikipedia URL represents the article title
    #For example: "https://en.wikipedia.org/wiki/Linear_algebra" article_title is "Linear_algebra"
    article_title,
    #values in ["daily", "monthly"] is allowed for tool
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
  viewcount <- result[, c(4,7)]
  #transform timestamp to date value
  viewcount$items.timestamp <- ymd(str_sub(viewcount$items.timestamp, 1, -3))
  return(viewcount)
}

