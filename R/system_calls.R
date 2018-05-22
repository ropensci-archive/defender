find_system_calls <- function(my_expression) {
  system_function_names <- c("system2")

  withr::with_options(
    c("keep.source" = TRUE),
    utils::getParseData(my_expression)
  ) %>%
    subset(.$token == "SYMBOL_FUNCTION_CALL") %>%
    subset(.$text == "system2")
}
