library(wikipageview)
p1 <- get_article_vc("Donald_Trump", "20160803", "20201002", "daily")
p2 <- get_project_vc("en.wikiquote", method = "spider", starting = "2018051408",
                     ending = "2019122323", period = "monthly")
p3<- get_project_top("ca.wikibooks", top = "top", year = "2018", mon = "05", day = "03")
p4 <- get_project_top("ja.wikisource", top = "top-by-country", year = "2017", mon = "03", day = "11")
p5 <- get_project_ud("mediawiki", method = "desktop-site", start = "2018020510", end = "20180923")
test_that("test plot count", {
  expect_equal(typeof(plotcount(p1)), "list")
  expect_equal(typeof(plotcount(p2)), "list")
  expect_equal(plotcount(p3), "This data is top popular dataset and cannot be plotted")
  expect_equal(plotcount(p4), "This data is top popular dataset and cannot be plotted")
  expect_equal(typeof(plotcount(p5)), "list")
})
