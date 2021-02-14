library(wikipageview)
p1 <- get_project_top("ca.wikibooks", top = "top", year = "2018", mon = "05", day = "03")
p2 <- get_project_top("wikidata", top = "top", year = "2019", mon = "12", day = "07")
p3 <- get_project_top("ja.wikisource", top = "top-by-country", year = "2017", mon = "03", day = "11")
p4 <- get_project_top("species.wikimedia", top = "top-by-country", year = "2020", mon = "09", day = "24")
#try catch function for testing the wrapup function when confronting error
error_cap <- function(val) {
  tryCatch({
    val},
    error = function(err) {
      return("error captured")
    })
}
check <- error_cap(invisible(capture.output(get_project_top("en.wikipedia", top = "top-by", year = "2020"))))
test_that("test project top ranking", {
  expect_equal(typeof(p1), "list")
  expect_equal(nrow(p1), 456)
  expect_equal(typeof(p2), "list")
  expect_equal(nrow(p2), 991)
  expect_equal(typeof(p3), "list")
  expect_equal(ncol(p3), 4)
  expect_equal(typeof(p4), "list")
  expect_equal(p4[1,4], 229000)
  expect_equal(check, "error captured")
})
