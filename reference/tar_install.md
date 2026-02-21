# Short Installer

Helper that returns an \`install.packages()\` command for a package
name.

## Usage

``` r
tar_install(x)
```

## Arguments

- x:

  The name of the package you want to install.

## Value

A character string with the corresponding \`install.packages()\`
command.

## Details

This function uses non-standard evaluation to allow you to specify the
package name unquoted.

## Examples

``` r
# \donttest{
tar_install(dplyr)
#> [1] "install.packages('dplyr')"
# }
```
