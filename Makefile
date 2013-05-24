.PHONY: all clean burn ver
.DELETE_ON_ERROR:

latexmk := latexmk
crud := .aux .log .out .toc .fdb_latexmk .fls
latexmkFLAGS := -xelatex -silent
latexdeps := tufte-latex/tufte-handout.cls tufte-latex/tufte-common.def \
  latex-shared/common-preamble.tex LICENSE.tex tex/local_preamble.tex \
  VERSION.tex

dateinfo := "\\date{$(shell git show -s --date=short --format=%cd HEAD), \
  version $(shell git describe --tags)}"

ybibtex = probability.pdf pointestimation.pdf
nbibtex = inference.pdf additionaltopics.pdf linearregression.pdf

all: $(ybibtex) $(nbibtex)

ver:
	echo $(dateinfo) > VER.tmp
	if diff --brief VERSION.tex VER.tmp; then rm VER.tmp; \
  else mv -f VER.tmp VERSION.tex; fi
VERSION.tex:
	echo $(dateinfo) > $@

$(nbibtex): %.pdf: %.tex $(wildcard tex/%/*.tex) $(latexdeps)
	$(latexmk) $(latexmkFLAGS) -bibtex- $< && $(latexmk) -c $<
$(ybibtex): %.pdf: %.tex $(wildcard tex/%/*.tex) $(latexdeps)
	$(latexmk) $(latexmkFLAGS) $< && $(latexmk) -c $<

clean:
	rm -f $(foreach ext,$(crud),*.$(ext)) *~

burn: clean
	rm -f *.pdf *.dvi