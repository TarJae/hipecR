# Imputates outliers and shows 4 different method plots

Imputates outliers and shows 4 different method plots

## Usage

``` r
tar_impute_outlier(df, variable)
```

## Arguments

- df:

  data frame or tibble where the numeric variable lives

- variable:

  Numeric variable column in the data frame

## Value

4 plots with mean, median, mode and capping imputation

## Examples

``` r
# \donttest{
if (interactive()) {
  tar_impute_outlier(mtcars, mpg)
}
# }
```
