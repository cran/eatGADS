
# 02) Prepare and extract data ---------------------------------------------------------
prepare_labels <- function(rawDat, checkVarNames, labeledStrings) {
  # 1) check and prepare variable names
  if(identical(checkVarNames, TRUE)) rawDat <- checkVarNames(rawDat)

  # 2a) dates and times to character
  rawDat <- times2character(rawDat = rawDat)

  # 2b) labeled or missing tagged character values to numeric
  rawDat <- char_valLabels2numeric(rawDat = rawDat, labeledStrings = labeledStrings)

  # 3) extract labels
  label_df <- extract_labels(rawDat = rawDat)

  # 3) depends on class! strip away labels from rawDat for spss, convert factors for R
  plainDat <- data.frame(lapply(rawDat, strip_attributes), stringsAsFactors = FALSE)

  # 4) All integer columns to numeric to avoid incompatabilities when writing to sav
  for(i in names(plainDat)) {
    if(is.integer(plainDat[[i]])) plainDat[, i] <- as.numeric(plainDat[, i])
  }
  if(is.integer(label_df$value)) label_df$value <- as.numeric(label_df$value)

  # output
  new_GADSdat(dat = plainDat, labels = label_df)
}


# 02.3) extract labels ---------------------------------------------------------
extract_labels <- function(rawDat) {
  attr_vec <- c("varName", "varLabel", "format", "display_width", "labeled", "value", "valLabel", "missings")

  label_df <- extract_variable_level(rawDat = rawDat)
  val_labels <- call_extract_values(rawDat = rawDat)

  # merge results and out with all names
  if(!is.null(val_labels)) label_df <- plyr::join(label_df, val_labels, by = "varName", type = "left", match = "all")
  add_vars <- setdiff(attr_vec, names(label_df))
  # preserve specific format of variables
  label_df[add_vars] <- NA_character_
  if(all(is.na(label_df$value))) label_df$value <- as.integer(label_df$value)
  if(all(is.na(label_df$display_width))) label_df$display_width <- as.integer(label_df$display_width)

  label_df[attr_vec]
}


# 02.3) strip away variable labels and factors ---------------------------------------------------------
strip_attributes <- function(vec) {
  attributes(vec) <- NULL
  vec
}



