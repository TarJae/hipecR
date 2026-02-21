# Convert a Windows Path to a WSL Path

Converts a Windows path (for example, `C:/Users/...` or `C:\Users\...`)
into a WSL path (`/mnt/c/Users/...` by default). Optionally copies the
converted path to the clipboard.

## Usage

``` r
tar_wsl_pfad(path = getwd(), copy_to_clipboard = TRUE, mount_root = "/mnt")
```

## Arguments

- path:

  A single Windows path string. Defaults to
  [`getwd()`](https://rdrr.io/r/base/getwd.html).

- copy_to_clipboard:

  Logical. If `TRUE`, try to copy the resulting WSL path to the
  clipboard.

- mount_root:

  Mount root used by WSL. Defaults to `"/mnt"`.

## Value

A single character string with the converted WSL path.

## Examples

``` r
tar_wsl_pfad("C:/Users/tarka/project", copy_to_clipboard = FALSE)
#> [1] "/mnt/c/Users/tarka/project"
tar_wsl_pfad("C:\\Users\\tarka\\project", copy_to_clipboard = FALSE)
#> [1] "/mnt/c/Users/tarka/project"
```
