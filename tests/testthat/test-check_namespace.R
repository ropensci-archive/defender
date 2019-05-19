context("test-check_namespace.R")

setup({
  td <- file.path(normalizePath("."), "testdir")
  unlink(td, recursive = TRUE)
  dir.create(td)
})

teardown({
  td <- file.path(normalizePath("."), "testdir")
  unlink(td, recursive = TRUE)
})

test_that("parse fqrs from nested list to vector", {
  expect_equal(
    transform_fully_qualified_refereces(
      list(list("processx", "run"), list("httr", "verbose"))
    ),
    c("processx::run", "httr::verbose")
  )
})

test_that("extract packges from fully qualified references", {
  expect_equal(
    extract_pkgs_from_fully_qualified_references(
      list(list("processx", "run"), list("httr", "verbose"))
    ),
    c("processx", "httr")
  )
})

test_that("extract fqrs from all imports", {
  expect_equal(
    extract_fully_qualified_references(
      list("sys", list("processx", "run"), "httr")
    ),
    list(list("processx", "run"))
  )
})

test_that("extract whole package imports", {
  expect_equal(
    extract_whole_pkg_imports(
      list(list("sys"), list("processx", "run"), list("httr"))
    ),
    c("sys", "httr")
  )
})

test_that("parse namespace file", {
  td <- file.path(normalizePath("."), "testdir")
  unlink(td, recursive = TRUE)
  dir.create(td)
  file.create(file.path(td, "NAMESPACE"))
  expect_true(
    all(c("imports", "exports") %in% names(parse_ns_file(td)))
  )
  unlink(td, recursive = TRUE)
})

test_that("summarize imports handles empty import list", {
  expect_silent(summarize_imports(list(), list()))
})

test_that("summarize imports returns data frame", {
  expect_is(
    summarize_imports("sys", "processx::run"),
    "data.frame"
  )
  expect_named(
    summarize_imports("sys", "processx::run"),
    c("type", "import", "package")
  )
})

test_that("parse all imports by type", {
  expect_named(
    parse_all_imports(
      list(list("sys"), list("processx", "run"), list("httr"))
    ),
    c("imported_packages", "imported_functions")
  )
})

test_that("check namespace fails if path is not package", {
  expect_error(check_namespace(tempdir()))
  expect_error(check_namespace("nonexistent/path"))
})

test_that("check namespace returns only flagged imports", {
  td <- file.path(normalizePath("."), "testdir")
  unlink(td, recursive = TRUE)
  dir.create(td)
  file.create(file.path(td, "DESCRIPTION"))
  writeLines("import(magrittr)", file.path(td, "NAMESPACE"))
  expect_equal(
    nrow(check_namespace(td, imports_to_flag = "withr")),
    0
  )
  expect_equal(
    nrow(check_namespace(td, imports_to_flag = "magrittr")),
    1
  )
  unlink(td, recursive = TRUE)
})
