Project News
============

Copyright (c) 2013-2014, Gray Calhoun.

Permission is granted to copy, distribute and/or modify this document
under the terms of the GNU Free Documentation License, Version 1.3 or
any later version published by the Free Software Foundation; with no
Invariant Sections, no Front-Cover Texts, and no Back-Cover Texts. A
copy of the license is included in the file LICENSE.tex and is also
available online at <http://www.gnu.org/copyleft/fdl.html>.

Version 0.7.2
-------------
* Bugfix: successfully remove ligatures from monospaced text
* Convert most of the R code to Julia. (Everything except what's in
  the Bayesian material so far.)
* Decrease margins and increase font to reduce page count while
  keeping the text readable.
* Reorganize the material within each part and change the formatting
  from "parts" to "chapters" to decrease pagecount.
* Remove the AUTHORS.tex file (until there's another author).
* Moves the FDL to the end of the book (after the bibliography) to
  make it easier to avoid printing.

Version 0.7.1
-------------
* Updates chapter on multiple testing in part 4
* Bugfix for display of sectioning inside the copy of the license
* A few minor cosmetic tweaks
* Moves simulation *results* back out of the repository and explicitly
  adds the version information back to the repo
* Reduces the number of simulations used in the modeling example to
  reduce execution time
* Moves homework question on Gauss-Markov into the main text and adds
  a question about IV and nonparametric bounds
* Adds material on instrumental variables and 'predictive proxies'
* Polishes material on seemingly unrelated regressions

Version 0.7.0
=============
This release has a few interesting changes. The most visible:

* Changes the document class from tufte-book to report (the tufte-book
  class uses way too much italic for some pretty bad fonts).
  Selecting the 'final' option will use good fonts (Bitstream Charter
  and Adobe Source Code Pro) but the default is to use Computer Modern
  to reduce dependencies.

More exciting but less visible:

* The commit embeds the R code for figures and analysis inside the
  latex, then extracts and runs the code with knitr. This removes the
  need for external Sweave files.

  The generated pdfs and macros are included in the repo (which is not
  fantastic practice in general). Think of this as 'reproducible
  research' as an option, rather than by default. The upside is that

      pdflatex core_econometrics.tex

  should work "out of the box."  

Content changes:

* The regression modeling section has been rewritten and has material
  on the perils of model selection.

### Version 0.6.1

This commit rewrites the very short introduction for part 4, the
linear regression material. It is still very short, but now it's not
an outline.

Version 0.6.0
=============
This version does a lot internally, but not much in terms of the
content. The internal changes should make it easier for other
contributors to edit the files. The changes are:

* Switch the TeX engine from XeLaTeX to pdfLaTeX. This required
  rewriting all of the unicode symbols in ascii

* Consolidate all four parts of the book into a single document. This
  should make dissemination and global search/replace easier.

* Update the dependencies listed in the README

* Remove the .md extensions from textfiles where possible

* Speed up the makefile and make it more robust (by checking for
  latexmk)

Version 0.5.0
=============
Revises the asymptotics document to use sentences, paragraphs,
etc. (the usual) instead of a lecture-note stream of consciousness
format

Version 0.4.0
=============
* Renames the project to "Core Econometrics Notes"
* Starts to merge the two finite sample documents into a single doc
* Removes unnecessary local copy of the tufte-latex files

Version 0.3.4
-------------
This commit edits several parts of the inference material and makes
many internal changes that should make organizing and compiling the
files easier. It also renames the book to be *Core Econometrics
Textbook*.

Version 0.3.3
-------------
A patch: the previous commit broke compilation of the pdfs by
including the same source into several documents. This commit undoes
that problem by changing 'include' to 'input'. (This was a problem
when running parallel make).

Version 0.3.2
-------------
A housekeeping release, mostly:
* Adds the 'http://' prefix back to URLs so that they work in more pdf
  readers
* Updates the README file with more useful directions on compiling
  pdfs
* Adds placeholder files for version and citation information to
  prevent compilation errors
* Changes to include the author list and license in each pdf by
  default
* Renames the linear regression file

Version 0.3.1
-------------
This release marks a major rewrite of the "estimation" section,
changing it from a loose outline to something of a coherent document.
It also edits the Bayesian inference somewhat.

Version 0.3.0
=============
This release is a major rewrite of the probability section, which
changes it from a loose outline to sentences and paragraphs. The
release also reorganizes some material later in the book, but the
emphasis is on the probability material.

Version 0.2.5, hotfix release
-----------------------------
* Fixes a bug in the 'addcontentsline' command before the bibliography.

Version 0.2.4
-------------
* Changes the author to 'Gray Calhoun.' I'm not thrilled with this
  change, but I am the only author at the moment and I think having
  'EFLP' as the sole author is confusing. See inline comments for
  more details.

Version 0.2.3
-------------
* Hotfix release to remove redundant 'version' from bibtex entry

Version 0.2.2
-------------
* Generate bibtex entry for the textbook and add to the book's
  preamble automatically.
* Remove the ugly 'http://' from the front of URLs.

Version 0.2.1
-------------
* Converts LaTeX characters to Unicode where possible.
* Reduces TOC depth

Version 0.2.0
=============
* Removes most of the lecture-notes cruft from the documents;
  references to specific dates, exams, etc.
* Splits the authors list into a separate appendix
* Cleans up the README file
* Moves 'shared' documents into the main repo to make development
  faster and easier.

Version 0.1.4
-------------
* Add homework problems to each document
* Add table of set theory results that was a former handout
* Split off linear regression materials as a separate document
* Move licensing information to a standalone handout
* Split off versioning information from repo and generate document
  dates on-the-fly (type make ver; make -j).

Version 0.1.3, hotfix release
-----------------------------
Wildcard expansion in the pdf dependencies still isn't working, so
this patch switches back to list the individual pdfs explicitly. It's
not very exciting, but there aren't many pdf files so it shouldn't be
too much of a pain to deal with manually.

Version 0.1.2, hotfix release
-----------------------------
The Makefile wasn't handling automatic directory detection well. This
release puts the pdfs into a variable and uses the wildcard function
explictly in a double colon rule to solve the problem.

Version 0.1.1
-------------
* Moves preamble material to a shared repository and streamlines the
  code
* Fixes some issues in the appearance of the main texts
* Changes to a more informative title and author

Version 0.1.0
=============
* Move latex-class files to a versioned mirror of the tufte-latex
  project
* Move document preambles to a separate versioned subtree,
  latex-shared
* Group the Econometrics notes into several separate documents

Version 0.0.1
=============
Add LaTeX files for Gray Calhoun's old lecture notes; there's still a
lot of work that needs to be done to clean them up, but the project
actually has some content now.
