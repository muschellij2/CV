rm(list = ls())
library(knitr)
library(bibtex)
library(stringr)
# bibfile = "R_packages.tex"
bibfile = "talks_and_presentations.tex"
x = readLines(bibfile)
n_total = 7
split_colon = FALSE

match_brackets = function(string){
  string = trimws(string)
  s = strsplit(string, '')[[1]]
  
  n = length(s)
  ind = rep(0, n)
  x = 0
  open_counter = 0
  indexer = 0
  i = 9
  for (i in 1:n){
    # print(s[i])
    already_open = open_counter > 0
    # print(indexer)
    # print(already_open)
    # print(open_counter)
    if (s[i] == "{"){
      open_counter = open_counter + 1
      if (!already_open){
        indexer = indexer + 1
      }
    }
    # print(indexer)
    
    if (s[i] == "}"){
      if (already_open){
        open_counter = open_counter - 1
      } 
    }    
    ind[i] = indexer
  }
  df = data.frame(s = s, ind = ind, stringsAsFactors = FALSE)
  ss = split(df$s, df$ind)
  ss = sapply(ss, function(x){
    x = paste(x, collapse = "")
    x = trimws(x)
    x = sub("^\\{", "", x)
    x = sub("\\}$", "", x)
    x
  })
  ss = ss[ !(ss %in% c("", "\\cventry"))]
  ss = c(ss, rep("", n_total - length(ss)))
  return(ss)
}

x = x[ !(x %in% "")]
split_x = t(sapply(x, match_brackets))
rownames(split_x) = NULL
colnames(split_x)[1:2] = c("Location", "Link")
split_x = data.frame(split_x, stringsAsFactors = FALSE)

links = strsplit(split_x$Link, "}")
https = sapply(links, `[`, 1)
https = gsub("\\\\href\\{", "", https)
https = trimws(https)
https[!grepl("http", https)] = NA

vals = sapply(links, function(x){
  if (length(x) > 1){
    x = paste(x[2:length(x)], collapse = "}")
  } 
  return(x)
})

vals = gsub("\\\\href\\{(.*)\\}\\{(.*)\\}", "[\\2](\\1)", vals)
vals = gsub("\\{|\\}", "", vals)

if (split_colon){
  vals = strsplit(vals, ":")
} 

vals = mapply(function(x, y){
  if (is.na(y)){
    return(paste0(x[1]))
  }
  x[1] = paste0("[", x[1],"](", y, ")")
  if (split_colon){
    x = paste0(x, collapse = ":")
  } 
  return(x)
}, vals, https)

if (split_colon){
  vals = paste0("* ", vals)
} else {
  vals = paste0("* ", split_x$Location, " - ", vals, " at ", split_x[,3])
}

tfile = tempfile(fileext = ".md")
writeLines(text = vals, con = tfile)

outfile = tempfile(fileext = ".html")
knit2html(input = tfile, output = outfile)

res = readLines(outfile)
cuts = grep("<(/|)body>", res)
res = res[(cuts[1]+1):(cuts[2]-1)]
res = res[ !(res %in% "") ]

# links = lapply(split_x$Link, match_brackets)
# rownames(links) = NULL
# string = x[1]
