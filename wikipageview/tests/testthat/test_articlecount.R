library(wikipageview)
p1 <- get_article_vc("Linear_algebra", "20150803", "20201002", "monthly")
p2 <- get_article_vc("Donald_Trump", "20160803", "20201002", "daily")
p3 <- get_article_vc("Fibonacci_number", "20190803", "20190905", "daily")
test_that("test article view count", {
  expect_equal(typeof(p1), "list")
  expect_equal(nrow(p1), 61)
  expect_equal(typeof(p2), "list")
  expect_equal(nrow(p2), 1522)
  expect_equal(typeof(p3), "list")
  expect_equal(ncol(p3), 2)
})

