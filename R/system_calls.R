find_system_calls <- function(e) {
  if (!class(e) == "expression") {
    stop("Param e must be of class `expression`.")
  }

  system_function_names <- c("system2")

  utils::getParseData(e) %>%
    dplyr::filter(token == "SYMBOL_FUNCTION_CALL") %>%
    dplyr::filter(text %in% system_function_names)
}
