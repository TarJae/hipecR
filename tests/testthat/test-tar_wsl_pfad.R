test_that("tar_wsl_pfad converts Windows paths", {
  expect_equal(
    tar_wsl_pfad("C:/Users/tarka/project", copy_to_clipboard = FALSE),
    "/mnt/c/Users/tarka/project"
  )

  expect_equal(
    tar_wsl_pfad("D:\\Data\\trial", copy_to_clipboard = FALSE),
    "/mnt/d/Data/trial"
  )
})

test_that("tar_wsl_pfad respects mount_root and validates drive letter", {
  expect_equal(
    tar_wsl_pfad("E:/folder/sub", copy_to_clipboard = FALSE, mount_root = "/wsl"),
    "/wsl/e/folder/sub"
  )

  expect_error(
    tar_wsl_pfad("/home/user/project", copy_to_clipboard = FALSE),
    "No Windows drive letter found"
  )
})

test_that("tar_wsl_pfad validates inputs", {
  expect_error(tar_wsl_pfad(1, copy_to_clipboard = FALSE), "`path`")
  expect_error(tar_wsl_pfad(NA_character_, copy_to_clipboard = FALSE), "`path`")
  expect_error(tar_wsl_pfad("C:/x", copy_to_clipboard = NA), "`copy_to_clipboard`")
  expect_error(tar_wsl_pfad("C:/x", mount_root = ""), "`mount_root`")
})

test_that("tar_wsl_pfad prefers clipr when available", {
  copied <- NULL

  local_mocked_bindings(
    .tar_has_clipr = function() TRUE,
    .tar_clipr_available = function() TRUE,
    .tar_clipr_write = function(text) {
      copied <<- text
      invisible(NULL)
    },
    .tar_is_windows = function() TRUE,
    .tar_windows_write_clipboard = function(text) {
      stop("Windows clipboard should not be used when clipr works.")
    },
    .env = asNamespace("hipecR")
  )

  out <- tar_wsl_pfad("C:/Users/tarka/project", copy_to_clipboard = TRUE)
  expect_equal(out, "/mnt/c/Users/tarka/project")
  expect_equal(copied, "/mnt/c/Users/tarka/project")
})

test_that("tar_wsl_pfad warns when clipboard is unavailable", {
  local_mocked_bindings(
    .tar_has_clipr = function() FALSE,
    .tar_is_windows = function() FALSE,
    .env = asNamespace("hipecR")
  )

  expect_warning(
    out <- tar_wsl_pfad("C:/Users/tarka/project", copy_to_clipboard = TRUE),
    "Could not copy to clipboard"
  )
  expect_equal(out, "/mnt/c/Users/tarka/project")
})
