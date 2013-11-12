# Copyright © 2013, authors of "Core Econometrics Notes;" a
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

SHELL=/bin/bash
latexmk := latexmk
crud := .aux .log .out .toc .fdb_latexmk .fls
latexmkFLAGS := -xelatex -silent

latexdeps := common/preamble.tex AUTHORS.tex LICENSE.tex
docdeps := common/postamble.tex common/references.bib

# I'm still not sure the best way to do author information; I'm much
# more concerned in the long run about how different attributation
# styles would make someone more or less likely to contribute to an
# existing text or to license an existing draft.  For now, there's
# only one author, so I'll put myself as the author.  If someone else
# contributes any edits, etc., I'll change it to {Gray Calhoun and
# EFLP}.  If anyone wants to contribute a lot of original material and
# wants named authorship, please email the mailing list so we can
# discuss merging projects.

dateinfo := "\\date{$(shell git show -s --date=short --format=%cd HEAD), \
  version $(shell git describe --tags)}"
citeinfo := "@Book{eflp-core, \n\
  author =	{Gray Calhoun}, \n\
  title =	{Core Econometrics Notes}, \n\
  publisher =	{Econometrics Free Library Project, \n\
		 \url{http://www.econometricslibrary.org}}, \n\
  year =	{$(shell git show -s --date=short --format=%cd | head -c 4)}, \n\
  note =	{Version $(shell git describe --tags)}}"

texts = probability.pdf finitesample.pdf regression.pdf asymptotics.pdf
support = LICENSE_standalone.pdf AUTHORS_standalone.pdf

all: $(texts) $(support) bibliography_standalone.pdf

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

probability.pdf: $(wildcard probability/*.tex)
finitesample.pdf: $(wildcard finitesample/*.tex)
asymptotics.pdf: $(wildcard asymptotics/*.tex)
regression.pdf: $(wildcard regression/*.tex)

$(texts): %.pdf: %.tex $(latexdeps) $(docdeps) | ver
	$(latexmk) $(latexmkFLAGS) $< && $(latexmk) -c $<

$(support): %_standalone.pdf: %_standalone.tex %.tex $(latexdeps) | ver
	$(latexmk) $(latexmkFLAGS) -bibtex- $< && $(latexmk) -c $<

bibliography_standalone.pdf: %.pdf: %.tex \
  common/preamble.tex common/references.bib
	$(latexmk) $(latexmkFLAGS) $< && $(latexmk) -c $<

clean:
	rm -f $(foreach ext,$(crud),*.$(ext)) *~

burn: clean
	rm -f *.pdf *.dvi
