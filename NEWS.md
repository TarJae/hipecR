# hipecR (development version)

* Breaking change: `tar_dgav_lookup()` now uses `internalno` instead of `azl`,
  requires the additional registry-assigned `uid` column, supports explicit
  `from` and `to` arguments, and reports invalid or unmatched keys more
  precisely.
* `tar_bmi()`, `tar_bsa()`, and `tar_psa()` now handle missing, non-finite,
  and physically invalid values element-wise by returning `NA`.

# hipecR 2.0.0

* BREAKING: Refactored all functions.
* Improved overall code quality.
* CRAN release 2.0.0 (submission SHA: `b8724f9`).

# hipecR 0.1.0

* Added a `NEWS.md` file to track changes to the package.
* Added `tar_head_tail()` function.
* Added functions for hipec registry.
* 2023-06-23: Added `tar_WellPanel()` and `tar_dateInput()` 
* 2023-06-23: Added `tar_oneline()`
