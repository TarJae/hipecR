# NA

#### ADD YOUR FUNCTIONS!

- Create `funcs.R` in the `/R` folder - Copy paste your code inside (Try
  to be explicit `package::function` at least once per used function per
  your function)

- createOxygen for each function - commit function to memory,
  doubleclick title, run addin sinew::makeImport(“R”, format =
  “description”) and add to DESCRIPTION

- In Build menu \>\> More \>\> Configure Build tools \>\> Generate
  Documentation \>\> Install and Restart

usethis::use_r(“xxxx”) tab Code -\> Insert roxygen

Use Rstudio Build and install, or do: devtools::document()
devtools::build() devtools::install()

Then, to check if everything is working, use these two:

devtools::check() goodpractice::gp()

If you are using the tidyverse, you will probably get “global
definition” issues. Make sure you put all of the complained items inside
a globalVariables.R file using the following format:

utils::globalVariables(c(“name”,“id”, “from”, “to”, “n”, “value”))

REMEMBER TO CHECK DOCUMENTATION: - Roxygen for each function -
README.Rmd - DESCRIPTION - NEWS

pkgdown::build_site() (you might have to check your .gitignore: if it
includes “docs”, then delete it and save the .gitignore) - git
commit/push - set master/docs as the Repos webpage

- To think about: usethis::use_code_of_conduct() use_testthat()
  amitFuncs::pleaseForTheLoveOfGodLetMeBuild()
  usethis::use_dev_version() use_vignette()
