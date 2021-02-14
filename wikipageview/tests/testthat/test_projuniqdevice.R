library(wikipageview)
p1 <- get_project_ud("ca.wikipedia", start = "20161010", end = "20171012")
p2 <- get_project_ud("mediawiki", method = "desktop-site", start = "2018020510", end = "20180923")
p3 <- get_project_ud("en.wikiversity", method = "mobile-site", start = "20180101", end = "20201231", period = "monthly")
#try catch function for testing the wrapup function when confronting error
error_cap <- function(val) {
  tryCatch({
    val},
    error = function(err) {
      return("error captured")
    })
}
check <- error_cap(invisible(capture.output(get_project_ud("ca.wikipedia", start = "20161010101"))))
test_that("test project unique device", {
  expect_equal(typeof(p1), "list")
  expect_equal(nrow(p1), 368)
  expect_equal(typeof(p2), "list")
  expect_equal(nrow(p2), 231)
  expect_equal(typeof(p3), "list")
  expect_equal(ncol(p3), 4)
  expect_equal(check, "error captured")
})
