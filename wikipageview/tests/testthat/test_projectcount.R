library(wikipageview)
p1 <- get_project_vc("ca.wikipedia",  tool = "mobile-app", method = "user", 
               starting = "2019010112", period = "daily")
p2 <- get_project_vc("en.wikiquote", method = "spider", starting = "2018051408", 
                     ending = "2019122323", period = "monthly")
p3 <- get_project_vc("es.wikisource", tool = "desktop", starting = "2017112617", 
                     ending = "2020020102", period = "hourly")
test_that("test project count", {
  expect_equal(typeof(p1), "list")
  expect_equal(typeof(p2), "list")
  expect_equal(nrow(p2), 18)
  expect_equal(typeof(p3), "list")
  expect_equal(ncol(p3), 2)
})

