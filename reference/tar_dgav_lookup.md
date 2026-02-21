# Look-up function for DGAV registry IDs/names

This function takes a data frame \`df\` and a vector of key values
\`mykeyvalues\`. It returns an unnamed vector of corresponding results
by performing lookups in the data frame.

## Usage

``` r
tar_dgav_lookup(df, mykeyvalues)
```

## Arguments

- df:

  data frame with Name and azl number

- mykeyvalues:

  is a vector containing the key values to be looked up in the data
  frame. These key values can be either numeric or character strings.
  The function processes each key value individually to determine if it
  matches entries in the specified columns of the data frame

## Value

a key or value, depending on what is wanted

## Examples

``` r
# Example data
df <- data.frame(
  Name = c("Hans", "Maria", "Franz HUBER"),
  azl = c("1006341612", "1040405318", "1060707219"),
  stringsAsFactors = FALSE
)

tar_dgav_lookup(df, "HUBER")       # Should return "1060707219"
#> [1] "1060707219"
tar_dgav_lookup(df, "huber")       # Should also return "1060707219"
#> [1] "1060707219"
tar_dgav_lookup(df, "Franz")       # Should return "1060707219"
#> [1] "1060707219"
tar_dgav_lookup(df, 1006341612)  # Should return "Hans"
#> [1] "Hans"
tar_dgav_lookup(df, c(1006341612, 1040405318)) # Should return "Hans"  "Maria"
#> [1] "Hans"  "Maria"

# Function to handle inputs for data frame
```
