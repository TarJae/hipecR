#' Look up DGAV registry IDs and names
#'
#' @description
#' Translate between a person's name, the user-supplied `internalno`, and the
#' automatically assigned `uid` in a DGAV registry lookup table. The package
#' does not include such a table. Users must supply their own data frame, for
#' example by reading a CSV file and joining it to registry data. Because the
#' table contains personal data, it must not be included in a package or a
#' public repository.
#'
#' @param df A data frame or tibble containing columns named exactly `Name`,
#'   `internalno`, and `uid`. Additional columns are ignored. `Name` and
#'   `internalno` are returned as character values; `uid` is returned as
#'   numeric.
#' @param mykeyvalues An atomic numeric, character, or factor vector of lookup
#'   keys. A list is also accepted when every element is an atomic vector of
#'   length one and all elements are consistently numeric or text. Missing and
#'   empty keys are not allowed. A zero-length vector returns a zero-length
#'   result of the target type.
#' @param from Column in which to search: `"auto"`, `"Name"`, `"internalno"`,
#'   or `"uid"`. With `"auto"`, the search order depends on the key type as
#'   described in Details.
#' @param to Column to return: `"auto"`, `"Name"`, `"internalno"`, or `"uid"`.
#'   With `"auto"`, an ID lookup returns `Name`, while a name lookup returns
#'   `internalno`.
#'
#' @details
#' Automatic lookup follows this table separately for each key:
#'
#' \tabular{lll}{
#' Key type \tab Search order with `from = "auto"` \tab `to = "auto"` \cr
#' Numeric \tab `uid`, then `internalno` \tab `Name` \cr
#' Text \tab `internalno`, then `Name` \tab `Name` or `internalno` \cr
#' }
#'
#' ID matching is exact. Numeric keys used for `internalno` are converted to
#' non-scientific text. Both keys and table values are stripped of leading and
#' trailing whitespace, but leading zeroes are otherwise preserved. Read
#' `internalno` as character data (for example, with `readr` column types or
#' `colClasses = "character"`) so that leading zeroes are not lost. For `uid`,
#' digit-only text and text-valued table columns are compared numerically.
#'
#' Name matching is a case-insensitive literal substring search, not a regular
#' expression. Read files with the correct encoding, such as UTF-8 or Latin-1,
#' so that names containing umlauts are represented consistently.
#'
#' Multiple matches are all returned in table row order; results for multiple
#' keys follow key order and can therefore be longer than `mykeyvalues`. If any
#' keys have no match, the function stops and reports all of them. R coerces
#' mixed atomic vectors such as `c(123, "Name")` to character before the
#' function is called; such values consequently follow the text lookup rules.
#' A list can preserve mixed types and is rejected when its element types are
#' inconsistent.
#'
#' @return An unnamed vector containing values from the selected target column.
#'   Results follow key order and, within each key, table row order. The result
#'   is character for `Name` and `internalno`, numeric for `uid`, and can be
#'   longer than `mykeyvalues` when a key has multiple matches.
#' @export
#'
#' @examples
#' lookup <- data.frame(
#'   Name = c("Testperson Alpha", "Testperson Beta", "Example Person"),
#'   internalno = c("0012345678", "1234567890", "0099001122"),
#'   uid = c(4101, 4102, 4103)
#' )
#'
#' tar_dgav_lookup(lookup, 4101)
#' tar_dgav_lookup(lookup, "0012345678")
#' tar_dgav_lookup(lookup, "alpha")
#' tar_dgav_lookup(lookup, "Beta", to = "uid")
#' tar_dgav_lookup(lookup, c(4101, 4103))
#' tar_dgav_lookup(lookup, 1234567890, from = "internalno")
#' tryCatch(
#'   tar_dgav_lookup(lookup, "Missing Person"),
#'   error = function(error) conditionMessage(error)
#' )
tar_dgav_lookup <- function(
    df,
    mykeyvalues,
    from = c("auto", "Name", "internalno", "uid"),
    to = c("auto", "Name", "internalno", "uid")) {
  choices <- c("auto", "Name", "internalno", "uid")
  from <- tryCatch(
    match.arg(from, choices),
    error = function(error) {
      stop("`from` must be one of: auto, Name, internalno, uid.", call. = FALSE)
    }
  )
  to <- tryCatch(
    match.arg(to, choices),
    error = function(error) {
      stop("`to` must be one of: auto, Name, internalno, uid.", call. = FALSE)
    }
  )

  if (!is.data.frame(df)) {
    stop("`df` must be a data frame or tibble.", call. = FALSE)
  }

  required_columns <- c("Name", "internalno", "uid")
  missing_columns <- setdiff(required_columns, names(df))
  if (length(missing_columns) > 0L) {
    stop(
      "`df` is missing required columns: ",
      paste(missing_columns, collapse = ", "),
      ".",
      call. = FALSE
    )
  }

  if (from != "auto" && to == from) {
    stop("`to` must not be the same as `from`.", call. = FALSE)
  }

  key_type <- NULL
  if (is.list(mykeyvalues) && !is.data.frame(mykeyvalues)) {
    if (length(mykeyvalues) == 0L) {
      keys <- character()
      key_type <- "character"
    } else {
      valid_elements <- vapply(
        mykeyvalues,
        function(value) is.atomic(value) && length(value) == 1L && is.null(dim(value)),
        logical(1)
      )
      if (!all(valid_elements)) {
        stop(
          "List elements in `mykeyvalues` must be atomic vectors of length one.",
          call. = FALSE
        )
      }

      element_types <- vapply(
        mykeyvalues,
        function(value) {
          if (is.factor(value) || is.character(value)) {
            "character"
          } else if (is.numeric(value)) {
            "numeric"
          } else {
            "invalid"
          }
        },
        character(1)
      )
      if (any(element_types == "invalid")) {
        stop("`mykeyvalues` must contain only numeric or text keys.", call. = FALSE)
      }
      if (length(unique(element_types)) != 1L) {
        stop(
          "List elements in `mykeyvalues` must all have the same key type.",
          call. = FALSE
        )
      }

      key_type <- element_types[[1L]]
      if (key_type == "numeric") {
        keys <- unname(vapply(mykeyvalues, as.numeric, numeric(1)))
      } else {
        keys <- unname(vapply(mykeyvalues, as.character, character(1)))
      }
    }
  } else {
    if (!is.atomic(mykeyvalues) || !is.null(dim(mykeyvalues))) {
      stop("`mykeyvalues` must be an atomic vector or a list of scalar keys.", call. = FALSE)
    }
    if (is.factor(mykeyvalues)) {
      keys <- unname(as.character(mykeyvalues))
      key_type <- "character"
    } else if (is.character(mykeyvalues)) {
      keys <- unname(mykeyvalues)
      key_type <- "character"
    } else if (is.numeric(mykeyvalues)) {
      keys <- unname(mykeyvalues)
      key_type <- "numeric"
    } else {
      stop("`mykeyvalues` must contain only numeric or text keys.", call. = FALSE)
    }
  }

  if (key_type == "character") {
    keys <- trimws(keys)
    if (anyNA(keys)) {
      stop("`mykeyvalues` must not contain NA values.", call. = FALSE)
    }
    if (any(!nzchar(keys))) {
      stop("`mykeyvalues` must not contain empty strings.", call. = FALSE)
    }
  } else {
    if (anyNA(keys)) {
      stop("`mykeyvalues` must not contain NA values.", call. = FALSE)
    }
    if (any(!is.finite(keys))) {
      stop("Numeric `mykeyvalues` must contain only finite values.", call. = FALSE)
    }
  }

  empty_target <- if (to != "auto") {
    to
  } else if (from == "Name") {
    "internalno"
  } else {
    "Name"
  }
  if (length(keys) == 0L) {
    if (empty_target == "uid") {
      return(numeric())
    }
    return(character())
  }

  format_numeric_key <- function(value) {
    format(value, scientific = FALSE, trim = TRUE, digits = 22L)
  }

  names_in_table <- as.character(df$Name)
  internalno_in_table <- trimws(as.character(df$internalno))
  uid_in_table <- suppressWarnings(as.numeric(trimws(as.character(df$uid))))

  match_name <- function(key) {
    candidates <- tolower(names_in_table)
    which(!is.na(candidates) & grepl(tolower(key), candidates, fixed = TRUE))
  }

  match_internalno <- function(key) {
    key_text <- if (key_type == "numeric") format_numeric_key(key) else key
    which(!is.na(internalno_in_table) & internalno_in_table == key_text)
  }

  match_uid <- function(key) {
    if (key_type == "character") {
      if (!grepl("^[0-9]+$", key)) {
        return(integer())
      }
      key_numeric <- suppressWarnings(as.numeric(key))
    } else {
      key_numeric <- as.numeric(key)
    }
    which(!is.na(uid_in_table) & uid_in_table == key_numeric)
  }

  find_rows <- function(key) {
    actual_from <- from
    if (from == "auto") {
      if (key_type == "numeric") {
        rows <- match_uid(key)
        actual_from <- "uid"
        if (length(rows) == 0L) {
          rows <- match_internalno(key)
          actual_from <- "internalno"
        }
      } else {
        rows <- match_internalno(key)
        actual_from <- "internalno"
        if (length(rows) == 0L) {
          rows <- match_name(key)
          actual_from <- "Name"
        }
      }
    } else {
      rows <- switch(
        from,
        Name = match_name(key),
        internalno = match_internalno(key),
        uid = match_uid(key)
      )
    }

    target <- if (to == "auto") {
      if (actual_from == "Name") "internalno" else "Name"
    } else {
      to
    }
    list(rows = rows, target = target)
  }

  matches <- lapply(keys, find_rows)
  missing_index <- which(lengths(lapply(matches, `[[`, "rows")) == 0L)
  if (length(missing_index) > 0L) {
    missing_keys <- keys[missing_index]
    missing_labels <- if (key_type == "numeric") {
      vapply(missing_keys, format_numeric_key, character(1))
    } else {
      paste0('"', missing_keys, '"')
    }
    message_text <- paste0(
      "No matches found for keys: ",
      paste(unique(missing_labels), collapse = ", "),
      "."
    )
    if (from == "auto" && key_type == "character" &&
        any(grepl("^[0-9]+$", missing_keys))) {
      message_text <- paste0(message_text, ' Did you mean `from = "uid"`?')
    }
    if (from == "auto" && key_type == "numeric") {
      message_text <- paste0(message_text, ' Did you mean `from = "internalno"`?')
    }
    stop(message_text, call. = FALSE)
  }

  extract_values <- function(match) {
    switch(
      match$target,
      Name = as.character(df$Name[match$rows]),
      internalno = trimws(as.character(df$internalno[match$rows])),
      uid = suppressWarnings(as.numeric(trimws(as.character(df$uid[match$rows]))))
    )
  }

  result <- unlist(lapply(matches, extract_values), use.names = FALSE)
  result_target <- if (to != "auto") to else "character"
  if (identical(result_target, "uid")) {
    return(unname(as.numeric(result)))
  }
  unname(as.character(result))
}
