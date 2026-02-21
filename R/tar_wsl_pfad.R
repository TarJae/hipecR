#' Convert a Windows Path to a WSL Path
#'
#' Converts a Windows path (for example, \code{C:/Users/...} or
#' \code{C:\\Users\\...}) into a WSL path (\code{/mnt/c/Users/...} by default).
#' Optionally copies the converted path to the clipboard.
#'
#' @param path A single Windows path string. Defaults to \code{getwd()}.
#' @param copy_to_clipboard Logical. If \code{TRUE}, try to copy the resulting
#'   WSL path to the clipboard.
#' @param mount_root Mount root used by WSL. Defaults to \code{"/mnt"}.
#'
#' @return A single character string with the converted WSL path.
#' @examples
#' tar_wsl_pfad("C:/Users/tarka/project", copy_to_clipboard = FALSE)
#' tar_wsl_pfad("C:\\Users\\tarka\\project", copy_to_clipboard = FALSE)
#'
#' @export
tar_wsl_pfad <- function(path = getwd(),
                         copy_to_clipboard = TRUE,
                         mount_root = "/mnt") {
  if (!is.character(path) || length(path) != 1 || is.na(path) || !nzchar(path)) {
    stop("`path` must be a single non-empty character string.", call. = FALSE)
  }
  if (!is.logical(copy_to_clipboard) || length(copy_to_clipboard) != 1 || is.na(copy_to_clipboard)) {
    stop("`copy_to_clipboard` must be TRUE or FALSE.", call. = FALSE)
  }
  if (!is.character(mount_root) || length(mount_root) != 1 || is.na(mount_root) || !nzchar(mount_root)) {
    stop("`mount_root` must be a single non-empty character string.", call. = FALSE)
  }

  p_in <- gsub("\\\\", "/", path)
  if (!grepl("^[A-Za-z]:/", p_in)) {
    stop("No Windows drive letter found (expected e.g. 'C:/...').", call. = FALSE)
  }
  p <- normalizePath(p_in, winslash = "/", mustWork = FALSE)

  drive <- sub("^([A-Za-z]):/.*$", "\\1", p)

  rest <- sub("^[A-Za-z]:", "", p)
  wsl_path <- paste0(sub("/+$", "", mount_root), "/", tolower(drive), rest)

  if (isTRUE(copy_to_clipboard)) {
    .tar_copy_to_clipboard(wsl_path)
  }

  wsl_path
}

.tar_copy_to_clipboard <- function(text) {
  copied <- FALSE

  if (.tar_has_clipr()) {
    copied <- tryCatch({
      if (isTRUE(.tar_clipr_available())) {
        .tar_clipr_write(text)
        TRUE
      } else {
        FALSE
      }
    }, error = function(e) {
      FALSE
    })
  }

  if (!copied && .tar_is_windows()) {
    copied <- tryCatch({
      .tar_windows_write_clipboard(text)
      TRUE
    }, error = function(e) {
      FALSE
    })
  }

  if (!copied) {
    warning("Could not copy to clipboard; returning path only.", call. = FALSE)
  }

  invisible(copied)
}

.tar_has_clipr <- function() {
  requireNamespace("clipr", quietly = TRUE)
}

.tar_clipr_available <- function() {
  clipr::clipr_available()
}

.tar_clipr_write <- function(text) {
  clipr::write_clip(text)
}

.tar_is_windows <- function() {
  identical(.Platform$OS.type, "windows")
}

.tar_windows_write_clipboard <- function(text) {
  utils::writeClipboard(text)
}
