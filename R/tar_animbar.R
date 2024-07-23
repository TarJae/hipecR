#' Create Animated Bar Chart
#'
#' This function generates an animated bar chart with customizable colors and orientation.
#' The resulting GIF can be saved to a specified filename.
#'
#' @param x An integer indicating the maximum value for the bar chart.
#' @param filename A string specifying the name of the output file (default: "my_animated_bar").
#' @param color1 A string specifying the color for the first part of the bar (default: "steelblue1").
#' @param color2 A string specifying the color for the second part of the bar (default: "purple3").
#' @param title A string specifying the title suffix for the animation (default: "\%").
#' @param horizontal A logical value indicating whether the bar chart should be horizontal (default: FALSE).
#'
#' @return No return value. The function generates and saves an animated bar chart as a GIF file.
#' @description This function creates an animated bar chart with customizable colors and orientation. The resulting GIF can be saved to a specified filename.
#'
#' @examples
#' tar_animbar(x = 100, filename = "a3", color1 = "gold", color2 = "purple3", title = "%", horizontal = TRUE)
#' tar_animbar(x = 45, filename = "a4", color1 = "steelblue", color2 = "purple3", title = "%", horizontal = FALSE)
#' tar_animbar(x = 17, filename = "rapido_LRR", horizontal = FALSE)
#'
#' @importFrom ggplot2 ggplot aes geom_col scale_fill_manual theme_void theme labs element_text position_fill geom_text coord_flip
#' @importFrom gganimate transition_states enter_grow ease_aes exit_shrink animate anim_save gifski_renderer
#' @importFrom magick image_read image_trim image_write
#' @importFrom tidyr pivot_longer
#' @importFrom dplyr mutate
#' @importFrom tibble tibble
#' @export
tar_animbar <- function(x, filename = "my_animated_bar", color1 = "steelblue1", color2 = "purple3", title = "%", horizontal = FALSE) {
  # Check if the file already exists
  if (file.exists(paste0(filename, ".gif"))) {
    overwrite <- readline(prompt = "File already exists. Do you want to overwrite it? (yes/no): ")
    if (tolower(overwrite) != "yes") {
      filename <- readline(prompt = "Please enter a new filename: ")
    }
  }

  # Example data frame
  time <- 1:100
  value <- 1:x
  fill <- rep(max(value), 100 - max(value))
  df <- tibble(time = time,
               value = c(value, fill)) %>%
    mutate(fill_color = color1) %>%
    mutate(gold_nr = value) %>%
    mutate(blue_nr = 100 - gold_nr) %>%
    pivot_longer(c(gold_nr, blue_nr),
                 names_to = "color_group",
                 values_to = "value_group")

  # Dynamically calculate total duration based on x
  base_duration <- 15  # Base duration for x = 100
  duration <- base_duration * (x / 100)

  # Calculate the number of frames for even pacing
  total_frames <- duration * 24  # Total frames for the animation (24 fps)
  state_length <- total_frames / length(unique(df$value))
  transition_length <- state_length / 2

  # The modified ggplot and gganimate code
  p <- df %>%
    ggplot(aes("", value_group, fill = color_group)) +
    geom_col(width = 0.4, position = position_fill()) +
    scale_fill_manual(values = c(color1, color2)) +
    theme(
      axis.title = element_blank(),
      axis.text = element_blank(),
      axis.ticks = element_blank(),  # Remove axis ticks
      panel.grid = element_blank(),
      panel.border = element_blank(),
      plot.background = element_blank(),
      panel.background = element_blank(),
      legend.position = "none"
    ) +
    transition_states(value,
                      transition_length = transition_length,
                      state_length = state_length,
                      wrap = FALSE) +
    labs(title = paste0("{closest_state} ", title)) +
    enter_grow() +
    ease_aes('linear') +
    exit_shrink()

  # Add coord_flip() if horizontal is TRUE and adjust the geom_text counting x
  if (horizontal) {
    p <- p +
      theme(plot.title = element_text(hjust = 0.75, vjust = -21.5, size = 44, color = "white")) +
      coord_flip()
    width <- 600
    height <- 400
  } else {
    p <- p +
      theme(plot.title = element_text(hjust = 0.5, vjust = -16, size = 44, color = "white"))
    width <- 400
    height <- 600
  }

  a <- animate(p, fps = 24, duration = duration, width = width, height = height, end_pause = 20,
               renderer = gifski_renderer(loop = FALSE))
  temp_file <- paste0(filename, '_temp.gif')
  gganimate::anim_save(temp_file, a)

  # Load the image using magick and save the cropped version
  image_read(temp_file) |>
    image_trim() %>%  # Trim any extra white space
    image_write(path = paste0(filename, '.gif'))

  # Remove the temporary file
  file.remove(temp_file)
}
