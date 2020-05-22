resolve_nextstrain_tree <- function(config){
  config$tree_url# TODO: Improve this
}

nextstrain_arg_mapping <- list(color="c", display="d") # TODO: More arguments

add_display_argument <- function(tree_url, arg_name, display_args){
  urltools::param_set(tree_url, nextstrain_arg_mapping[[arg_name]], paste(display_args[[arg_name]], collapse = ","))
}

format_nextstrain_url <- function(tree_url, display_args){
  purrr::reduce(names(display_args), add_display_argument, display_args=display_args, .init=tree_url)
}

build_nextstrain_header <- function(text, config, display_args){
  tree_url <- resolve_nextstrain_tree(config)
  whisker::whisker.render("[{{text}}]({{{url}}})", list(text=text, url=format_nextstrain_url(tree_url, display_args)))
}

display_header <- function(text, config, display_args=NULL){
  if(config$format == 'nextstrain'){
    build_nextstrain_header(text, config)
  } else {
    stop(sprintf("Input format %s not known", config$format)) # TODO: Implement non-Nextstrain formats
  }
}
