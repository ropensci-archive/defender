
![](./man/figures/supergb.png)

# rOpenSci Unconf 18 Project : defender

## Authors:

  - Ildiko Czeller
  - Karthik Ram
  - Bob Rudis
  - Kara Woo

<!-- README.md is generated from README.Rmd. Please edit that file -->

# defender <img src="man/figures/logo.png" align="right"/>

[![Travis build
status](https://travis-ci.org/ropenscilabs/defender.svg?branch=master)](https://travis-ci.org/ropenscilabs/defender)
[![Coverage
status](https://img.shields.io/codecov/c/github/ropenscilabs/defender/master.svg)](https://codecov.io/github/ropenscilabs/defender?branch=master)

The goal of defender is to do static code analysis on other R packages
to check for potential security risks and best practices. It provides
checks on multiple levels:

1.  \[x\] static code analysis without installing the package
2.  \[ \] more thorough but potentially dangerous checks with
    installation / in Docker container

The checks do not tell you whether something is harmful but rather they
flag code that you should double-check before running / loading the
package.

## Installation

You can install defender from github with:

``` r
# install.packages("devtools")
devtools::install_github("ropenscilabs/defender")
```

## Example

### System calls in R scripts

You can check for system calls in any directory locally available:

``` r
defender::summarize_system_calls("../testevil")
#>                path line_number function_name
#> 1   inst/root_sys.R           1       system2
#> 2   inst/root_sys.R           4        system
#> 3      R/exported.R           7       system2
#> 4      R/internal.R           4        system
#> 5      R/internal.R           8        system
#> 6      R/processx.R           3           run
#> 7 R/system_hidden.R           2       system2
```

You can also include additional elements to flag as dangerous:

``` r
sc <- defender::system_calls("poll")
defender::summarize_system_calls("../testevil", calls_to_flag = sc)
#>                path line_number function_name
#> 1   inst/root_sys.R           1       system2
#> 2   inst/root_sys.R           4        system
#> 3      R/exported.R           7       system2
#> 4      R/internal.R           4        system
#> 5      R/internal.R           8        system
#> 6      R/processx.R           3           run
#> 7      R/processx.R           9          poll
#> 8 R/system_hidden.R           2       system2
```

### System-related imports in NAMESPACE

You can check the NAMESPACE file in a package for dangerous imports:

``` r
defender::check_namespace("../testevil")
#>       type        import  package
#> 1  package           sys      sys
#> 2  package      processx processx
#> 3 function processx::run processx
```

You can also include additional elements to flag as dangerous:

``` r
di <- defender::dangerous_imports("processx::poll")
defender::check_namespace("../testevil", imports_to_flag = di)
#>       type         import  package
#> 1  package            sys      sys
#> 2  package       processx processx
#> 3 function processx::poll processx
#> 4 function  processx::run processx
```

## Collaborators

  - Ildi Czeller @czeildi
  - Karthik Ram @karthik
  - Bob Rudis @hrbrmstr
  - Kara Woo @karawoo
