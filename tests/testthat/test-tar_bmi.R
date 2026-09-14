test_that("tar_bmi calculates scalar and vector BMI values", {
  expect_equal(tar_bmi(weight = 100, height = 200), 25)
  expect_equal(
    tar_bmi(weight = c(80, 100), height = c(180, 200)),
    c(80 / 1.8^2, 25)
  )
})

test_that("tar_bmi propagates missing values element-wise", {
  expect_equal(
    tar_bmi(
      weight = c(80, NA_real_, 100),
      height = c(180, 175, NA_real_)
    ),
    c(80 / 1.8^2, NA_real_, NA_real_)
  )
})

test_that("tar_bmi validates non-missing input values", {
  expect_error(tar_bmi("80", 180), "must be numeric", fixed = TRUE)
  expect_error(
    tar_bmi(c(80, -1, NA_real_), c(180, 175, 170)),
    "weight must be non-negative",
    fixed = TRUE
  )
  expect_error(
    tar_bmi(c(80, NA_real_), c(180, 0)),
    "height must be positive",
    fixed = TRUE
  )
})
