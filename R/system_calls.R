find_system_calls <- function(expr) {
  system_function_names <- c("system2", "system", "run")

  withr::with_options(
    c("keep.source" = TRUE),
    utils::getParseData(expr)
  ) %>%
    subset(.$token == "SYMBOL_FUNCTION_CALL") %>%
    subset(.$text %in% system_function_names)
}
