# Body surface area calculator in m^2 (DuBois and DuBois formula)

This function calculates the body surface area with the DuBois method.
DuBois D. A formula to estimate the approximate surface area if height
and body mass are known. Arch Intern Med 1916;17:863-71.

## Usage

``` r
tar_bsa(height, weight)
```

## Arguments

- height:

  A numeric value in cm

- weight:

  A numeric value in kg

## Value

A numeric value in m^2

## Examples

``` r
tar_bsa(height = 180, weight = 80) # ~1.996421 m^2
#> [1] 1.996421
```
