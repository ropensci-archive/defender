#' Dangerous Imports in Namespace
#'
#' Character vector of all imports considered dangerous to be used with
#' \code{\link{check_namespace}}.
#'
#' @param additional_dangerous_imports character vector of user-defined
#'   dangerous imports
#'
#' @return character vector of all imports considered dangerous
#' @export
#'
#' @examples dangerous_imports()
dangerous_imports <- function(additional_dangerous_imports = character(0)) {
  c(pkgs_doing_system_calls(), "processx::run", additional_dangerous_imports) %>%
    unique()
}

base_system_calls <- function() {
  c("system", "system2")
}

pkgs_doing_system_calls <- function() {
  c("sys", "processx")
}

get_r_script_paths <- function(path = ".") {
  list.files(path = path, pattern = "[rR]$", recursive = TRUE, full.names = TRUE)
}

assert_path_exists <- function(path) {
  if(!dir.exists(path)) {
    stop(
      paste0("Path ", path, " not found, you may want to clone the repository first."),
      call. = FALSE
    )
  }
}

assert_is_package <- function(path) {
  if(!"DESCRIPTION" %in% list.files(path)) {
    stop(paste0(path, "is not a package directory"), call. = FALSE)
  }
}
