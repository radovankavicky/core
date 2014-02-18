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
julia := julia

parts := probability finitesample asymptotics regression
lsall = $(foreach dir,. tex $(parts),$(wildcard $(dir)/*$(1)))

all: core_econometrics.pdf
final: core_econometrics_final.pdf
	$(latexmk) -c $(<F)
	rm -f $(<:.pdf=.bbl)
core_econometrics_final.tex: core_econometrics.tex
	sed -e 's/\documentclass\[/\documentclass[final,/' $< > $@


# Execute the bootstrap code (if necessary)
figs = $(addprefix asymptotics/bootstrap_, \
                   u1.pdf u2.pdf u3.pdf ex1.pdf ex2.pdf ex3.pdf macros.tex) \
       $(addprefix regression/modeling_, \
                   fig1.pdf fig2.pdf macros.tex)

%_u1.pdf %_u2.pdf %_u3.pdf %_ex1.pdf %_ex2.pdf %_ex3.pdf %_macros.tex: %.jl
	$(julia) $<

%modeling_fig1.pdf %modeling_fig2.pdf %modeling_macros.tex: %modeling.jl
	$(julia) $<

.SECONDARY: $(figs)
.INTERMEDIATE: core_econometrics_final.tex

rep: $(figs)

# Check if latexmk is installed by trying to print its version number.
# If it is installed, use it.  Otherwise run latex and bibtex over and
# over again manually.
# I first saw this trick in the makefile for "Homotopy Type Theory:
# Univalent Foundations of Mathematics"
core_econometrics_final.pdf core_econometrics.pdf: %.pdf: %.tex \
  tex/references.bib $(call lsall,.tex) \
  asymptotics/bootstrap.jl regression/modeling.jl $(figs)
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
	rm -rf $(foreach dir, $(dirs), $(addprefix $(dir)/,$(crud)))

burn: clean
	rm -f $(addprefix core_econometrics.,pdf dvi bbl) $(figs)
