# Copyright (c) 2013, authors of "Core Econometrics;" a
# complete list of authors is available in the file AUTHORS.tex.

# Permission is granted to copy, distribute and/or modify this
# document under the terms of the GNU Free Documentation License,
# Version 1.3 or any later version published by the Free Software
# Foundation; with no Invariant Sections, no Front-Cover Texts, and no
# Back-Cover Texts.  A copy of the license is included in the file
# LICENSE.tex and is also available online at
# <http://www.gnu.org/copyleft/fdl.html>.

.PHONY: all clean burn tmp rep final
.DELETE_ON_ERROR:

SHELL=/bin/bash
latexmk := latexmk
latex := pdflatex
latexFLAGS := -pdf -silent
bibtex := bibtex
Rscript := Rscript
RscriptFLAGS := --vanilla

parts := probability finitesample asymptotics regression
lsall = $(foreach dir,. tex $(parts),$(wildcard $(dir)/*$(1)))

all: core_econometrics.pdf
final: core_econometrics_final.pdf
	$(latexmk) -c $(<F)
	rm -f $(<:.pdf=.bbl)
core_econometrics_final.tex: core_econometrics.tex
	sed -e 's/\documentclass\[/\documentclass[final,/' $< > $@


# Execute the bootstrap code (if necessary)
boots = $(addprefix asymptotics/,bootstrap_fig1.pdf \
  bootstrap_fig2.pdf bootstrap_macros.tex) \
  $(addprefix regression/,modeling_fig1.pdf \
    modeling_fig2.pdf modeling_macros.tex)
%bootstrap_fig1.pdf %bootstrap_fig2.pdf %bootstrap_macros.tex: %bootstrap.R
	$(Rscript) $(RscriptFLAGS) $<
%modeling_fig1.pdf %modeling_fig2.pdf %modeling_macros.tex: %modeling.R
	$(Rscript) $(RscriptFLAGS) $<

.SECONDARY: $(boots)
.INTERMEDIATE: asymptotics/bootstrap.R regression/modeling.R \
  core_econometrics_final.tex

knitr = $(Rscript) $(RscriptFLAGS) -e " require(knitr); \
  knit_patterns\$$set(list('chunk.begin' = \
                           '\\\\\\\\begin\\\\{lstlisting\\\\}.*',\
                           'chunk.end'='\\\\\\\\end\\\\{lstlisting\\\\}'));\
  purl('$(1)', output='$(2)')"
%.R: %.tex
	$(call knitr,$<,$@)

rep: $(boots)

# Check if latexmk is installed by trying to print its version number.
# If it is installed, use it.  Otherwise run latex and bibtex over and
# over again manually.
# I first saw this trick in the makefile for "Homotopy Type Theory:
# Univalent Foundations of Mathematics"
core_econometrics_final.pdf core_econometrics.pdf: %.pdf: %.tex \
  tex/references.bib $(filter-out VERSION.tex, $(call lsall,.tex)) $(boots)
	if $(latexmk) -v > /dev/null 2>&1; \
	then $(latexmk) $(latexFLAGS) $(<F); \
	else $(latex) $(latexFLAGS) $(<F) && \
	  $(latex) $(latexFLAGS) $(<F) && \
	  $(bibtex) $(<F:.tex=.aux) && \
	  $(latex) $(latexFLAGS) $(<F) && \
	  $(latex) $(latexFLAGS) $(<F) && \
	  $(latex) $(latexFLAGS) $(<F); \
	fi

dirs := . tmp tex $(parts) $(addprefix tmp/,$(parts))
crud := auto *~ *.aux *.out *.log *.fls *.fdb_latexmk *.brf *.idx \
  *.ilg *.ind *.toc
# Check if latexmk is installed by trying to print its version number.
# If it is, use it to clean up the extra latex files too.
clean:
	if $(latexmk) -v > /dev/null 2>&1; \
	then $(latexmk) -c core_econometrics; fi
	rm -rf $(foreach dir, $(dirs), $(addprefix $(dir)/,$(crud))) \
	  asymptotics/bootstrap.R regression/modeling.R

burn: clean
	rm -f $(addprefix core_econometrics.,pdf dvi bbl) \
	  VERSION.tex CITATION.bib
