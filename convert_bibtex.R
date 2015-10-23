library(bibtex)
library(stringr)
bibfile = "citations.bib"
x = read.bib(bibfile)

x$hanley2012mistie = NULL

titles = tolower(sapply(x, function(xx){
  auth = as.character(str_trim(xx$title[1]))
}))

drop_abstracts = TRUE
if ( drop_abstracts ) {
  drop_titles = titles[grep("^abstract ", titles)]
  names(drop_titles) = NULL
  print(drop_titles)
  if (length(drop_titles) > 0){
    x = x[-grep("^abstract ", titles)]
  }
}


yrs = as.numeric(sapply(x, function(xx){
	xx$year
}))

auths = tolower(sapply(x, function(xx){
	auth = as.character(xx$author[1])
	auth = strsplit(auth, " ")[[1]]
	auth = auth[length(auth)]
}))



me.first = grepl("muschelli", auths)

# ord = order(-me.first, -yrs, auths)
ord = order(-yrs, -me.first, auths)
x = x[ord]

first = sort(me.first, decreasing=TRUE)

x.me = x[first]
x.other = x[!first]

x = unique(x)

pubs = tolower(sapply(x, function(xx){
  as.character(xx$publisher[1])
}))
r_pubs = grep("^r foundation (for |)statistical computing", pubs)

for (ipub in seq_along(r_pubs)) {
  ind = r_pubs[ipub]
  xx = x[ind]
  xx$publisher = "R Foundation for Statistical Computing"
  x[ind] = xx
}

# remove_orgs
# n_orgs = sapply(x, function(xx){
#   org = as.character(xx$organization[1])
#   ss = strsplit(org, ",")
#   if (length(ss) > 0) {
#    return(length(ss[[1]]))
#   }
#   return(0)
# })

for (ind in seq_along(x)) {
  xx = x[ind]
  xx$organization = NULL
  x[ind] = xx
}


write.bib(entry = x, file = bibfile)
# outfile = gsub("[.]bib", "_fixed.bib", bibfile)
# write.bib(entry=x, file= outfile)

# x = readLines(outfile)
# x = gsub("Muschelli", "\\\\textbf{Muschelli}", x)
# writeLines(x, con=outfile)
