# Copyright © 2013, authors of the "Econometrics Core" textbook; a
# complete list of authors is available in the file AUTHORS.tex.

# Permission is granted to copy, distribute and/or modify this
# document under the terms of the GNU Free Documentation License,
# Version 1.3 or any later version published by the Free Software
# Foundation; with no Invariant Sections, no Front-Cover Texts, and no
# Back-Cover Texts.  A copy of the license is included in the file
# LICENSE.tex and is also available online at
# <http://www.gnu.org/copyleft/fdl.html>.

.PHONY: all clean burn ver
.DELETE_ON_ERROR:

latexmk := latexmk
crud := .aux .log .out .toc .fdb_latexmk .fls
latexmkFLAGS := -xelatex -silent

# Note that there is not a dependence on LICENSE.tex; if you plan to
# disseminate these documents on their own, make sure to include the
# FDL as an appendix.
latexdeps := tex/tufte-handout.cls tex/tufte-common.def tex/common_preamble.tex

dateinfo := "\\date{$(shell git show -s --date=short --format=%cd HEAD), \
  version $(shell git describe --tags)}"

ybibtex = probability.pdf pointestimation.pdf
nbibtex = inference.pdf additionaltopics.pdf linearregression.pdf \
  LICENSE_standalone.pdf AUTHORS_standalone.pdf

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
LICENSE_standalone.pdf: LICENSE.tex
AUTHORS_standalone.pdf: AUTHORS.tex

$(nbibtex): %.pdf: %.tex $(latexdeps)
	$(latexmk) $(latexmkFLAGS) -bibtex- $< && $(latexmk) -c $<
$(ybibtex): %.pdf: %.tex $(latexdeps)
	$(latexmk) $(latexmkFLAGS) $< && $(latexmk) -c $<

clean:
	rm -f $(foreach ext,$(crud),*.$(ext)) *~

burn: clean
	rm -f *.pdf *.dvi