Project News
============

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