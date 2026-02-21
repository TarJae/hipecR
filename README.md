![hipecR_hex](www/hipecR_gray.png)

# hipecR

<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN status](https://www.r-pkg.org/badges/version/hipecR)](https://CRAN.R-project.org/package=hipecR)
<!-- badges: end -->

The goal of hipecR is to offer a collection of useful functions for analyzing patient data, including some essential functions for calculating the Peritoneal Surface Area (PSA) individually for each patient. After determining the global PSA, we can assess the quantitative PSA before and after cytoreduction (surgery). The underlying idea is to provide a reproducible and comparable definition of the resected PSA across different institutions. The next step involves calculating the dosage of chemotherapy during Hyperthermic Intraperitoneal Chemotherapy (HIPEC), adapted to the remaining PSA.

## Installation

Install the CRAN release:

``` r
install.packages("hipecR")
```

Or install the development version from GitHub:

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

## Function Reference (R/)

Below is a concise overview of all exported functions in `R/`, grouped by purpose.

### Clinical / Biometric

- `tar_age`: age (years) from two dates.
```r
tar_age("1974-11-23", "2023-02-16")
```
- `tar_bmi`: body mass index from weight/height.
```r
tar_bmi(weight = 100, height = 190)
```
- `tar_bsa`: body surface area (DuBois).
```r
tar_bsa(height = 180, weight = 80)
```
- `tar_psa`: peritoneal surface area (1% in cm^2).
```r
tar_psa(height = 180, weight = 80)
```

### Data Utilities

- `tar_count_top`: lump and count top factor levels.
```r
tar_count_top(mtcars, cyl, n = 2)
```
- `tar_count_na`: count NA per column.
```r
tar_count_na(mtcars)
```
- `tar_head_tail`: show head + tail of a data frame.
```r
tar_head_tail(mtcars, nh = 3, nt = 2)
```
- `tar_dgav_lookup`: lookup by name or ID.
```r
df <- data.frame(Name = c("Hans", "Maria"), azl = c("100", "101"))
tar_dgav_lookup(df, "Hans")
tar_dgav_lookup(df, 101)
```
- `tar_yes_no`: map "yes"/"no" to 1/0.
```r
tar_yes_no(c("yes", "no", "maybe"))
```
- `tar_impute_outlier`: compare outlier imputation methods.
```r
tar_impute_outlier(mtcars, mpg)
```

### Visualization / Reporting

- `tar_animbar`: animated bar chart GIF.
```r
tar_animbar(x = 45, filename = "a4", title = "%", horizontal = FALSE)
```
- `tar_flag`: download and compose country flags (PNG).
```r
tar_flag(c("nl", "se", "es"), "rapido", output_dir = "images", overwrite = TRUE)
```
- `tar_footnote`: add a footnote to a `grViz` graph and save as PNG.
```r
tar_footnote(graph, style = "color: grey; font-size: 10px;", string = "Notes...")
```
- `tar_ggplot_font_size`: harmonize ggplot theme sizes.
```r
p + tar_ggplot_font_size(10)
```
- `tar_median_survival`: survival plot with median annotations.
```r
tar_median_survival(df_survival, sex, time_col = "time", status_col = "status")
```

### HIPEC Registry (CRUD + Shiny)

- `tar_get_table_metadata`: get fields/labels mapping.
```r
tar_get_table_metadata()
```
- `tar_get_next_id`: next record ID based on `responses`.
```r
tar_get_next_id()
```
- `tar_create_data`, `tar_read_data`, `tar_update_data`, `tar_delete_data`:
```r
tar_create_data(new_row)
tar_read_data()
tar_update_data(updated_row)
tar_delete_data(list(id = "3"))
```
- `tar_cast_data`: coerce input to 1-row data frame.
```r
tar_cast_data(input_list)
```
- `tar_create_default_record`: create empty record.
```r
tar_create_default_record()
```
- `tar_update_inputs`: push data into Shiny inputs.
```r
tar_update_inputs(record, session)
```
- `tar_WellPanel`: UI helper for follow-up panels.
```r
tar_WellPanel(6)
```
- `tar_dateInput`: date input with Austrian format.
```r
tar_dateInput("FUp_6Mo_Datum", "Datum")
```

### Developer Convenience

- `tar_install`: short install helper.
```r
tar_install(dplyr)
```
- `tar_oneline`: reformat clipboard code to a one-liner.
```r
tar_oneline()
```
- `tar_print`: set tibble print min.
```r
tar_print(100)
```

