Project News
============

Copyright © 2013, authors of the "Econometrics Core" textbook; a
complete list of authors is available in the file AUTHORS.tex.

Permission is granted to copy, distribute and/or modify this document
under the terms of the GNU Free Documentation License, Version 1.3 or
any later version published by the Free Software Foundation; with no
Invariant Sections, no Front-Cover Texts, and no Back-Cover Texts.  A
copy of the license is included in the file LICENSE.tex and is also
available online at <http://www.gnu.org/copyleft/fdl.html>.

Version 0.2.0
-------------
* Removes most of the lecture-notes cruft from the documents;
  references to specific dates, exams, etc.
* Splits the authors list into a separate appendix
* Cleans up the README file
* Moves 'shared' documents into the main repo to make development
  faster and easier.

### Version 0.1.4
* Add homework problems to each document
* Add table of set theory results that was a former handout
* Split off linear regression materials as a separate document
* Move licensing information to a standalone handout
* Split off versioning information from repo and generate document
  dates on-the-fly (type make ver; make -j).

### Version 0.1.3, hotfix release
Wildcard expansion in the pdf dependencies still isn't working, so
this patch switches back to list the individual pdfs explicitly.  It's
not very exciting, but there aren't many pdf files so it shouldn't be
too much of a pain to deal with manually.

### Version 0.1.2, hotfix release
The Makefile wasn't handling automatic directory detection well.  This
release puts the pdfs into a variable and uses the wildcard function
explictly in a double colon rule to solve the problem.

### Version 0.1.1
* Moves preamble material to a shared repository and streamlines the
  code
* Fixes some issues in the appearance of the main texts
* Changes to a more informative title and author

Version 0.1.0
-------------
* Move latex-class files to a versioned mirror of the tufte-latex
  project
* Move document preambles to a separate versioned subtree,
  latex-shared
* Group the Econometrics notes into several separate documents

### Version 0.0.1
Add LaTeX files for Gray Calhoun's old lecture notes; there's still a
lot of work that needs to be done to clean them up, but the project
actually has some content now.
