#' @export
start_main_display <- function(){
  config <- parent.frame()$.config
  if(config$format == "nextstrain"){
    "```auspiceMainDisplayMarkdown"
  } else {
    ""
  }
}

#' @export
end_main_display <- function(){
  config <- parent.frame()$.config
  if(config$format == "nextstrain"){
    "```"
  } else {
    ""
  }
}
