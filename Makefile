# Copyright (c) 2013, authors of "Core Econometrics;" a
# complete list of authors is available in the file AUTHORS.tex.

# Permission is granted to copy, distribute and/or modify this
# document under the terms of the GNU Free Documentation License,
# Version 1.3 or any later version published by the Free Software
# Foundation; with no Invariant Sections, no Front-Cover Texts, and no
# Back-Cover Texts.  A copy of the license is included in the file
# LICENSE.tex and is also available online at
# <http://www.gnu.org/copyleft/fdl.html>.

.PHONY: all clean burn ver tmp VERSION.tex CITATION.bib
.DELETE_ON_ERROR:

SHELL=/bin/bash
latexmk := latexmk
latex := pdflatex
latexFLAGS := -pdf -silent
bibtex := bibtex

sweave := R CMD Sweave
tmpdir := tmp

dateinfo := "\\date{$(shell git show -s --date=short --format=%cd HEAD), \
  $(shell git describe --tags)}"
citeinfo := "@Book{eflp-core, \n\
  author =	{Gray Calhoun}, \n\
  title =	{Core Econometrics}, \n\
  publisher =	{Econometrics Free Library Project, \n\
		 \url{http://www.econometricslibrary.org}}, \n\
  year =	{$(shell git show -s --date=short --format=%cd | head -c 4)}, \n\
  note =	{$(shell git describe --tags)}}"

parts := probability finitesample asymptotics regression

all: core_econometrics.pdf
ver: VERSION.tex CITATION.bib
VERSION.tex:
	echo $(dateinfo) > $@
CITATION.bib:
	echo -e $(citeinfo) > $@

asymptoticsSweave := $(wildcard asymptotics/*.Rnw)
tmp:
	mkdir -p $(addprefix $(tmpdir)/,$(parts))

# Check if latexmk is installed by trying to print its version number.
# If it is installed, use it.  Otherwise run latex and bibtex over and
# over again manually.
# I first saw this trick in the makefile for "Homotopy Type Theory:
# Univalent Foundations of Mathematics"
core_econometrics.pdf: core_econometrics.tex AUTHORS.tex LICENSE.tex \
  tex/preamble.tex tex/localmod.tex tex/references.bib \
  $(addprefix $(tmpdir)/,$(asymptoticsSweave:.Rnw=.tex)) \
  $(foreach dir, $(parts), $(wildcard $(dir)/*.tex)) \
  | VERSION.tex CITATION.bib
	if $(latexmk) -v > /dev/null 2>&1; \
	then $(latexmk) $(latexFLAGS) $(<F); \
	else $(latex) $(latexFLAGS) $(<F) && \
	  $(latex) $(latexFLAGS) $(<F) && \
	  $(bibtex) $(<F:.tex=.aux) && \
	  $(latex) $(latexFLAGS) $(<F) && \
	  $(latex) $(latexFLAGS) $(<F) && \
	  $(latex) $(latexFLAGS) $(<F); \
	fi

$(addprefix $(tmpdir)/,$(asymptoticsSweave:.Rnw=.tex)): \
  $(tmpdir)/%.tex: %.Rnw | tmp
	$(sweave) $(sweaveFLAGS) $< && mv $(@F) $(@D)/

dirs := . tmp tex $(parts) $(addprefix tmp/,$(parts))
crud := auto *~ *.aux *.out *.log *.fls *.fdb_latexmk *.brf *.idx \
  *.ilg *.ind *.toc
# Check if latexmk is installed by trying to print its version number.
# If it is, use it to clean up the extra latex files too.
clean:
	if $(latexmk) -v > /dev/null 2>&1; \
	then $(latexmk) -c core_econometrics; fi
	rm -rf $(foreach dir, $(dirs), $(addprefix $(dir)/,$(crud)))

burn: clean
	rm -f $(foreach dir, $(dirs), $(addprefix $(dir)/*., pdf bbl dvi)) \
	      $(addprefix $(tmpdir)/,$(asymptoticsSweave:.Rnw=.tex)) \
	      VERSION.tex CITATION.bib
	rm -rf tmp
