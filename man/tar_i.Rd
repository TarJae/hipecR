% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tar_i.R
\name{tar_i}
\alias{tar_i}
\title{Short Installer}
\usage{
tar_i(x)
}
\arguments{
\item{x}{The name of the package you want to install.}
}
\value{
Installs a package.
}
\description{
Function to facilitate the use of
install.packages("dplyr") as tar_i(dplyr).
}
\details{
This function uses non-standard evaluation to allow you to specify
the package name unquoted.
}
\examples{
\dontrun{
if (interactive()) {
  tar_i(dplyr)
}
}
}
