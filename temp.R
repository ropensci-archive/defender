options("keep.source" = FALSE)

utils::getParseData(parse(text = "foo()\nsystem2()"))

withr::with_options(
  c("keep.source" = TRUE),
  utils::getParseData(parse(text = "foo()\nsystem2()"))
)

withr::with_options(
  c("keep.source" = FALSE),
  utils::getParseData(parse(text = "foo()\nsystem2()"))
)

utils::getParseData(parse(text = "foo()\nsystem2()"))



options("keep.source" = TRUE)

utils::getParseData(parse(text = "foo()\nsystem2()"))

withr::with_options(
  c("keep.source" = TRUE),
  utils::getParseData(parse(text = "foo()\nsystem2()"))
)

withr::with_options(
  c("keep.source" = FALSE),
  utils::getParseData(parse(text = "foo()\nsystem2()"))
)

utils::getParseData(parse(text = "foo()\nsystem2()"))

devtools::load_all()
find_system_calls(parse(text = "foo()\nsystem2()"))
