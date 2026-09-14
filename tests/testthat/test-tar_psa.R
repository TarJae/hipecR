test_that("tar_psa calculates scalar and vector PSA values", {
  expect_equal(
    tar_psa(height = 180, weight = 80),
    (0.007184 * 180^0.725 * 80^0.425) * 100
  )
  expect_equal(
    tar_psa(height = c(180, 190), weight = 80),
    (0.007184 * c(180, 190)^0.725 * 80^0.425) * 100
  )
})

test_that("tar_psa handles unusable values element-wise", {
  expect_identical(tar_psa(height = NA, weight = 80), NA_real_)
  expect_identical(tar_psa(height = 180, weight = NA), NA_real_)
  expect_equal(
    tar_psa(
      height = c(180, NA_real_, 0, Inf, 175),
      weight = c(80, 75, 70, 65, -1)
    ),
    c((0.007184 * 180^0.725 * 80^0.425) * 100, rep(NA_real_, 4))
  )
})

test_that("tar_psa is consistent with tar_bsa", {
  height <- c(180, NA_real_, 0, 190)
  weight <- c(80, 75, 70, 90)
  expect_equal(
    tar_psa(height = height, weight = weight),
    tar_bsa(height = height, weight = weight) * 100
  )
})

test_that("tar_psa rejects non-numeric inputs", {
  expect_error(tar_psa("180", 80), "must be numeric", fixed = TRUE)
  expect_error(tar_psa(180, "80"), "must be numeric", fixed = TRUE)
})
