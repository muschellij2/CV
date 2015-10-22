fname=Modern_CV
${fname}.pdf: ${fname}.tex education.tex \
	R_packages.tex professional.tex \
	teaching.tex \
	academic_service.tex \
	teaching_assistant.tex \
	hackathons.tex \
	talks_and_presentations.tex \
	research_interests.tex \
	shinyapps.tex \
	convert_bibtex.R \
	preparation.bib \
	citations.bib
	if [ -e ${fname}.aux ]; \
	then \
	rm ${fname}.aux; \
	fi;
	Rscript convert_bibtex.R
	pdflatex ${fname}
	bibtex ${fname}
	bibtex ${fname}1-blx
	bibtex ${fname}2-blx
	pdflatex ${fname}
	pdflatex ${fname}
	cp ${fname}.pdf Current_CV.pdf
	open ${fname}.pdf
clean:
	rm ${fname}.pdf