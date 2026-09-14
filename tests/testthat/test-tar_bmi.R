test_that("tar_bmi calculates scalar and vector BMI values", {
  expect_equal(tar_bmi(weight = 100, height = 200), 25)
  expect_equal(
    tar_bmi(weight = c(80, 100), height = c(180, 200)),
    c(80 / 1.8^2, 25)
  )
})

test_that("tar_bmi handles unusable values element-wise", {
  expect_identical(tar_bmi(weight = NA, height = 180), NA_real_)
  expect_identical(tar_bmi(weight = 80, height = NA), NA_real_)
  expect_equal(
    tar_bmi(
      weight = c(80, NA_real_, 100, -1, Inf, 0),
      height = c(180, 175, NA_real_, 170, 180, 180)
    ),
    c(80 / 1.8^2, NA_real_, NA_real_, NA_real_, NA_real_, 0)
  )
  expect_equal(
    tar_bmi(weight = c(80, 90), height = c(0, Inf)),
    c(NA_real_, NA_real_)
  )
})

test_that("tar_bmi rejects non-numeric inputs", {
  expect_error(tar_bmi("80", 180), "must be numeric", fixed = TRUE)
  expect_error(tar_bmi(80, "180"), "must be numeric", fixed = TRUE)
})
