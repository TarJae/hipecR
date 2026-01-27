#' Create Animated Bar Chart
#'
#' This function generates an animated bar chart with customizable colors and orientation.
#' The resulting GIF can be saved to a specified filename.
#'
#' @param x An integer indicating the value for the bar chart.
#' @param filename A string specifying the name of the output file (default: "my_animated_bar").
#' @param color1 A string specifying the color for the first part of the bar (default: "steelblue1").
#' @param color2 A string specifying the color for the second part of the bar (default: "purple3").
#' @param title A string specifying the title suffix for the animation (default: percent sign).
#' @param horizontal A logical value indicating whether the bar chart should be horizontal (default: FALSE).
#' @param total An integer indicating the maximum value for the bar chart scale (default: 100).
#' @param fps Frames per second for the animation (default: 24).
#' @param base_duration Base duration (seconds) for a full-scale animation (default: 15).
#' @param output_dir Output directory for the GIF (default: current working directory).
#' @param overwrite Logical; overwrite an existing GIF (default: FALSE).
#' @param ask Logical; if TRUE, prompt when file exists (default: interactive()).
#'
#' @return Invisible path to the generated GIF file.
#' @description This function creates an animated bar chart with customizable colors and orientation. The resulting GIF can be saved to a specified filename.
#'
#' @examples
#' \dontrun{
#' tar_animbar(x = 10, filename = "a3", color1 = "gold", color2 = "purple3",
#'             horizontal = TRUE, total = 10, fps = 5, base_duration = 1,
#'             output_dir = tempdir(), overwrite = TRUE, ask = FALSE)
#' tar_animbar(x = 5, filename = "a4", color1 = "steelblue", color2 = "purple3",
#'             horizontal = FALSE, total = 10, fps = 5, base_duration = 1,
#'             output_dir = tempdir(), overwrite = TRUE, ask = FALSE)
#' tar_animbar(x = 3, filename = "rapido_LRR", horizontal = FALSE, total = 10,
#'             fps = 5, base_duration = 1, output_dir = tempdir(),
#'             overwrite = TRUE, ask = FALSE)
#' }
#'
#' @importFrom ggplot2 ggplot aes geom_col scale_fill_manual theme_void theme labs element_text position_fill geom_text coord_flip
#' @importFrom gganimate transition_states enter_grow ease_aes exit_shrink animate anim_save gifski_renderer
#' @importFrom magick image_read image_trim image_write
#' @importFrom tidyr pivot_longer
#' @importFrom dplyr mutate
#' @importFrom tibble tibble
#' @importFrom rlang .data
#' @export
tar_animbar <- function(x,
                        filename = "my_animated_bar",
                        color1 = "steelblue1",
                        color2 = "purple3",
                        title = "%",
                        horizontal = FALSE,
                        total = 100,
                        fps = 24,
                        base_duration = 15,
                        output_dir = ".",
                        overwrite = FALSE,
                        ask = interactive()) {
  if (!is.numeric(x) || length(x) != 1) {
    stop("x must be a single numeric value.")
  }
  if (!is.character(filename) || length(filename) != 1 || is.na(filename) || nchar(filename) == 0) {
    stop("filename must be a non-empty character string.")
  }
  if (!is.numeric(total) || length(total) != 1 || total <= 0) {
    stop("total must be a single positive numeric value.")
  }
  if (x < 0 || x > total) {
    stop("x must be between 0 and total.")
  }
  if (!is.numeric(fps) || length(fps) != 1 || fps <= 0) {
    stop("fps must be a single positive numeric value.")
  }
  if (!is.numeric(base_duration) || length(base_duration) != 1 || base_duration <= 0) {
    stop("base_duration must be a single positive numeric value.")
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

  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)
  }
  gif_path <- file.path(output_dir, paste0(filename, ".gif"))
  if (file.exists(gif_path)) {
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

  # Example data frame
  time <- 1:total
  value <- 1:x
  fill <- rep(x, total - x)
  df <- tibble::tibble(time = time,
               value = c(value, fill)) |>
    dplyr::mutate(fill_color = color1) |>
    dplyr::mutate(gold_nr = value,
                  blue_nr = total - value) |>
    tidyr::pivot_longer(c("gold_nr", "blue_nr"),
                 names_to = "color_group",
                 values_to = "value_group")

  # Dynamically calculate total duration based on x
  duration <- max(base_duration * (x / total), 1 / fps)

  # Calculate the number of frames for even pacing
  total_frames <- duration * fps  # Total frames for the animation
  state_length <- total_frames / length(unique(df$value))
  transition_length <- state_length / 2

  # The modified ggplot and gganimate code
  p <- df |>
    ggplot2::ggplot(ggplot2::aes("", .data$value_group, fill = .data$color_group)) +
    ggplot2::geom_col(width = 0.4, position = ggplot2::position_fill()) +
    ggplot2::scale_fill_manual(values = c(color1, color2)) +
    ggplot2::theme(
      axis.title = ggplot2::element_blank(),
      axis.text = ggplot2::element_blank(),
      axis.ticks = ggplot2::element_blank(),  # Remove axis ticks
      panel.grid = ggplot2::element_blank(),
      panel.border = ggplot2::element_blank(),
      plot.background = ggplot2::element_blank(),
      panel.background = ggplot2::element_blank(),
      legend.position = "none"
    ) +
    gganimate::transition_states(value,
                      transition_length = transition_length,
                      state_length = state_length,
                      wrap = FALSE) +
    ggplot2::labs(title = paste0("{closest_state} ", title)) +
    gganimate::enter_grow() +
    gganimate::ease_aes("linear") +
    gganimate::exit_shrink()

  # Add coord_flip() if horizontal is TRUE and adjust the geom_text counting x
  if (horizontal) {
    p <- p +
      ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.75, vjust = -21.5, size = 44, color = "white")) +
      ggplot2::coord_flip()
    width <- 600
    height <- 400
  } else {
    p <- p +
      ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5, vjust = -16, size = 44, color = "white"))
    width <- 400
    height <- 600
  }

  a <- gganimate::animate(p, fps = fps, duration = duration, width = width, height = height, end_pause = 20,
                          renderer = gganimate::gifski_renderer(loop = FALSE))
  temp_file <- tempfile(pattern = paste0(filename, "_"), fileext = ".gif")
  on.exit(unlink(temp_file), add = TRUE)
  gganimate::anim_save(temp_file, a)

  # Load the image using magick and save the cropped version
  magick::image_read(temp_file) |>
    magick::image_trim() |>
    magick::image_write(path = gif_path)

  invisible(gif_path)
}
