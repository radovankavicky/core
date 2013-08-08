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
latexdeps := tex/tufte-handout.cls tex/tufte-common.def \
  tex/common_preamble.tex VERSION.tex

dateinfo := "\\date{$(shell git show -s --date=short --format=%cd HEAD), \
  $(shell git describe --tags)}"
citeinfo := "@Book{eflp-core, \n\
  author =	{{EFLP}}, \n\
  title =	{Econometrics Core}, \n\
  publisher =	{Econometrics Free Library Project, \n\
		 \url{http://www.econometricslibrary.org}}, \n\
  year =	$(shell git show -s --date=short --format=%cd | head -c 4), \n\
  note =	{Version $(shell git describe --tags).}}}"

texts = probability.pdf finitesample.pdf linearregression.pdf asymptotics.pdf
support = LICENSE_standalone.pdf AUTHORS_standalone.pdf

all: $(texts) $(support) | ver

ver:	
	echo $(dateinfo) > VER.tmp
	if diff --brief VERSION.tex VER.tmp; then rm VER.tmp; \
	  else mv -f VER.tmp VERSION.tex; fi
	echo -e $(citeinfo) > CIT.tmp
	if diff --brief CITATION.bib CIT.tmp; then rm CIT.tmp; \
	  else mv -f CIT.tmp CITATION.bib; fi
VERSION.tex:
	echo $(dateinfo) > $@
CITATION.bib:
	echo -e $(citeinfo) > $@

probability.pdf: $(wildcard tex/probability/*.tex)
finitesample.pdf: $(wildcard tex/finitesample/*.tex)
asymptotics.pdf: $(wildcard tex/asymptotics/*.tex)
linearregression.pdf: $(wildcard tex/linearregression/*.tex)

$(texts): %.pdf: %.tex $(latexdeps) tex/references.bib CITATION.bib | ver
	$(latexmk) $(latexmkFLAGS) $< && $(latexmk) -c $<

$(support): %_standalone.pdf: %_standalone.tex %.tex $(latexdeps) | ver
	$(latexmk) $(latexmkFLAGS) -bibtex- $< && $(latexmk) -c $<

clean:
	rm -f $(foreach ext,$(crud),*.$(ext)) *~

burn: clean
	rm -f *.pdf *.dvi
