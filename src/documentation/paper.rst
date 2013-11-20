.. _paper:

Research paper / presentations
===============================

Purpose of the different files (rename them to your liking):

    * :file:`research_paper.tex` contains the actual paper.
    * :file:`research_pres_90min.tex` contains a full-length seminar presentation
    * :file:`research_pres_30min.tex` contains a typical conference presentation.
    * :file:`all_tables.tex` / :file:`all_figures.tex` are containers for additional tables / figures and results for internal review (robustness checks and the like), not to be published. I often auto-generate these and fill them up via ant_glob(**) patterns. They could serve as the starting point for a web appendix, but in my experience they are usually even more exhaustive than that.
    * :file:`formulas` contains short files with the LaTeX formulas -- put these into a library for re-use in different document types.
