.PHONY: all clean burn
.DELETE_ON_ERROR:

latexmk := latexmk
crud := .aux .log .out .toc .fdb_latexmk .fls
latexmkFLAGS := -xelatex -silent
latexdeps := tufte-latex/tufte-handout.cls tufte-latex/tufte-common.def \
  latex-shared/common-preamble.tex LICENSE.tex tex/local_preamble.tex

ybibtex = probability.pdf
nbibtex = pointestimation.pdf inference.pdf additionaltopics.pdf

all: $(ybibtex) $(nbibtex)

$(nbibtex): %.pdf: %.tex $(wildcard tex/%/*.tex) $(latexdeps)
	$(latexmk) $(latexmkFLAGS) -bibtex- $< && $(latexmk) -c $<
$(ybibtex): %.pdf: %.tex $(wildcard tex/%/*.tex) $(latexdeps)
	$(latexmk) $(latexmkFLAGS) $< && $(latexmk) -c $<

clean:
	rm -f $(foreach ext,$(crud),*.$(ext)) *~

burn: clean
	rm -f *.pdf *.dvi