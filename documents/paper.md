---
title: EXAMPLE PROJECT
author: JANE DOE
affiliation: EXAMPLE UNIVERSITY
email: janedoe[at]example-university.de
date: Preliminary -- please do not quote
bibliography: refs.bib
---

```{abstract}
Some abstract here.
```

# Introduction {#sec:introduction}

If you are using this template, please cite this item from the references:
{cite}`GaudeckerEconProjectTemplates`.

The data set for the template project is taken from
<https://www.stem.org.uk/resources/elibrary/resource/28452/large-datasets-stats4schools>.
It contains data on smoking habits in the UK, with 1691 observations and 12 variables.
We consider only 4 of the 12 features for the prediction of the variable
`smoking`: `marital_status`, `highest_qualification`,
`gender` and `age`. We model the dependence using a Logistic model. All
numerical features are included linearly, while categorical features are expanded into
dummy variables. Figures below illustrate the model predictions over the lifetime. You
will find one figure and one estimation summary table for each installed programming
language.

```{figure} ../figures/smoking_by_marital_status
:width: 85%
:name: fig:predictions

Model predictions of the smoking probability over the lifetime. Each
colored line represents a case where marital status is fixed to one of the
values present in the data set.
```

```{table} Estimation results of the linear Logistic regression.
:name: tab:summary

\input{../tables/estimation_results.tex}
```

:::{note}
The table above includes LaTeX content. You may need to convert the table to MyST format or use a different approach depending on your build system.
:::

```{bibliography}
```
