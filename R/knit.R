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

render_abstract <- function(abstract, env){
  knitr::knit(text=abstract, envir=env)
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

render <- function(input, format="nextstrain", image_format="base64", abstract_env=NULL, ...){
  input_parsed <- parse_input(input)

  front_matter <- input_parsed$front_matter
  if(!is.null(abstract_env)){
    front_matter$abstract <- render_abstract(front_matter$abstract, abstract_env)
  }

  config <- list(
    dataset=get_dataset_base_url(front_matter$dataset),
    format=format
  )
  envir <- new.env()
  envir$.config <- config
  knitr::render_markdown()
  if(image_format == "base64"){
    knitr::opts_knit$set(upload.fun = knitr::image_uri)
    knitr::knit_hooks$set(plot = knitr::hook_plot_html)
  }

  knitr::knit(text=rebuild_input(front_matter, input_parsed$body), envir = envir, ...)
}
