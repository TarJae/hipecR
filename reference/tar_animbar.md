# Create Animated Bar Chart

This function creates an animated bar chart with customizable colors and
orientation. The resulting GIF can be saved to a specified filename.

## Usage

``` r
tar_animbar(
  x,
  filename = "my_animated_bar",
  color1 = "steelblue1",
  color2 = "purple3",
  title = "%",
  horizontal = FALSE,
  total = 100,
  fps = 24,
  base_duration = 15,
  output_dir = tempdir(),
  overwrite = FALSE,
  ask = interactive()
)
```

## Arguments

- x:

  An integer indicating the value for the bar chart.

- filename:

  A string specifying the name of the output file (default:
  "my_animated_bar").

- color1:

  A string specifying the color for the first part of the bar (default:
  "steelblue1").

- color2:

  A string specifying the color for the second part of the bar (default:
  "purple3").

- title:

  A string specifying the title suffix for the animation (default:
  percent sign).

- horizontal:

  A logical value indicating whether the bar chart should be horizontal
  (default: FALSE).

- total:

  An integer indicating the maximum value for the bar chart scale
  (default: 100).

- fps:

  Frames per second for the animation (default: 24).

- base_duration:

  Base duration (seconds) for a full-scale animation (default: 15).

- output_dir:

  Output directory for the GIF (default: temporary directory).

- overwrite:

  Logical; overwrite an existing GIF (default: FALSE).

- ask:

  Logical; if TRUE, prompt when file exists (default: interactive()).

## Value

Invisible path to the generated GIF file.

## Details

This function generates an animated bar chart with customizable colors
and orientation. The resulting GIF can be saved to a specified filename.

## Examples

``` r
# \donttest{
if (interactive() && requireNamespace("gifski", quietly = TRUE)) {
  tar_animbar(x = 10, filename = "a3", color1 = "gold", color2 = "purple3",
              horizontal = TRUE, total = 10, fps = 5, base_duration = 1,
              output_dir = tempdir(), overwrite = TRUE, ask = FALSE)
  tar_animbar(x = 5, filename = "a4", color1 = "steelblue", color2 = "purple3",
              horizontal = FALSE, total = 10, fps = 5, base_duration = 1,
              output_dir = tempdir(), overwrite = TRUE, ask = FALSE)
  tar_animbar(x = 3, filename = "rapido_LRR", horizontal = FALSE, total = 10,
              fps = 5, base_duration = 1, output_dir = tempdir(),
              overwrite = TRUE, ask = FALSE)
}
# }
```
