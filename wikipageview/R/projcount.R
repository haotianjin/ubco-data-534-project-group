#' Return a period page view count of a specific project from wikipedia page view api.
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
#' @param method method used to view page, values in ("all-agents", "user", "spider", "automated") are allowed for method, with default "all-agents"
#' @param starting period start timestamp with format YYYYMMDDHH, for example 2020010212(12:00, Jan 2nd, 2021), with the default value the timestamp of the day before yesterday
#' @param ending period start timestamp with format YYYYMMDDHH, for example 2020010212(12:00, Jan 2nd, 2021), with the default value the timestamp of yesterday
#' @param period period type should be 'daily' or 'monthly', with the default value 'daily'
#' @return return a 2-column data frame
#' @export
#' @examples
#' get_project_vc("zh.wikipedia", method = "user", starting = "2021010112", period = "hourly")
get_project_vc <- function(project_title,
                           tool = "all-access",
                           method = "all-agents",
                           starting = paste(substr(toString(Sys.Date()-2),1,4), substr(toString(Sys.Date()-2),6,7), substr(toString(Sys.Date()-2),9,10), substr(toString(Sys.time()-2),12,13), sep = ""),
                           ending = paste(substr(toString(Sys.Date()-1),1,4), substr(toString(Sys.Date()-1),6,7), substr(toString(Sys.Date()-1),9,10), substr(toString(Sys.time()-1),12,13), sep = ""),
                           period = "daily"){
  url <- paste(
    "https://wikimedia.org/api/rest_v1/metrics/pageviews/aggregate",
    # values from ISO language code plus .wikipedia(e.g. en.wikipedia, ca.wikipedia, zh.wikipedia)
    project_title,
    #values in ["all-access", "desktop", "mobile-app", "mobile-web"] is allowed for tool
    tool,
    #values in ["all-agents", "user", "spider", "automated"] is allowed for tool
    method,
    #values in ["hourly", "daily", "monthly"] is allowed for method
    period,
    #start time not earlier than 20150701
    #with format YYYYMMDD, with format YYYYMMDDHH when period = "hourly"
    starting,
    #with format YYYYMMDD, later than starting date, with format YYYYMMDDHH when period = "hourly"
    ending,
    sep = "/")
  response <-GET(url)
  result <- fromJSON(content(response, as="text", encoding = "UTF-8"))
  #Catch bad request and send a reminder
  tryCatch({
    if(response$status_code != 200) {
      cat(result$detail)
      cat("\n")
      stop()
    }}, error = function(err) {
      stop("bad request, please see above error message")
    })
  #transform dataset to data frame
  result <- data.frame(result)
  #pick timestamp and view count
  viewcount <- result[, c(5,6)]
  #transform timestamp to date value
  viewcount$items.timestamp <- ymd(str_sub(viewcount$items.timestamp, 1, -3))
  return(viewcount)
}
