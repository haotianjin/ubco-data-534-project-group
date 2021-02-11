#' Return a plot of a count data frame.
#' This function generate a plot by data from the entered data frame.
#'
#' @import ggplot2
#' @param viewcount data frame entered for plotting
#' @export
#' @examples
#' plt1 <- get_project_top("ja.wikisource", top = "top", year = "2018", mon = "12", day = "12")
#' plt2 <- get_project_ud("zh.wikipedia", method = "desktop-site", start = "20161010", end = "20171012")
#' plotcount(plt1)
#' plotcount(plt2)
plotcount <- function(viewcount){
  if (!is.null(viewcount$article)) {
    return("This data is top popular dataset and cannot be plotted")
  }
  if (!is.null(viewcount$items.offset)) {
    p <- ggplot(viewcount) + 
      aes(x = items.timestamp, group=1) + 
      scale_x_date(date_labels = "%Y") + 
      labs(x = "Year", y = "View Statistics", title = "View Count Table") + 
      geom_line(aes(y=items.devices), color="blue", linetype="dashed") + 
      annotate("text", x=viewcount[viewcount$items.device == max(viewcount$items.devices), 1], 
               y=max(viewcount$items.devices)*1.1, label = "Count") + 
      annotate("text", x=viewcount[viewcount$items.device == min(viewcount$items.devices), 1], 
               y=min(viewcount$items.underestimate)*0.9, label = "Underestimate Count") +
      geom_line(aes(y=items.underestimate), color="red", linetype="dotted") + 
      theme_classic(base_size = 16)
  }
  else {
    p <- ggplot(viewcount) + 
      aes(x = items.timestamp, y = items.views, group=1) + 
      scale_x_date(date_labels = "%Y") + 
      labs(x = "Year", y = "View Statistics", title = "View Count Table") + 
      geom_line() + 
      theme_classic(base_size = 16)
  }
  return(p)
}