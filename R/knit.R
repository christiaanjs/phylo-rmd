parse_front_matter <- function(front_matter){
  front_matter <- front_matter[2:(length(front_matter) - 1)]
  front_matter <- rmarkdown:::one_string(front_matter)
  rmarkdown:::validate_front_matter(front_matter)
  rmarkdown:::yaml_load(front_matter)
}

parse_input <- function(input){
  input_lines <- readLines(input)
  partitions <- rmarkdown:::partition_yaml_front_matter(input_lines)
  list(
    front_matter=parse_front_matter(partitions$front_matter),
    body=partitions$body
  )
}

get_dataset_base_url <- function(dataset){
  url <- urltools::url_parse(dataset)
  url$parameter <- NA
  urltools::url_compose(url)
}

render_front_matter_field <- function(field, env){
  knitr::knit(text=field, envir=env)
}

rebuild_input <- function(front_matter, body){
  paste(
    '---',
    yaml::as.yaml(front_matter),
    '---',
    rmarkdown:::one_string(body),
    sep = "\n"
  )
}

#' @export
render <- function(
    input,
    format="nextstrain",
    image_format="base64",
    front_matter_render_fields=NULL,
    front_matter_env=NULL,
    ...
  ){
  input_parsed <- parse_input(input)

  front_matter <- input_parsed$front_matter

  for(field in front_matter_render_fields){
    front_matter[[field]] <- render_front_matter_field(front_matter[[field]], front_matter_env)
  }

  config <- list(
    dataset=get_dataset_base_url(front_matter$dataset),
    format=format
  )
  envir <- new.env()
  envir$.config <- config
  knitr::render_markdown()

  knitr::opts_chunk$set(echo = FALSE)
  knitr::opts_chunk$set(message = FALSE)


  if(image_format == "base64"){
    knitr::opts_knit$set(upload.fun = knitr::image_uri)
    knitr::knit_hooks$set(plot = knitr::hook_plot_html)
  }

  knitr::knit(text=rebuild_input(front_matter, input_parsed$body), envir = envir, ...)
}
