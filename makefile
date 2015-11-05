fname=Modern_CV
${fname}.pdf: ${fname}.tex education.tex \
	R_packages.Rnw \
	professional.tex \
	teaching.tex \
	academic_service.tex \
	teaching_assistant.tex \
	working_groups.tex \
	hackathons.tex \
	talks_and_presentations.tex \
	research_interests.tex \
	shinyapps.tex \
	convert_bibtex.R \
	submitted.bib \
	preparation.bib \
	citations.bib
	if [ -e ${fname}.aux ]; \
	then \
	rm ${fname}.aux; \
	fi;
	Rscript -e "library(knitr); knit('R_packages.Rnw')"
	Rscript convert_bibtex.R
	pdflatex ${fname}
	bibtex ${fname}
	bibtex ${fname}1-blx
	bibtex ${fname}2-blx
	if [ -e ${fname}3-blx.bbl ]; \
	then \
		bibtex ${fname}3-blx; \
	fi;	
	pdflatex ${fname}
	pdflatex ${fname}
	cp ${fname}.pdf Current_CV.pdf
	open ${fname}.pdf
clean:
	rm ${fname}.pdf
open:
	open ${fname}.pdf
edit:
	open ${fname}.tex	