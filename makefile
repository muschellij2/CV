fname=Modern_Resume
${fname}.pdf: ${fname}.tex education.tex professional.tex citations.bib
	if [ -e ${fname}.aux ]; \
	then \
	rm ${fname}.aux; \
	fi;
	pdflatex ${fname}
	bibtex ${fname}
	bibtex ${fname}1-blx
	pdflatex ${fname}
	pdflatex ${fname}
	cp ${fname}.pdf Current_CV.pdf
	open ${fname}.pdf
clean:
	rm ${fname}.pdf