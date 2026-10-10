make_dgav_lookup <- function(as_tibble = FALSE) {
  data <- data.frame(
    Name = c(
      "Testperson Alpha",
      "Testperson Beta",
      "Alpha Example",
      "Duplicate One",
      "Duplicate Two",
      NA_character_
    ),
    internalno = c(
      "0012345678",
      "1234567890",
      "0099001122",
      "7777777777",
      "7777777777",
      NA_character_
    ),
    uid = c(4101, 4102, 4103, 4200, 4200, NA_real_),
    extra = seq_len(6),
    stringsAsFactors = FALSE
  )
  if (as_tibble) tibble::as_tibble(data) else data
}

test_that("automatic lookup translates IDs and names", {
  lookup <- make_dgav_lookup()

  expect_identical(tar_dgav_lookup(lookup, 4101), "Testperson Alpha")
  expect_identical(tar_dgav_lookup(lookup, "0012345678"), "Testperson Alpha")
  expect_identical(tar_dgav_lookup(lookup, "Beta"), "1234567890")
  expect_identical(tar_dgav_lookup(lookup, "beta", to = "uid"), 4102)
})

test_that("name lookup is case-insensitive, literal, and supports substrings", {
  lookup <- make_dgav_lookup()

  expect_identical(
    tar_dgav_lookup(lookup, "TESTPERSON", from = "Name"),
    c("0012345678", "1234567890")
  )
  expect_identical(
    tar_dgav_lookup(lookup, "person A", from = "Name"),
    "0012345678"
  )
})

test_that("vector results follow key order and include every duplicate", {
  lookup <- make_dgav_lookup()

  expect_identical(
    tar_dgav_lookup(lookup, c(4103, 4101)),
    c("Alpha Example", "Testperson Alpha")
  )
  expect_identical(
    tar_dgav_lookup(lookup, "Duplicate", from = "Name", to = "uid"),
    c(4200, 4200)
  )
  expect_identical(
    tar_dgav_lookup(lookup, 4200, from = "uid", to = "Name"),
    c("Duplicate One", "Duplicate Two")
  )
})

test_that("internal numbers preserve leading zeroes and ignore outer whitespace", {
  lookup <- make_dgav_lookup()
  lookup$internalno[1] <- "  0012345678  "

  expect_identical(
    tar_dgav_lookup(lookup, " 0012345678 ", from = "internalno"),
    "Testperson Alpha"
  )
  expect_identical(
    tar_dgav_lookup(lookup, "Alpha", from = "Name"),
    c("0012345678", "0099001122")
  )
  expect_error(
    tar_dgav_lookup(lookup, 12345678, from = "internalno"),
    "12345678"
  )
})

test_that("automatic search order is applied separately to every key", {
  lookup <- make_dgav_lookup()
  lookup_with_overlap <- lookup
  lookup_with_overlap$internalno[2] <- "4101"

  expect_identical(
    tar_dgav_lookup(lookup_with_overlap, 4101),
    "Testperson Alpha"
  )
  expect_identical(tar_dgav_lookup(lookup, 1234567890), "Testperson Beta")
  expect_identical(
    tar_dgav_lookup(lookup, c("1234567890", "Alpha")),
    c("Testperson Beta", "0012345678", "0099001122")
  )
})

test_that("explicit lookup tolerates CSV-induced column types", {
  lookup <- make_dgav_lookup()
  lookup$internalno <- as.numeric(lookup$internalno)
  lookup$uid <- as.character(lookup$uid)

  expect_identical(
    tar_dgav_lookup(lookup, 1234567890, from = "internalno"),
    "Testperson Beta"
  )
  expect_identical(
    tar_dgav_lookup(lookup, "4102", from = "uid"),
    "Testperson Beta"
  )
  expect_identical(
    tar_dgav_lookup(lookup, "Beta", from = "Name", to = "uid"),
    4102
  )
})

test_that("lists and factors are normalised without guessing mixed types", {
  lookup <- make_dgav_lookup()

  expect_identical(
    tar_dgav_lookup(lookup, list(4101, 4103L)),
    c("Testperson Alpha", "Alpha Example")
  )
  expect_identical(
    tar_dgav_lookup(lookup, list(factor("Beta"), "Alpha")),
    c("1234567890", "0012345678", "0099001122")
  )
  expect_identical(
    tar_dgav_lookup(lookup, factor(c("Beta", "0012345678"))),
    c("1234567890", "Testperson Alpha")
  )
  expect_error(
    tar_dgav_lookup(lookup, list(4101, "Alpha")),
    "same key type"
  )
  expect_error(
    tar_dgav_lookup(lookup, list(4101:4102, 4103)),
    "length one"
  )
})

test_that("already coerced atomic vectors follow text auto rules", {
  lookup <- make_dgav_lookup()
  coerced <- c(4101, "Alpha")

  expect_type(coerced, "character")
  expect_error(
    tar_dgav_lookup(lookup, coerced),
    'Did you mean `from = "uid"`\\?'
  )
})

test_that("source and target cannot be identical", {
  lookup <- make_dgav_lookup()

  expect_error(
    tar_dgav_lookup(lookup, "Alpha", from = "Name", to = "Name"),
    "must not be the same"
  )
  expect_error(
    tar_dgav_lookup(lookup, 4101, from = "uid", to = "uid"),
    "must not be the same"
  )
})

test_that("all missing keys and useful automatic hints are reported", {
  lookup <- make_dgav_lookup()

  expect_error(
    tar_dgav_lookup(lookup, c("Missing Alpha", "Missing Beta")),
    "Missing Alpha.*Missing Beta"
  )
  expect_error(
    tar_dgav_lookup(lookup, "9999"),
    'Did you mean `from = "uid"`\\?'
  )
  expect_error(
    tar_dgav_lookup(lookup, 9999),
    'Did you mean `from = "internalno"`\\?'
  )
})

test_that("invalid keys fail clearly", {
  lookup <- make_dgav_lookup()

  expect_error(tar_dgav_lookup(lookup, NA_character_), "must not contain NA")
  expect_error(tar_dgav_lookup(lookup, c("Alpha", NA_character_)), "must not contain NA")
  expect_error(tar_dgav_lookup(lookup, "  "), "empty strings")
  expect_error(tar_dgav_lookup(lookup, TRUE), "numeric or text")
  expect_error(tar_dgav_lookup(lookup, Inf), "finite values")
  expect_error(tar_dgav_lookup(lookup, list(list(4101))), "atomic vectors")
})

test_that("data frame validation names every missing column", {
  lookup <- make_dgav_lookup()

  expect_error(tar_dgav_lookup("not a data frame", 4101), "data frame or tibble")
  expect_error(
    tar_dgav_lookup(lookup["Name"], "Alpha"),
    "internalno, uid"
  )
})

test_that("data frames, tibbles, extra columns, and NA rows are supported", {
  data_frame_lookup <- make_dgav_lookup()
  tibble_lookup <- make_dgav_lookup(as_tibble = TRUE)

  expect_identical(tar_dgav_lookup(data_frame_lookup, 4101), "Testperson Alpha")
  expect_identical(tar_dgav_lookup(tibble_lookup, 4101), "Testperson Alpha")
  expect_identical(tar_dgav_lookup(data_frame_lookup, "Alpha"), c("0012345678", "0099001122"))
})

test_that("empty key vectors return the target type", {
  lookup <- make_dgav_lookup()

  expect_identical(tar_dgav_lookup(lookup, numeric()), character())
  expect_identical(tar_dgav_lookup(lookup, character()), character())
  expect_identical(tar_dgav_lookup(lookup, list()), character())
  expect_identical(tar_dgav_lookup(lookup, character(), to = "uid"), numeric())
})
