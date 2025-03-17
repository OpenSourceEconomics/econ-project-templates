(running_example)=

## Running example

`template_project` that will be installed with the templates is a simple empirical
project. Its abstract might read:

> This paper estimates the probability of smoking given age, marital status, and level
> of education. We use the stats4schools
> [Smoking dataset](https://www.stem.org.uk/resources/elibrary/resource/28452/large-datasets-stats4schools)
> and run a logistic regression. Results are presented in this paper; you may also want
> to consult the accompanying slides.

We can translate this into tasks our code needs to perform:

1. Clean the data
1. Estimate a logistic model
1. For each of the categorical variables, predict the smoking propensity over the
   lifetime
1. Create figures visualizing the results
1. Create tables with the results
1. Include the results in documents for dissemination (paper, presentation)

In these templates, we categorize these tasks into four groups:

- Data Management: task 1
- Analysis: tasks 2 & 3
- Final: tasks 4 & 5
- Documents: task 6

Naturally, different projects have different needs. E.g., for a simulation study, you
might want to discard the data management part. Doing so is trivial by just deleting the
respective directory (once you do not need the example any more). For most economics
research projects, however, the basic structure has proven to strike a good balance
between keeping related code in one place and dividing it up into chunks of manageable
size.

The remainder of this section provides much more detail on why we made these choices.
