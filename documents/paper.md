# EXAMPLE PROJECT

+++ {"part": "abstract"}

This is just a demonstration of how a simple paper might look like. We write some text,
include a figure and a table.

If you are using this template, please cite this item from the references:
{cite}`GaudeckerEconProjectTemplates`.

+++

```{raw} latex
\clearpage
```

The data set for the template project is taken from the
[stats4schools website](https://www.stem.org.uk/resources/elibrary/resource/28452/large-datasets-stats4schools).
It contains data on smoking habits in the UK, with 1691 observations and 12 variables.

We consider only 4 of the 12 features for the prediction of the variable `smoking`:
`marital_status`, `highest_qualification`, `gender` and `age`. We model the dependence
using a Logistic model. All numerical features are included linearly, while categorical
features are expanded into dummy variables.

Figure :ref:`fig:predictions` illustrates the model of smoking propensity by marital
status over the lifetime. Table :ref:`tab:summary` contains the estimation results of
the linear Logistic regression.

```{figure} public/smoking_by_marital_status.png
---
width: 85%
label: fig:predictions
---
Model predictions of the smoking probability over the lifetime. Each
colored line represents a case where marital status is fixed to one of the
values present in the data set.
```

````{table} Estimation results of the linear Logistic regression.
---
label: tab:summary
align: center
---
```{include} tables/estimation_results.md
```

````

```{bibliography}
```
