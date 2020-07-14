start_main_display <- function(){
  config <- parent.frame()$.config
  if(config$format == "nextstrain"){
    "```auspiceMainDisplayMarkdown"
  } else {
    ""
  }
}

end_main_display <- function(){
  config <- parent.frame()$.config
  if(config$format == "nextstrain"){
    "```"
  } else {
    ""
  }
}
