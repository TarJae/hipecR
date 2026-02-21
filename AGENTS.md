# AGENTS.md

# 

# Purpose: Persistent project instructions for Codex/agents.

# This file is read at the start of new sessions to keep context after restarts.

## Project Overview

- R package: hipecR (GitHub)
- Goal: functions refactored; keep R CMD check clean

## Standard Workflow

- Docs:
  [`devtools::document()`](https://devtools.r-lib.org/reference/document.html)
- Check:
  [`devtools::check()`](https://devtools.r-lib.org/reference/check.html)
- Install (local):
  `Rcmd.exe INSTALL --preclean --no-multiarch --with-keep.source .`

## Known Pitfalls and Fixes

- renv:
  - `.Rprofile` must only source `renv/activate.R` in interactive
    sessions.
- Quarto:
  - `quarto.cmd` can fail with `TMPDIR=...`.
  - Use the EXE explicitly:
    - `QUARTO=C:/Users/tarka/AppData/Local/Programs/Quarto/bin/quarto.exe`
    - In-session: `Sys.setenv(QUARTO = ".../quarto.exe")`

## Structure/Assets

- Web assets live in `inst/www` (not repo root `www`).
- Non-source artifacts (e.g., `my_animated_bar.gif`) are in
  `.Rbuildignore`.

## Check Notes

- R \>= 4.1 required (pipe `|>` and `\(...)` syntax).
- Long-running or file-producing examples should use `\\dontrun{}`.

## Conventions

- Only import packages that are used.
- Declare globals for NSE
  ([`rlang::.data`](https://rlang.r-lib.org/reference/dot-data.html) or
  globals).
