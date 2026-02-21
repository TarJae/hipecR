# Update Shiny inputs from record

Push a registry record into Shiny input controls.

## Usage

``` r
tar_update_inputs(data, session)
```

## Arguments

- data:

  A one-row data frame with registry fields.

- session:

  Shiny session.

## Value

Invisible NULL.

## See also

[`updateTextInput`](https://rdrr.io/pkg/shiny/man/updateTextInput.html),
[`updateNumericInput`](https://rdrr.io/pkg/shiny/man/updateNumericInput.html),
[`updateDateInput`](https://rdrr.io/pkg/shiny/man/updateDateInput.html)

## Examples

``` r
# \donttest{
if(interactive()){
 #EXAMPLE1
 }
# }
```
