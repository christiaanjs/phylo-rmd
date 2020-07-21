display_image_nextstrain <- function(path){
  knitr::hook_plot_html(path, knitr::opts_chunk$get())
}

#' @export
display_image <- function(path){
  config <- get_config()
  if(config$format == 'nextstrain'){
    display_image_nextstrain(path)
  } else {
    stop(sprintf("Input format %s not known", format)) # TODO: Implement non-Nextstrain formats
  }
}

#' @export
display_pdf <- function(path, temp_format="png"){
  output_path <- file.path(knitr::opts_chunk$get("fig.path"), paste0(basename(path), ".", temp_format))
  if(!file.exists(dirname(output_path)))
    dir.create(dirname(output_path))
  magick::image_read_pdf(path) %>%
    magick::image_convert(format=temp_format) %>%
    magick::image_write(output_path)
  display_image(output_path)
}
