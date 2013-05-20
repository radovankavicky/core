.PHONY: all clean burn
.DELETE_ON_ERROR:

latexmk := latexmk
crud := .aux .log .out .toc .fdb_latexmk .fls
latexmkFLAGS := -pdf -pdflatex=xelatex -silent -bibtex-
latexdeps := tufte-latex/tufte-handout.cls tufte-latex/tufte-common.def \
  latex-shared/common-preamble.tex LICENSE.tex tex/local_preamble.tex

all: probability.pdf pointestimation.pdf inference.pdf additionaltopics.pdf

probability.pdf: $(wildcard tex/probability/*.tex)
pointestimation.pdf: $(wildcard tex/pointestimation/*.tex)
inference.pdf: $(wildcard tex/inference/*.tex)
additionaltopics.pdf: $(wildcard tex/additionaltopics/*.tex)

%.pdf: %.tex $(latexdeps)
	$(latexmk) $(latexmkFLAGS) $< && $(latexmk) -c $<

clean:
	rm -f $(foreach ext,$(crud),*.$(ext)) *~

burn: clean
	rm -f *.pdf *.dvi