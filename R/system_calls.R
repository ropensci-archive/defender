#' summarize occurences of system calls in project
#'
#' Summarize and show occurences of system calls in the R files in a given
#' folder. There could be more occurences. These calls should be further checked
#' for maliciousness.
#'
#' @param path character, relative or absolute path for local code directory
#'
#' @return data.frame with a row for each system call
#' @export
#'
#' @examples \dontrun{
#' # git clone git@github.com:hrbrmstr/testevil.git
#' summarize_system_calls("testevil")
#' }
summarize_system_calls <- function(path) {
  r_paths <- get_r_script_paths(path = path)
  summaries_by_file <- lapply(r_paths, digest_system_calls, path)
  Reduce(rbind, summaries_by_file)
}

digest_system_calls <- function(r_file, path) {
  summary <- find_system_calls(parse(r_file))
  if (nrow(summary) > 0L) {
    summary$path <- sub(paste0("^", path, "/"), "", r_file)
  }
  summary
}

find_system_calls <- function(expr) {
  system_function_names <- c("system2", "system", "run")

  withr::with_options(
    c("keep.source" = TRUE),
    utils::getParseData(expr)
  ) %>%
    subset(.$token == "SYMBOL_FUNCTION_CALL") %>%
    subset(.$text %in% system_function_names)
}
