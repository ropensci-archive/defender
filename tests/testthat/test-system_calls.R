context("test-system_calls.R")

test_that("find system calls returns error if param is not an expression", {
  expect_error(
    find_system_calls(e = "foo <- function() 1"),
    "Param e must be of class `expression`"
  )
})

test_that("find system calls returns a 0 line data frame if no system calls in expression", {
  expect_equal(
    nrow(find_system_calls(e = parse(text = "foo <- function() 1"))),
    0
  )
})

test_that("find system calls returns rows of getParseData with only function calls", {
  expect_setequal(
    find_system_calls(e = parse(text = "system2()"))$token,
    "SYMBOL_FUNCTION_CALL"
  )
})

test_that("find system calls does not return plain functions calls", {
  expect_equal(
    nrow(find_system_calls(e = parse(text = "foo()\nsystem2()"))),
    1
  )
})
