# EXAMPLE PROJECT

+++ {"part": "abstract"}

This is just a demonstration of how a simple paper might look like. We write some text,
include a figure and a table.

+++

:::{raw} latex
\clearpage
:::




If you are using this template, please cite this item from the references:
{cite}`GaudeckerEconProjectTemplates`.

The data set for the template project is taken from the [stats4schools
website](https://www.stem.org.uk/resources/elibrary/resource/28452/large-datasets-stats4schools).
It contains data on smoking habits in the UK, with 1691 observations and 12 variables.

We consider only 4 of the 12 features for the prediction of the variable `smoking`:
`marital_status`, `highest_qualification`, `gender` and `age`. We model the dependence
using a Logistic model. All numerical features are included linearly, while categorical
features are expanded into dummy variables.

Figure :ref:`fig:predictions` illustrates the model of smoking propensity by marital
status over the lifetime. Table :ref:`tab:summary` contains the estimation results of
the linear Logistic regression.


:::{figure} public/smoking_by_marital_status.svg
:width: 85%
:label: fig:predictions

Model predictions of the smoking probability over the lifetime. Each
colored line represents a case where marital status is fixed to one of the
values present in the data set.
:::

:::{table} Estimation results of the linear Logistic regression.
:label: tab:summary
:align: center

|                                                         |    coef |   std err |      z |   P |   0.025 |   0.975 |
|:--------------------------------------------------------|--------:|----------:|-------:|--------:|---------:|---------:|
| Intercept                                               |  0.8786 |     0.255 |  3.443 |   0.001 |    0.378 |    1.379 |
| gender[T.Male]                                          |  0.1776 |     0.122 |  1.455 |   0.146 |   -0.062 |    0.417 |
| marital_status[T.Married]                               | -0.505  |     0.157 | -3.22  |   0.001 |   -0.812 |   -0.198 |
| marital_status[T.Separated]                             |  0.1102 |     0.292 |  0.378 |   0.706 |   -0.462 |    0.682 |
| marital_status[T.Divorced]                              |  0.4419 |     0.216 |  2.05  |   0.04  |    0.019 |    0.864 |
| marital_status[T.Widowed]                               |  0.097  |     0.269 |  0.36  |   0.719 |   -0.431 |    0.625 |
| highest_qualification[T.GCSE/CSE or GCSE/O Level]       | -0.1076 |     0.168 | -0.642 |   0.521 |   -0.436 |    0.221 |
| highest_qualification[T.ONC/BTEC]                       | -0.3583 |     0.292 | -1.228 |   0.22  |   -0.93  |    0.214 |
| highest_qualification[T.Other/Sub or Higher/Sub Degree] | -0.2999 |     0.192 | -1.56  |   0.119 |   -0.677 |    0.077 |
| highest_qualification[T.A Levels]                       | -0.9393 |     0.288 | -3.266 |   0.001 |   -1.503 |   -0.376 |
| highest_qualification[T.Degree]                         | -1.1184 |     0.218 | -5.139 |   0     |   -1.545 |   -0.692 |
| age                                                     | -0.0339 |     0.005 | -7.12  |   0     |   -0.043 |   -0.025 |

:::


:::{bibliography}
:::
