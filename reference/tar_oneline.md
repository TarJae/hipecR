# tar_oneline

Creates a one-liner from a multiline code example in the clipboard.

## Usage

``` r
tar_oneline()
```

## Value

A character vector with the reformatted one-line code.

## See also

[`tidy_source`](https://rdrr.io/pkg/formatR/man/tidy_source.html)

## Examples

``` r
# \donttest{
if (interactive()) {
  # Your multiline string
  # copy this code
  numericInput(
    "Register_Nr",
    "Nr.",
    min = 0,
    max = 20,
    step = 1,
    value = 0
  )
  # then apply
  tar_oneline()
}
# }
```
