
# 02.2.a) attributes on variable level ---------------------------------------------------
extract_variable_level <- function(rawDat) {
  UseMethod("extract_variable_level")
}

#'@export
extract_variable_level.savDat<- function(rawDat) {
  # check for unknown attributes (mostly to secure against changes in haven)
  all_attr <- unlist(lapply(rawDat, function(var) names(attributes(var))))
  unknown_attr <- all_attr[!all_attr %in% c("label", "format.spss", "display_width", "class", "tzone", "labels", "na_range", "na_values",
                                            "format.stata")]
  if(length(unknown_attr) > 0) stop("Unknown attributes exported from haven:", unknown_attr, ". Please contact package author.")

  varClass <- unlist(lapply(rawDat, extract_attribute, attr_name = "class"))
  #if(any(c("difftime", "Date") %in% varClass)) browser()
  varLabels <- unlist(lapply(rawDat, extract_attribute, attr_name = "label"))
  varFormat <- unlist(lapply(rawDat, extract_attribute, attr_name = "format.spss"))
  varWidth <- unlist(lapply(rawDat, extract_attribute, attr_name = "display_width", NA_type = NA_real_))
  if(any(grepl("^labelled_spss", varClass))) {
    warning("You are using an old version of haven. Please download the current version from CRAN. \n Correct importing from SPSS-files can not be guaranteed.", call. = FALSE)
  }
  # internal convention: all special labeled haven classes are internally represented as "yes" in variable "labeled", all other as "no"
  varClass[!is.na(varClass)] <- "yes"
  varClass[is.na(varClass)] <- "no"
  varLabel_df <- data.frame(names(rawDat), varLabels, varFormat, varWidth, varClass, stringsAsFactors = FALSE)
  # names
  names(varLabel_df) <- c("varName", "varLabel", "format", "display_width", "labeled")
  rownames(varLabel_df) <- NULL

  #issue_havenBUG_warning(varLabel_df)

  varLabel_df
}

#'@export
extract_variable_level.data.frame <- function(rawDat) {
  varClass <- unlist(lapply(rawDat, extract_attribute, attr_name = "class"))
  varLabels <- unlist(lapply(rawDat, extract_attribute, attr_name = "label"))
  ## class labelled currently only partially supported, issue warning for value labels
  no_of_value_labels_labelled <- sum(!is.na(unlist(lapply(rawDat, extract_attribute, attr_name = "label"))))
  if(no_of_value_labels_labelled > 0) warning("Value labels are given probably in class labelled and are not imported!")
  varClass[!is.na(varClass)] <- "yes"
  varClass[is.na(varClass)] <- "no"
  data.frame(varName = names(rawDat), varLabel = varLabels, labeled = varClass, stringsAsFactors = FALSE)
}


# extract attributes and produce NA for not given attributes
extract_attribute <- function(var, attr_name, NA_type = NA_character_) {
  out <- attr(var, attr_name, exact = TRUE)
  if(is.null(out)) out <- NA_type
  if(length(out) > 1) out <- paste(out, collapse = ", ")
  out
}


# 02.2.b) attributes on value level ---------------------------------------------------
# all variables, for SPSS and R
call_extract_values <- function(rawDat) {
  # extract labels into one long format data frame
  valueList <- Map(extract_value_level, var = rawDat, varName = names(rawDat))
  valLabel_df <- do.call(rbind, valueList)
  rownames(valLabel_df) <- NULL
  valLabel_df
}

extract_value_level <- function(var, varName) {
  UseMethod("extract_value_level")
}

#'@export
extract_value_level.default <- function(var, varName) {
  NULL
}

# single variable for R (factors!)
#'@export
extract_value_level.factor <- function(var, varName) {
  if(length(levels(var)) == 0) return(NULL)
  df <- data.frame(varName = rep(varName, length(levels(var))),
                   value = seq_along(levels(var)),
                   valLabel = levels(var),
                   missings = "valid",
                   stringsAsFactors = FALSE)
  ### insert missing extraction, add col like in spss function
  rownames(df) <- NULL
  df
}

# single variable for SPSS
#'@export
extract_value_level.haven_labelled <- function(var, varName) {
  # check if there are value labels or missing tags
  if(is.null(attributes(var)$labels) && is.null(attributes(var)$na_value) && is.null(attributes(var)$na_range)) return(NULL)
  values <- attr(var, "labels")
  valLabels <- attr(attr(var, "labels"), "names")
  # proper initialization if no value labels and just missing tags are present
  if(is.null(values)) {
    values <- numeric()
    valLabels <- character()
  }

  # transform values to numeric if possible, leave characters as is (rest has been taken care of in char_valLabels2numeric.R)
  values <- suppressWarnings(eatTools::asNumericIfPossible(x = values, maintain.factor.scores = TRUE,
                                                           force.string = FALSE, transform.factors = TRUE))

  # extract value labels and return as long format df
  df <- data.frame(varName = rep(varName, length(values)),
                   value = values,
                   valLabel = valLabels,
                   stringsAsFactors = FALSE)

  # extract missings and add as extra label
  df <- extract_Miss_SPSS(var = var, varName = varName, label_df = df)

  # deal with duplicate values in character variables caused by decimals
  if(is.character(var)) {
    df <- remove_duplicate_value_rows(df, varName)
  }

  rownames(df) <- NULL
  df
}

remove_duplicate_value_rows <- function(df, varName) {
  values_with_dups <- unique(df$value[duplicated(df$value)])
  # tbd: if all equal, select first row
  # otherwise select first row and raise warning? should this be parameterized via an argument?
  if(length(values_with_dups) > 0) {
    warning("Duplicate value labels or missing tags are dropped for variable '", varName,
            "'. Only the respective first value label or missing tag is preserved and zero-decimals are dropped.")
    for(i in values_with_dups){
      dup_rows <- which(df$value == i)
      rows_to_remove <- dup_rows[dup_rows != min(dup_rows)]
      df <- df[-rows_to_remove, ]
    }
  }
  df
}

# emergency function for downwards compatability with older haven versions
#'@export
extract_value_level.labelled_spss <- function(var, varName) {
  class(var) <- "haven_labelled"
  extract_value_level(var = var, varName = varName)
}

# extract if label is label for missing values
extract_Miss_SPSS <- function(var, varName, label_df) {
  na_range <- attr(var, "na_range")
  na_value <- attr(var, "na_value")

  # which values in na_range exist? (empirically and/or have label)
  suppressWarnings(existing_values <- as.numeric(names(table(var))))
  existing_values <- unique(c(existing_values, label_df$value))
  na_range_used <- existing_values[existing_values <= na_range[2] & existing_values >= na_range[1]]

  values <- c(na_value, na_range_used)
  values <- checkValues_havenBug(values, varName = varName)
  # transform values to numeric if possible, leave characters as is (rest is taking care of in char_valLabels2numeric.R)
  if(!is.null(values)) {
    values <- suppressWarnings(eatTools::asNumericIfPossible(x = values, maintain.factor.scores = TRUE,
                                                             force.string = FALSE, transform.factors = TRUE))
  }

  # add missing code for existing values
  label_df[, "missings"] <- ifelse(label_df$value %in% values, "miss", "valid")

  # add values with missing codes if necessary (note: if values are na_range, these values will not be added!!!! this behavior could be changed in the future)
  add_values <- values[!values %in% label_df$value]
  if(length(add_values) >= 1) {
    add_df <- data.frame(varName = varName, value = add_values, missings = "miss", stringsAsFactors = FALSE)
    label_df <- plyr::join(label_df, add_df, by = c("varName", "value"), type = "full", match = "all")
  }

  label_df
}




# haven bug precautions     ---------------------------------------------------
issue_havenBUG_warning <- function(varLabel_df) {
  split_string <- strsplit(varLabel_df$format, "\\.")
  split_string <- unlist(lapply(split_string, function(x) x[[1]]))
  spss_length <- as.numeric(eatTools::removeNonNumeric(split_string))
  bug_vars <- grepl("^A", varLabel_df$format) & varLabel_df$labeled == "yes"
  # for A9 only missing labels are affected, from A10 all labels are affected!
  if(any(bug_vars)) {
    warning("Due to a bug in haven, missing codes of character variables can be lost. Checking missing codes via checkMissings is recommended. The following variables might be affected: \n ", paste(varLabel_df[bug_vars, "varName"], collapse = ", "), call. = FALSE)
  }
  return(NULL)
}

checkValues_havenBug <- function(values, varName) {
  corrupted_values <- values[values %in% "" | is.na(values)]
  if(length(corrupted_values) > 0) {
    warning("Corrupted missing values haven been found in variable ", varName,
            " and are dropped. Contact package author for further information. The affected values are:", corrupted_values, call. = FALSE)
    values <- values[!values %in% corrupted_values]
  }
  values
}
