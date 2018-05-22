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
