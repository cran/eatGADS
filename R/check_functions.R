check_single_varName <- function(var, argumentName = "varName") {
  if(!is.character(var)) stop("'", argumentName, "' is not a character vector.")
  if(!length(var) == 1) stop("'", argumentName, "' must be of length 1.")
}


check_vars_in_GADSdat <- function(GADSdat, vars) {
  dup_vars <- vars[duplicated(vars)]
  if(length(dup_vars) > 0) stop("There are duplicates in 'vars': ",
                                paste(dup_vars, collapse = ", "))

  other_vars <- vars[!vars %in% namesGADS(GADSdat)]
  if(length(other_vars) > 0) stop("The following 'vars' are not variables in the GADSdat: ",
                                  paste(other_vars, collapse = ", "))
  return()
}
