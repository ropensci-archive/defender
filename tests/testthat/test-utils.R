context("test-utils.R")

setup({
  td <- file.path(normalizePath("."), "testdir")
  unlink(td, recursive = TRUE)
  dir.create(td)
})

teardown({
  td <- file.path(normalizePath("."), "testdir")
  unlink(td, recursive = TRUE)
})

test_that("throw error iff path does not point to a package", {
  td <- file.path(normalizePath("."), "testdir")
  unlink(td, recursive = TRUE)
  dir.create(td)
  expect_error(assert_is_package(td))
  file.create(file.path(td, "DESCRIPTION"))
  expect_silent(assert_is_package(td))
  unlink(td, recursive = TRUE)
})

test_that("find R scripts in given directory", {
  td <- file.path(normalizePath("."), "testdir")
  unlink(td, recursive = TRUE)
  dir.create(td)
  dir.create(file.path(td, "inner"))
  file.create(file.path(td, "first.r"))
  file.create(file.path(td, "second.R"))
  file.create(file.path(td, "third.h"))
  file.create(file.path(td, "inner", "fourth.R"))
  expect_length(
    get_r_script_paths(td), 3
  )
  unlink(td, recursive = TRUE)
})

test_that("return full path of found R scripts", {
  td <- file.path(normalizePath("."), "testdir")
  unlink(td, recursive = TRUE)
  dir.create(td)
  file.create(file.path(td, "first.r"))
  expect_false("first.r" %in% get_r_script_paths(td))
  unlink(td, recursive = TRUE)
})

test_that("return main packages doing system calls", {
  expect_setequal(
    c("sys", "processx"),
    pkgs_doing_system_calls()
  )
})

test_that("return union of built-in and user-defined dangerous imports", {
  expect_equal(
    dangerous_imports(c("testevil::evil", "processx::run")),
    c("sys", "processx", "processx::run", "testevil::evil")
  )
})
