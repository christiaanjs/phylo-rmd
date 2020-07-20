display_image_nextstrain <- function(path){
  knitr::hook_plot_html(path, knitr::opts_chunk$get())
}

#' @export
display_pdf <- function(path, temp_format="png"){
  config <- parent.frame()$.config
  output_path <- file.path(knitr::opts_chunk$get("fig.path"), paste0(basename(path), ".", temp_format))
  if(!file.exists(dirname(output_path)))
    dir.create(dirname(output_path))
  magick::image_read_pdf(path) %>%
    magick::image_convert(format=temp_format) %>%
    magick::image_write(output_path)
  if(config$format == 'nextstrain'){
    if(config$format == 'nextstrain'){
      display_image_nextstrain(output_path)
    } else {
      stop(sprintf("Input format %s not known", config$format)) # TODO: Implement non-Nextstrain formats
    }
  }
}
