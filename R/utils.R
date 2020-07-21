get_config <- function(){
  for(envir in sys.frames()){
    if(exists(".config", envir = envir)){
      return(envir$.config)
    }
  }
  stop(".config not found in any environment in call stack")
}
