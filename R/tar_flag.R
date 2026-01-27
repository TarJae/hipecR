#' Create a combined flag plot
#'
#' This function downloads flag images of specified countries, combines them
#' vertically with spaces in between, and saves the combined image to a file.
#'
#' @param countries A character vector of country codes (ISO 3166\-1 alpha\-2).
#' @param name A character string for the name of the study. This will be used
#'        to construct the output file name.
#' @param output_dir A directory for the output file (default: "images").
#' @param overwrite Logical; overwrite an existing PNG (default: FALSE).
#' @param ask Logical; if TRUE, prompt when file exists (default: interactive()).
#'
#' @return Invisible path to the saved PNG file.
#'
#' @examples
#' \dontrun{
#' tar_flag(c("nl", "se", "es", "si", "dk", "no", "us"), "rapido")
#' tar_flag(c("at", "de"), "demo", output_dir = "images", overwrite = TRUE)
#' }
#'
#' @import magick
#' @import curl
#' @export

tar_flag <- function(countries,
                     name,
                     output_dir = "images",
                     overwrite = FALSE,
                     ask = interactive()) {

  if (!is.character(countries) || length(countries) < 1 || anyNA(countries)) {
    stop("countries must be a non-empty character vector without NA.")
  }
  if (!is.character(name) || length(name) != 1 || is.na(name) || nchar(name) == 0) {
    stop("name must be a non-empty character string.")
  }
  if (!is.character(output_dir) || length(output_dir) != 1 || is.na(output_dir) || nchar(output_dir) == 0) {
    stop("output_dir must be a non-empty character string.")
  }
  if (!is.logical(overwrite) || length(overwrite) != 1) {
    stop("overwrite must be a single logical value.")
  }
  if (!is.logical(ask) || length(ask) != 1) {
    stop("ask must be a single logical value.")
  }

  # Check if output folder exists, if not, create it
  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)
  }

  # Construct the output file name
  output_file <- file.path(output_dir, paste0(name, "_flag.png"))
  if (file.exists(output_file)) {
    if (overwrite) {
      # Proceed to overwrite silently
    } else if (ask) {
      overwrite_answer <- readline(prompt = "File already exists. Overwrite? (yes/no): ")
      if (tolower(overwrite_answer) != "yes") {
        stop("Output file exists and overwrite is FALSE.")
      }
    } else {
      stop("Output file exists and overwrite is FALSE.")
    }
  }

  countries <- tolower(trimws(countries))

  # URLs of the flags from Flagpedia.net
  base_url <- "https://flagpedia.net/data/flags/h80/"
  urls <- paste0(base_url, countries, ".png")

  # Download the images and read them into memory (skip failures)
  flag_images <- list()
  for (i in seq_along(urls)) {
    img <- try(magick::image_read(urls[i]), silent = TRUE)
    if (inherits(img, "try-error")) {
      warning("Failed to download flag for country code: ", countries[i])
    } else {
      flag_images[[length(flag_images) + 1]] <- img
    }
  }
  if (length(flag_images) == 0) {
    stop("No flags could be downloaded. Please check country codes or connectivity.")
  }

  # Ensure consistent flag size
  flag_width <- 300  # Desired width of each flag
  flag_height <- 200 # Desired height of each flag
  space_height <- 10 # Height of the space between flags

  # Resize all flag images to the same size
  flag_images <- lapply(flag_images, function(img) {
    magick::image_resize(img, paste0(flag_width, "x", flag_height, "!"))
  })

  # Create a blank image for the space
  space_image <- magick::image_blank(width = flag_width, height = space_height, color = "white")

  # Interleave the flags with spaces
  images_with_spaces <- c(rbind(flag_images, rep(list(space_image), length(flag_images))))

  # Remove the last space (if added)
  if (length(images_with_spaces) > length(flag_images) * 2 - 1) {
    images_with_spaces <- images_with_spaces[-length(images_with_spaces)]
  }

  # Combine flags and spaces vertically
  combined_image <- magick::image_append(magick::image_join(images_with_spaces), stack = TRUE)

  # Save the combined image
  magick::image_write(combined_image, path = output_file)

  invisible(output_file)
}

