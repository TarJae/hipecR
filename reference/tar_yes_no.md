# Convert "yes" and "no" to 1 and 0

This function takes a vector and converts all instances of "yes" to 1,
"no" to 0, and leaves other values as NA. It's useful for converting
categorical "yes"/"no" responses into a numeric format that can be used
in statistical analysis.

## Usage

``` r
tar_yes_no(x)
```

## Arguments

- x:

  A vector containing elements to be converted. Elements should be
  character strings potentially including "yes" and "no".

## Value

A numeric vector where "yes" is replaced with 1, "no" with 0, and other
values with NA.

## Examples

``` r
test_vector <- c("yes", "no", "maybe", "yes", "no")
tar_yes_no(test_vector)
#> [1]  1  0 NA  1  0
```
