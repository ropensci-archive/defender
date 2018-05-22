find_system_calls <- function(my_expression) {
  if (!class(my_expression) == "expression") {
    stop("Param e must be of class `expression`.")
  }

  system_function_names <- c("system2")

  parsed_data <- withr::with_options(
    c("keep.source" = TRUE),
    utils::getParseData(my_expression)
  )

  parsed_data %>%
    dplyr::filter(token == "SYMBOL_FUNCTION_CALL") %>%
    dplyr::filter(text %in% system_function_names)
}
