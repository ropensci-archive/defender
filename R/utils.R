get_r_script_paths <- function(path = ".") {
  list.files(path = path, pattern = "[rR]$", recursive = TRUE, full.names = TRUE)
}
