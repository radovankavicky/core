.PHONY: all clean burn ver
.DELETE_ON_ERROR:

latexmk := latexmk
crud := .aux .log .out .toc .fdb_latexmk .fls
latexmkFLAGS := -xelatex -silent

# Note that there is not a dependence on LICENSE.tex; if you plan to
# disseminate these documents on their own, make sure to include the
# FDL as an appendix.
latexdeps := tufte-latex/tufte-handout.cls tufte-latex/tufte-common.def \
  latex-shared/common-preamble.tex tex/local_preamble.tex

dateinfo := "\\date{$(shell git show -s --date=short --format=%cd HEAD), \
  version $(shell git describe --tags)}"

ybibtex = probability.pdf pointestimation.pdf
nbibtex = inference.pdf additionaltopics.pdf linearregression.pdf LICENSE_standalone.pdf

all: $(ybibtex) $(nbibtex) LICENSE_standalone.pdf

ver:
	echo $(dateinfo) > VER.tmp
	if diff --brief VERSION.tex VER.tmp; then rm VER.tmp; \
  else mv -f VER.tmp VERSION.tex; fi
VERSION.tex:
	echo $(dateinfo) > $@

probability.pdf: $(wildcard tex/probability/*.tex) VERSION.tex
pointestimation.pdf: $(wildcard tex/pointestimation/*.tex) VERSION.tex
inference.pdf: $(wildcard tex/inference/*.tex) VERSION.tex
additionaltopics.pdf: $(wildcard tex/additionaltopics/*.tex) VERSION.tex
inference.pdf: $(wildcard tex/inference/*.tex) VERSION.tex
LICENSE_standalone.pdf: LICENSE_standalone.tex LICENSE.tex

$(nbibtex): %.pdf: %.tex $(latexdeps)
	$(latexmk) $(latexmkFLAGS) -bibtex- $< && $(latexmk) -c $<
$(ybibtex): %.pdf: %.tex $(latexdeps)
	$(latexmk) $(latexmkFLAGS) $< && $(latexmk) -c $<

clean:
	rm -f $(foreach ext,$(crud),*.$(ext)) *~

burn: clean
	rm -f *.pdf *.dvi