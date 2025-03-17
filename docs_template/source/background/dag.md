(dag)=

## Directed Acyclic Graphs

The way to specify dependencies between data, code and tasks to perform for a computer
is a directed acyclic graph. A graph is simply a set of nodes (files, in our case) and
edges that connect pairs of nodes (tasks to perform). Directed means that the order of
how we connect a pair of nodes matters, we thus add arrows to all edges. Acyclic means
that there are no directed cycles: When you traverse a graph in the direction of the
arrows, there may not be a way to end up at the same node again.

This is the dependency graph of template_project (open the image in a different window
to zoom in)

```{figure} ../figures/dag.png
---
width: 50em
---
```

The nodes have different shapes in order to distinguish tasks from files. The rectangles
denote targets or dependencies like figures, data sets or stored models. The hexagons
denote task files. Even in this simple template project we already see that the
dependency structure can be complex.

In a first run, all targets have to be generated, of course. In later runs, a target
only needs to be re-generated if one of its direct **dependencies** changes. E.g. when
we alter `documents/presentation.tex` (mid-right) we need to rebuild only the
presentation pdf file. If we alter `rrt/data_management/data_info_template.yaml`
(top-right), however, we need to rebuild everything. Note, that the only important thing
at this point is to understand the general idea.

Of course this is overkill for a simple example -- we could easily keep the code closer
together than this. But such a strategy does not scale to serious papers with many
different specifications. As a case in point, consider the DAG for an early version of
{cite}`Gaudecker2015`:

```{figure} ../figures/pfefficiency.jpg
---
width: 50em
---
```

Do you want to keep those dependencies in your head? Or would it be useful to specify
them once and for all in order to have more time for thinking about research? The next
section shows you how to do that.
