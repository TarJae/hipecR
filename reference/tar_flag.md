# Create a combined flag plot

This function downloads flag images of specified countries, combines
them vertically with spaces in between, and saves the combined image to
a file.

## Usage

``` r
tar_flag(
  countries,
  name,
  output_dir = tempdir(),
  overwrite = FALSE,
  ask = interactive()
)
```

## Arguments

- countries:

  A character vector of country codes (ISO 3166\\1 alpha\\2).

- name:

  A character string for the name of the study. This will be used to
  construct the output file name.

- output_dir:

  A directory for the output file (default: temporary directory).

- overwrite:

  Logical; overwrite an existing PNG (default: FALSE).

- ask:

  Logical; if TRUE, prompt when file exists (default: interactive()).

## Value

Invisible path to the saved PNG file.

## Examples

``` r
# \donttest{
if (interactive()) {
  tar_flag(c("nl", "se", "es", "si", "dk", "no", "us"), "rapido")
  tar_flag(c("at", "de"), "demo", output_dir = tempdir(), overwrite = TRUE)
}
# }
```
