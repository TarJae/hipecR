% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tar_footnote.R
\name{tar_footnote}
\alias{tar_footnote}
\title{Add Footnote to Graph and Save as PNG}
\usage{
tar_footnote(graph, style, string)
}
\arguments{
\item{graph}{A `grViz` graph object.}

\item{style}{A character string specifying the CSS style for the footnote.}

\item{string}{A character string specifying the footnote text.}
}
\value{
None. The function saves a PNG file in the working directory.
}
\description{
This function takes a `grViz` graph object, adds a footnote with specified style and text,
and saves the graph along with the footnote as a PNG file. The PNG file is named based on the
graph object name.
}
\examples{
\dontrun{
library(htmltools)
library(webshot2)

graph <- grViz("
digraph {
graph [layout = dot]
node [shape = box]
a [label = 'A']
b [label = 'B']
a -> {b}
}
")

style <- "color: grey; font-family: Arial; text-align: left; font-size: 10px;"
string <- "CNCT = Consolidation Chemotherapy, CRT = Chemoradiotherapy, CT = Chemotherapy, INCT = Induction Chemotherapy, SCRT = Short-course Radiotherapy, TME = Total Mesorectal Excision, WW = Watch and Wait,"

tar_footnote(graph, style, string)
}
}
