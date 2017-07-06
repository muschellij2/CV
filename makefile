fname=Modern_CV
compiler=xelatex
compiler_flags=-interaction=nonstopmode -halt-on-error
# compiler_flags=
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
	${compiler} ${fname}
	bibtex ${fname}
	bibtex ${fname}1-blx
	bibtex ${fname}2-blx
	if [ -e ${fname}3-blx.bbl ]; \
	then \
		bibtex ${fname}3-blx; \
	fi;	
	${compiler} ${fname}
	${compiler} ${fname}
	cp ${fname}.pdf Current_CV.pdf
	cp Current_CV.pdf ~/Dropbox/PhD_Thesis/
	open ${fname}.pdf

resume_fname=Modern_Resume
resume: ${resume_fname}.tex \
	education.tex \
	R_packages.Rnw \
	professional.tex \
	working_groups.tex \
	talks_and_presentations.tex \
	shinyapps.tex \
	convert_bibtex.R \
	submitted.bib \
	preparation.bib \
	citations.bib
	if [ -e ${resume_fname}.aux ]; \
	then \
	rm ${resume_fname}.aux; \
	fi;
	Rscript -e "library(knitr); knit('R_packages.Rnw')"
	Rscript convert_bibtex.R
	${compiler} ${resume_fname}
	bibtex ${resume_fname}
	bibtex ${resume_fname}1-blx
	bibtex ${resume_fname}2-blx
	if [ -e ${resume_fname}3-blx.bbl ]; \
	then \
		bibtex ${resume_fname}3-blx; \
	fi;	
	${compiler} ${resume_fname}
	${compiler} ${resume_fname}
	cp ${resume_fname}.pdf Current_Resume.pdf
	open ${resume_fname}.pdf	
clean:
	cp ${fname}.tex TMP.tex
	rm ${fname}*
	cp TMP.tex ${fname}.tex
	cp ${resume_fname}.tex TMP.tex
	rm ${resume_fname}*
	cp TMP.tex ${resume_fname}.tex	
open:
	open ${fname}.pdf
edit:
	open ${fname}.tex

travis: 
	${compiler} ${compiler_flags} ${fname}
	bibtex ${fname}
	bibtex ${fname}1-blx
	bibtex ${fname}2-blx
	if [ -e ${fname}3-blx.bbl ]; \
	then \
		bibtex ${fname}3-blx; \
	fi;	
	${compiler} ${compiler_flags} ${fname}
	${compiler} ${compiler_flags}  ${fname}
	cp ${fname}.pdf Current_CV.pdf	
	${compiler} ${compiler_flags} ${resume_fname}
	bibtex ${resume_fname}
	bibtex ${resume_fname}1-blx
	bibtex ${resume_fname}2-blx
	if [ -e ${resume_fname}3-blx.bbl ]; \
	then \
		bibtex ${resume_fname}3-blx; \
	fi;	
	${compiler} ${compiler_flags} ${resume_fname}
	${compiler} ${compiler_flags} ${resume_fname}
	cp ${resume_fname}.pdf Current_Resume.pdf
