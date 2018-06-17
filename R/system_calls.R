#' summarize occurrences of system calls in project
#'
#' Summarize and show occurrences of system calls in the R files in a given
#' folder. There could be more occurrences. These calls should be further checked
#' for maliciousness.
#'
#' @param path character, relative or absolute path for local code directory
#' @param calls_to_flag character vector of functions names to flag as
#'   potentially dangerous system calls
#'
#' @return data.frame with a row for each system call
#' @export
#'
#' @examples \dontrun{
#' # git clone git@github.com:ropenscilabs/testevil.git
#' summarize_system_calls("testevil")
#' summarize_system_calls("testevil", system_calls("exec_background"))
#' }
summarize_system_calls <- function(path = ".", calls_to_flag = system_calls()) {
  assert_path_exists(path)

  r_paths <- get_r_script_paths(path = path)
  summaries_by_file <- lapply(r_paths, digest_system_calls, path, calls_to_flag)
  Reduce(rbind, summaries_by_file)
}

digest_system_calls <- function(r_file, path, calls_to_flag = system_calls()) {
  result <- find_system_calls(parse(r_file), calls_to_flag)
  if (nrow(result) == 0L) {
    return(result)
  }
  result$path <- sub(paste0("^", path, "/"), "", r_file)
  subset(result, select = c("path", "line1", "text", "function_name")) %>%
    magrittr::set_names(c("path", "line_number", "call", "function_name"))
}

find_system_calls <- function(expr, calls_to_flag = system_calls()) {
  parsed_data <- withr::with_options(
    c("keep.source" = TRUE),
    utils::getParseData(expr, includeText = TRUE)
  )

  base_fun_row_indexes <- which(
    (parsed_data$token == "SYMBOL_FUNCTION_CALL") & (parsed_data$text %in% calls_to_flag)
  )
  base_sys_calls <- parsed_data[base_fun_row_indexes - 1, ]
  base_sys_calls$function_name <- parsed_data[base_fun_row_indexes, ]$text

  pkg_fun_row_indexes <- which(
    (parsed_data$token == "expr") & (parsed_data$text %in% calls_to_flag[grepl("::", calls_to_flag)])
  )
  pkg_sys_calls <- parsed_data[pkg_fun_row_indexes - 1, ]
  pkg_sys_calls$function_name <- parsed_data[pkg_fun_row_indexes, ]$text

  rbind(base_sys_calls, pkg_sys_calls) %>%
    `row.names<-`(NULL)

}
