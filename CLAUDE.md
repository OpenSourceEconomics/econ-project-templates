# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in
this repository.

## Project Overview

This is "Templates for Reproducible Research Projects in Economics" - a template project
demonstrating best practices for reproducible computational research. It uses pytask for
workflow orchestration and Pixi for environment management.

## Common Commands

```bash
# Run the complete computational pipeline (data → analysis → figures/tables → documents)
pixi run pytask

# Run tests
pixi run pytest

# Run a single test file or specific test
pixi run pytest tests/test_template.py
pixi run pytest tests/analysis/test_predict_template.py::test_predict_prob_by_model

# Run pre-commit hooks on all files
pixi run prek

# Build documentation (Jupyter Book 2.0)
pixi run -e docs docs

# View documentation, paper, and presentation interactively
pixi run -e docs view-docs   # Project documentation
pixi run view-paper          # Paper (HTML with live reload)
pixi run view-pres           # Presentation (Slidev with live reload)

# Regenerate the DAG visualization
pixi run -e docs recreate-dag

# Install Node.js dependencies (for Slidev presentations)
pixi run npm install
```

## Architecture

### Workflow Pipeline (pytask)

The project follows a task-based pipeline where each `task_*.py` file defines
computational steps:

1. **Data Management**
   (`src/template_project/data_management/task_data_management_template.py`)

   - Loads raw CSV data, cleans it, saves as pickle to `bld/data/`

1. **Analysis** (`src/template_project/analysis/task_analysis_template.py`)

   - Fits logit models and generates predictions
   - Iterates over `TEMPLATE_GROUPS` defined in `config.py`

1. **Final Outputs** (`src/template_project/final/task_final_template.py`)

   - Creates publication-ready figures (PNG via Plotly + Kaleido)
   - Generates results tables (Markdown format)

1. **Documents** (`documents/task_documents.py`)

   - Compiles paper to PDF and HTML (MyST Markdown via Jupyter Book 2.0)
   - Compiles presentation (Slidev → PDF)

### Key Configuration

- `src/template_project/config.py`: Central path definitions (`SRC`, `ROOT`, `BLD`,
  `DOCUMENTS`) and `TEMPLATE_GROUPS` for iterative task generation
- `pyproject.toml`: All tool configurations (Pixi, pytask, Ruff, pytest)
- `myst.yml`: Jupyter Book 2.0 configuration for PDF export (in project root)

### Directory Conventions

- `src/template_project/`: Source code (hand-written)
- `bld/`: Computational outputs (data, models, predictions, figures, tables)
- `_build/`: Document build outputs (HTML site, PDF exports)
- `documents/`: Academic paper and presentation sources (MyST Markdown and Slidev)
- `documents/public/`: Generated figures (intermediate outputs used by documents)
- `documents/tables/`: Generated tables (intermediate outputs used by documents)
- `docs_template/source/`: Project documentation (Jupyter Book)

### pytask Task Pattern

Tasks are discovered by filename pattern `task_*.py`. For iterating over groups:

```python
for group in TEMPLATE_GROUPS:

    @pytask.task(id=group)
    def task_name(depends_on=..., produces=...): ...
```

## Code Quality

- **Linting/Formatting**: Ruff with strict settings (`select = ["ALL"]`)
- **Pre-commit**: Ruff, yamlfix, yamllint, mdformat (MyST), nbstripout, codespell
- **Docstrings**: Google convention
- **Python version**: 3.14 (requires >=3.14)

## Testing

- Markers: `@pytest.mark.unit`, `@pytest.mark.integration`, `@pytest.mark.end_to_end`,
  `@pytest.mark.wip`
- End-to-end test in `tests/test_template.py` runs the full pytask build
- Uses `pdbp` as enhanced debugger (`--pdbcls=pdbp:Pdb`)
