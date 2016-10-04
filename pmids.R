rm(list=ls())
library(rentrez)
# library(XML)
library(bibtex)
library(plyr)
library(dplyr)
library(xml2)
setwd("~/Dropbox/CV")

bib = read.bib("citations.bib")
titles = sapply(bib, function(x) {
    x$title
})

ids = llply(titles,
    function(x) { 
        # xx = x
        # xx = strsplit(xx, " ")[[1]]
        # xx = paste(xx, collapse = "+")
        entrez_search(db="pubmed", 
            term = x) 
    }, .progress = "text")

iids = llply(ids, function(x) {
    x = x$ids
    if (length(x) == 0) {
        x = NA
    }
    x    
})

# first_ids = llply(ids, function(x) {
#     x = first(x$ids)
    # if (is.null(x)) {
    #     x = NA
    # }
    # x
# })

pm_info = llply(iids, 
    function(x) {
        if (all(is.na(x))) {
            return(NA)
        }
        r = entrez_fetch(db = "pubmed",
            id = x, 
            rettype = "xml",
            parsed = FALSE)
        return(r)
    }, .progress = "text")

pm2 = llply(pm_info,
    read_xml
    )


got_musch = llply(pm_info, function(x) {
    if (inherits(x, "logical")) {
        if (is.na(x)) {
            return(NA)
        }
    }
    nodes = getNodeSet(x, 
        "//PubmedArticle")
    ids = xpathSApply(x, 
        "//MedlineCitation/PMID")
    ids = sapply(ids, xmlValue)
    names(nodes) = ids
    ids = 
    vals = xpathApply(x, 
        "//AuthorList//Author", //LastName", 
        xmlValue)
    vals = tolower(vals)
    vals = trimws(vals)
    any(grepl("muschelli", vals))
})

