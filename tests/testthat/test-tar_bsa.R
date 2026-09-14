test_that("tar_bsa calculates scalar and vector BSA values", {
  expect_equal(
    tar_bsa(height = 180, weight = 80),
    0.007184 * 180^0.725 * 80^0.425
  )
  expect_equal(
    tar_bsa(height = c(180, 190), weight = 80),
    0.007184 * c(180, 190)^0.725 * 80^0.425
  )
})

test_that("tar_bsa handles unusable values element-wise", {
  expect_identical(tar_bsa(height = NA, weight = 80), NA_real_)
  expect_identical(tar_bsa(height = 180, weight = NA), NA_real_)
  expect_equal(
    tar_bsa(
      height = c(180, NA_real_, 0, Inf, 175),
      weight = c(80, 75, 70, 65, -1)
    ),
    c(0.007184 * 180^0.725 * 80^0.425, rep(NA_real_, 4))
  )
})

test_that("tar_bsa rejects non-numeric inputs", {
  expect_error(tar_bsa("180", 80), "must be numeric", fixed = TRUE)
  expect_error(tar_bsa(180, "80"), "must be numeric", fixed = TRUE)
})
