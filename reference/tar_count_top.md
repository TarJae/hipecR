# Count Top Categories in a Factor

This function transforms the specified factor variable within a
dataframe to lump all but the top n most frequent levels into an 'Other'
category and then computes the count of each level.

## Usage

``` r
tar_count_top(df, var, n = 5)
```

## Arguments

- df:

  A data frame containing the variable to be manipulated.

- var:

  The variable (unquoted) within the data frame.

- n:

  The number of top levels to keep before lumping others into 'Other';
  default is 5.

## Value

A dataframe showing the count of each level including 'Other' for all
lumped lesser categories.

## Details

This function leverages \`dplyr\` for data manipulation and \`forcats\`
for managing factor levels. It is particularly useful in data
summarization where the focus is on the most frequent categories.

## Examples

``` r
# \donttest{
if(interactive()){
  data <- data.frame(color = c("red", "blue", "green", "blue", "blue", "red", "yellow", "red"))
  print(tar_count_top(data, color, n = 2))
 }
# }
```
