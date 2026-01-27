# Econ Project Templates: Modern, Reproducible Research in Economics

(introduction)=

## Why Reproducibility Matters

We are in the midst of a reproducibility crisis in the social sciences. Journals like
the *AER* now mandate rigorous data and code availability policies, and the days of
"trust me, I ran the regression" are over. But beyond compliance, reproducibility is
about **your peace of mind**. It means knowing that if you find a mistake in your raw
data three days before submission, you can re-run your entire project—tables, figures,
and paper—with a single command. It means your future self (and your co-authors) can
understand and run your code on a new machine without spending a week fighting
dependency hell.

## The Solution

This template is a "batteries-included" starting point for professional economic
research. It replaces fragile, manual workflows with a robust, automated pipeline. By
combining **Pixi** for hermetic environment management, **Pytask** for workflow
automation, and **MyST** for integrated writing, we provide a structure where code and
text live in harmony. You don't build an environment; you define it. You don't "paste"
results into LaTeX; you generate a dynamic document. This project gives you the tooling
of a senior software engineer with an interface designed for economists.

______________________________________________________________________

## Navigating this Documentation

We have structured our documentation to get you working immediately, regardless of your
experience level.

- **{ref}`getting_started` (Start Here):** This is the "magic" section. We show you how
  to install one tool (`pixi`) and run one command to build the entire paper and
  presentation. **Read this first** to verify your system is ready.
- **{ref}`background` (Under the Hood):** For those who want to understand the design
  choices and architecture. Here we explain *why* we use Directed Acyclic Graphs (DAGs),
  how the workflow is structured, and the philosophy behind our folder structure.
- **{ref}`guides_explanations` (How-to Guides):** For the researcher in the middle of a
  project. When you need to know "How do I add a new Python package?" or "How do I start
  from scratch?", look here. These are short, recipe-style answers.
- **{ref}`programming_languages`:** While the example focuses on Python, we explain how
  to integrate other languages like R, Julia, or Stata.
- **{ref}`development`:** Information on how to contribute to this project.
