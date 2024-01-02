#' Adjust Theme Sizes in ggplot2
#'
#' This function adjusts the sizes of various theme elements in a ggplot2 plot.
#' It takes a single argument which is the base size for geom_text, and it
#' calculates the theme sizes based on this.
#'
#' @param geom_text_size The base size for text elements in `geom_text`. Default is 7.
#' @return A `theme` object that can be added to a ggplot.
#' @export
#' @importFrom ggplot2 ggplot theme
#' @examples
#' library(ggplot2)
#' p <- ggplot(mtcars, aes(factor(vs), y = mpg, fill = factor(am))) +
#'   geom_bar(stat = "identity", position = "dodge") +
#'   labs(title = "my_title") +
#'   tar_ggplot_font_size(10)
#' print(p)
#'
#' @references
#' The formula is from here: https://stackoverflow.com/questions/25061822/ggplot-geom-text-font-size-control
#'
#' @details
#' Always add the same size as in geom_text, then all fonts will have the same size. Default size is 7. If there is no geom_text we can
#' control the font size of axis, legend, title and text with this function.
#'
tar_ggplot_font_size <- function(geom_text_size = 7) {
  theme_size <- (14/5) * geom_text_size
  theme(axis.text = element_text(size = theme_size, colour = "black"),
        legend.text = element_text(size = theme_size),
        plot.title = element_text(size = theme_size),
        text = element_text(size = theme_size))
}

