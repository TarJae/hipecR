# Display both the head and tail of a dataframe or tibble

This function returns the first \`nh\` = n head and last \`nt\` = n tail
rows of a dataframe or tibble. Row numbers from the original data are
preserved as row names in the result.

## Usage

``` r
tar_head_tail(data, nh = 5, nt = 5)
```

## Arguments

- data:

  A data frame or tibble whose head and tail you wish to view.

- nh:

  An integer specifying the number of rows from the start of \`data\` to
  display. Default is 5.

- nt:

  An integer specifying the number of rows from the end of \`data\` to
  display. Default is 5.

## Value

A dataframe composed of the first \`nh\` and last \`nt\` rows of the
input data. The row numbers from the original data are used as row names
in the result.

## See also

[`rownames`](https://tibble.tidyverse.org/reference/rownames.html)

## Examples

``` r
# \donttest{
if(interactive()){
 # Generate example data
 df <- data.frame(A = 1:10, B = 11:20)
 tar_head_tail(df, nh = 3, nt = 2)
 }
# }
```
