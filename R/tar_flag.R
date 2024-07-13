#' Create a combined flag plot
#'
#' This function downloads flag images of specified countries, combines them
#' vertically with spaces in between, and saves the combined image to a file.
#'
#' @param countries A character vector of country codes (ISO 3166\-1 alpha\-2).
#' @param name A character string for the name of the study. This will be used
#'        to construct the output file name.
#'
#' @return None. The function saves the combined flag image to a file.
#'
#' @examples
#' tar_flag(c("nl", "se", "es", "si", "dk", "no", "us"), "rapido")
#'
#' @import ggplot2
#' @import magick
#' @import curl
#' @export

tar_flag <- function(countries, name) {

  # Function to check internet connection
  is_connected <- function() {
    !is.null(curl::nslookup("www.google.com", error = FALSE))
  }

  if (!is_connected()) {
    stop("No internet connection. Please check your internet connection and try again.")
  }

  # Check if "images" folder exists, if not, create it
  if (!dir.exists("images")) {
    dir.create("images")
  }

  # Construct the output file name
  output_file <- paste0("images/", name, "_flag.png")

  # URLs of the flags from Flagpedia.net
  base_url <- "https://flagpedia.net/data/flags/h80/"
  urls <- paste0(base_url, countries, ".png")

  # Download the images and read them into memory
  flag_images <- lapply(urls, function(url) {
    image_read(url)
  })

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
}

