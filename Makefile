.PHONY: all clean burn
.DELETE_ON_ERROR:

latexmk := latexmk
tex = $(wildcard tex/*.tex)
pdf = $(addprefix pdf/,$(notdir $(tex:.tex=.pdf)))
crud := .aux .log .out .toc .fdb_latexmk .fls

latexmkFLAGS := -pdf -latex=xelatex -f -silent

all: $(pdf)

$(pdf): pdf/%.pdf: tex/%.tex
	mkdir -p pdf
	cd pdf && $(latexmk) $(latexmkFLAGS) ../$< && $(latexmk) -c ../$<

clean:
	rm -f $(foreach ext,$(crud),$(pdf:.pdf=$(ext)) $(tex:.tex=$(ext)))
	rm -f tex/*.dvi tex/*.pdf *~ tex/*~

burn: clean
	rm -f pdf/
