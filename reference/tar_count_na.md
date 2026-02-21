# NA counter

Counts NA values across columns.

## Usage

``` r
tar_count_na(df)
```

## Arguments

- df:

  A data frame or tibble.

## Value

A named numeric vector with NA counts per column.

## Examples

``` r
# \donttest{
if(interactive()){
 tar_count_na(mtcars)
 }
# }
```
