#' Add Footnote to Graph and Save as PNG
#'
#' This function takes a `grViz` graph object, adds a footnote with specified style and text,
#' and saves the graph along with the footnote as a PNG file. The PNG file is named based on the
#' graph object name.
#'
#' @param graph A `grViz` graph object.
#' @param style A character string specifying the CSS style for the footnote.
#' @param string A character string specifying the footnote text.
#'
#' @return None. The function saves a PNG file in the working directory.
#' @examples
#' \dontrun{
#' library(htmltools)
#' library(webshot2)
#'
#' graph <- grViz("
#' digraph {
#' graph [layout = dot]
#' node [shape = box]
#' a [label = 'A']
#' b [label = 'B']
#' a -> {b}
#' }
#' ")
#'
#' style <- "color: grey; font-family: Arial; text-align: left; font-size: 10px;"
#' string <- "CNCT = Consolidation Chemotherapy, CRT = Chemoradiotherapy, CT = Chemotherapy, INCT = Induction Chemotherapy, SCRT = Short-course Radiotherapy, TME = Total Mesorectal Excision, WW = Watch and Wait,"
#'
#' tar_footnote(graph, style, string)
#' }
#' @import htmltools webshot2
#' @export
tar_footnote <- function(graph, style, string) {
  # Get the name of the graph variable
  graph_name <- deparse(substitute(graph))

  # Set the filename based on the graph name
  filename <- graph_name

  # 1. Create the output with the graph and the footnote
  output <- htmltools::div(
    graph,
    htmltools::HTML(
      sprintf("<p style='%s'>%s</p>", style, string)
    )
  )

  # 2. Save the HTML content to a file
  html_file <- paste0(filename, ".html")
  htmltools::save_html(output, html_file)

  # 3. Convert the HTML file to PNG with a delay to ensure content is loaded
  webshot2::webshot(html_file, file = paste0(filename, ".png"), delay = 2, zoom = 3)

  # Optionally, delete the HTML file after the PNG file is created
  file.remove(html_file)
}
