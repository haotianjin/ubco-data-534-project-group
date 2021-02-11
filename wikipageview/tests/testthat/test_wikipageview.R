test_that("test returned start", {
  expect_equal("123", "123")
})
p1 <- get_project_ud("ca.wikinews", method = "desktop-site", start = "20161010", end = "20171012")
head(p1)
plotcount(p1)
get_project_top("meta.wikimedia", top = "top", year = "2018", mon = "12", day = "12")
get_project_vc("ca.wikinews", method = "user", starting = "2021010112", period = "hourly")
