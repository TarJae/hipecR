# Add Footnote to Graph and Save as PNG

This function takes a \`grViz\` graph object, adds a footnote with
specified style and text, and saves the graph along with the footnote as
a PNG file. The PNG file is named based on the graph object name.

## Usage

``` r
tar_footnote(
  graph,
  style,
  string,
  filename = NULL,
  output_dir = tempdir(),
  overwrite = FALSE,
  ask = interactive()
)
```

## Arguments

- graph:

  A \`grViz\` graph object.

- style:

  A character string specifying the CSS style for the footnote.

- string:

  A character string specifying the footnote text.

- filename:

  Optional output filename (without extension). Defaults to the variable
  name of \`graph\` if possible.

- output_dir:

  Output directory (default: temporary directory).

- overwrite:

  Logical; overwrite an existing PNG (default: FALSE).

- ask:

  Logical; if TRUE, prompt when file exists (default: interactive()).

## Value

None. The function saves a PNG file in the working directory.

## Examples

``` r
# \donttest{
if (interactive() && requireNamespace("DiagrammeR", quietly = TRUE)) {
graph <- DiagrammeR::grViz("
digraph {
graph [layout = dot]
node [shape = box]
a [label = 'A']
b [label = 'B']
a -> {b}
}
")

style <- "color: grey; font-family: Arial; text-align: left; font-size: 10px;"
string <- paste(
  "CNCT = Consolidation Chemotherapy,",
  "CRT = Chemoradiotherapy,",
  "CT = Chemotherapy,",
  "INCT = Induction Chemotherapy,",
  "SCRT = Short-course Radiotherapy,",
  "TME = Total Mesorectal Excision,",
  "WW = Watch and Wait,",
  sep = " "
)

tar_footnote(graph, style, string)
}
# }
```
