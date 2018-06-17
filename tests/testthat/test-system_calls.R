context("test-system_calls.R")

setup({
  td <- file.path(normalizePath("."), "testdir")
  unlink(td, recursive = TRUE)
  dir.create(td)
})

teardown({
  unlink(td, recursive = TRUE)
})

test_that("expression is parsed to data frame", {
  expect_s3_class(
    find_system_calls(parse(text = "system2()")),
    "data.frame"
  )
})


test_that("find system calls returns rows of getParseData with only function calls", {
  expect_setequal(
    find_system_calls(parse(text = "system2()"))$token,
    "SYMBOL_FUNCTION_CALL"
  )
})


test_that("find system calls does not return plain functions calls", {
  expect_equal(
    nrow(find_system_calls(parse(text = "foo()\nsystem2()\nsystem()"))),
    2
  )
})


test_that("informative error message if directory is not found", {
  expect_error(
    summarize_system_calls(file.path("non", "existent", "path")),
    "Path non/existent/path not found, you may want to clone the repository first."
  )
})


test_that("summarize system calls returns one data frame", {
  td <- file.path(normalizePath("."), "testdir")
  unlink(td, recursive = TRUE)
  dir.create(td)
  writeLines("sys::run()", file.path(td, "test.R"))
  expect_is(
    summarize_system_calls(td),
    "data.frame"
  )
  expect_is(
    summarize_system_calls(td, "sys::run"),
    "data.frame"
  )
  unlink(td, recursive = TRUE)
})
