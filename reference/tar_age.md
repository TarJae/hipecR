# Calculate person age

This function calculates the age of a person by given birthdate and the
end date

## Usage

``` r
tar_age(birth_date, x_date)
```

## Arguments

- birth_date:

  A date value, e.g. "1974-11-23".

- x_date:

  A date value until the age lasts, e.g. "2023-02-16".

## Value

A numeric value in (years)

## Examples

``` r
tar_age("1974-11-23", "2023-02-16")
#> [1] 48
```
