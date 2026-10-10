#### ADD YOUR FUNCTIONS!
 
 - Create `funcs.R` in the `/R` folder - Copy paste your code inside
    (Try to be explicit `package::function` at least once per used function per your function)
 
 - createOxygen for each function - commit function to memory, doubleclick title, run addin
sinew::makeImport("R", format = "description") and add to DESCRIPTION
 - In Build menu >> More >> Configure Build tools >> Generate Documentation >> Install and Restart

usethis::use_r("xxxx")
tab Code -> Insert roxygen

Use Rstudio Build and install, or do:
devtools::document()
devtools::build()
devtools::install()

Then, to check if everything is working, use these two:

devtools::check()
goodpractice::gp()

If you are using the tidyverse, you will probably get "global definition" issues. Make sure you
put all of the complained items inside a globalVariables.R file using the following format:

utils::globalVariables(c("name","id", "from", "to", "n", "value"))


REMEMBER TO CHECK DOCUMENTATION:
  - Roxygen for each function
  - README.Rmd
  - DESCRIPTION
  - NEWS

pkgdown::build_site()
(you might have to check your .gitignore: if it includes "docs", then delete it and save the .gitignore)
 - git commit/push
 - set master/docs as the Repos webpage

 - To think about:
usethis::use_code_of_conduct()
use_testthat()
amitFuncs::pleaseForTheLoveOfGodLetMeBuild()
usethis::use_dev_version()
use_vignette()

---

#### RELEASE + WEBSITE WORKFLOW (main vs gh-pages)

1) **Code changes always on `main`**
- Add function in `R/`
- Add roxygen docs
- Run:
  - `devtools::document()`
  - `devtools::test()`
  - `devtools::check()`
- Commit + push to `main`

2) **pkgdown website content**
- Build locally: `pkgdown::build_site()` (creates/updates `docs/`)
- Keep package source on `main`
- Publish static site on `gh-pages` (branch root content = website files)

3) **Safe deploy from `docs/` to `gh-pages` (Windows)**
- In repo root:
  - `git worktree add ..\\_gh-pages gh-pages`
  - `robocopy docs ..\\_gh-pages /MIR /XD .git /XF .git`
  - `cd ..\\_gh-pages`
  - `git add -A`
  - `git commit -m "Deploy pkgdown site"`
  - `git push origin gh-pages`

4) **Important notes**
- Do **not** use `/MIR` without excluding `.git` file in worktree, otherwise the worktree breaks.
- `main` = package source code, tests, docs source.
- `gh-pages` = generated static website only.

5) **Install behavior**
- CRAN install: `install.packages("hipecR")` (not `"hipec"`).
- New functions are available from CRAN only after a new CRAN release.
- Until then, install dev version from GitHub:
  - `remotes::install_github("TarJae/hipecR")`
