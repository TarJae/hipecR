
![hipecR_hex](www/hipecR_gray.png)

# hipecR

<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN status](https://www.r-pkg.org/badges/version/hipecR)](https://CRAN.R-project.org/package=hipecR)
<!-- badges: end -->

The goal of hipecR is to offer a collection of useful functions for analyzing patient data, including some essential functions for calculating the Peritoneal Surface Area (PSA) individually for each patient. After determining the global PSA, we can assess the quantitative PSA before and after cytoreduction (surgery). The underlying idea is to provide a reproducible and comparable definition of the resected PSA across different institutions. The next step involves calculating the dosage of chemotherapy during Hyperthermic Intraperitoneal Chemotherapy (HIPEC), adapted to the remaining PSA.

## Installation

You can install the development version of hipecR like so:

``` r
library(devtools) # Make sure that the devtools library is loaded
install_github("tarjae/hipecR")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(hipecR)
## basic example code
```

