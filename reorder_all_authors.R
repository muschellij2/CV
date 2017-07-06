library(gcite)
library(lubridate)
library(dplyr)
library(tidyr)
info = gcite_author_info("John Muschelli")


paper_df = info$paper_df
paper_df = mutate(paper_df,
	date = `publication date`)
paper_df = separate(paper_df,
	col = "date",
	into = c("year", "month", 
		"day"))
paper_df = mutate(paper_df,
	year = as.numeric(year)
	)
filter(paper_df,
	is.na(year)) %>% 
	select(authors, 
		`publication date`,
		year, volume,
		description, 
		publisher,
		issue)
paper_df$bib_auths = gsub(",", 
	" and", paper_df$authors)




