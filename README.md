# defender

[![Travis build status](https://travis-ci.org/ropenscilabs/defender.svg?branch=master)](https://travis-ci.org/ropenscilabs/defender)
[![Coverage status](https://img.shields.io/codecov/c/github/ropenscilabs/defender/master.svg)](https://codecov.io/github/ropenscilabs/defender?branch=master)

The goal of defender is to do static code analysis on other R packages to check for potential security risks and best practices

## Installation

You can install defender from github with:


``` r
# install.packages("devtools")
devtools::install_github("ropenscilabs/defender")
```

## Goal

Provide checks on multiple levels

1. static code analysis, only clones a repo but does not install the package
2. more thorough but potentially dangerous checks with installation / in Docker container

## Example

This is a basic example which shows you how to solve a common problem:

``` r
summarize_system_calls(".")
summarize_system_calls("./testevil")
```
