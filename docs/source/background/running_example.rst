The example project that will be installed with the templates is a simple empirical
project. Its abstract might read:

    This paper estimates the probability of smoking given age, marital status, and level
    of education. We use the XXX data and run a logistic regression. Results are
    presented in this paper; you may also want to consult the accompanying slides.

This means that  all these parts of the pipeline, these tasks, to build the project we
need to perform the following steps:

1.  Download the data
2.  Clean the data
3.  Estimate a logistic model
4.  Predict over the lifetime (for each of the categorical variables)
5.  Visualize the results (for each of the categorical variables)
6.  Include the results in documents for dissemination

We categorize these tasks into

* Data Management: tasks 1 & 2
* Analysis: tasks 3 & 4
* Final: task 5
* Paper: task 6

Naturally, different projects have different needs. E.g., for a simulation study, you
might want to discard the data management part. Doing so is trivial by just deleting the
respective directory (once you do not need the example anymore). For most economics
research projects, however, the basic structure has proven to strike a good balance
between keeping related code in one place and dividing it up into chunks of manageable
size.
