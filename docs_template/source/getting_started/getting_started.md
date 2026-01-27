(getting_started)=

# Getting Started

The goal of this project is to get you from a fresh clone to a working research paper in
less than five minutes.

## The "Magic" Moment

Once your system is {ref}`prepared <preparing_your_system>`, you can experience the
reproducibility of this template by running a single command.

1. **Clone the repository** (or your new project).
1. **Run the analysis and view the results**:

```bash
# View the research paper in your browser
pixi run view-paper

# View the presentation slides
pixi run view-pres
```

These commands will automatically:

- Download and install all necessary dependencies (Python, Node.js, libraries) into a
  private project environment.
- Run the entire computational pipeline (data cleaning, analysis, figure generation).
- Launch a local web server to display the final outputs.

## Next Steps

Once you have verified that the template runs on your machine, you can proceed to:

- {ref}`preparing_your_system`: Detailed instructions on installing Pixi.
- {ref}`customising_the_template`: How to adapt this structure for your own research.
- {ref}`second_machine`: How to ensure your co-authors can run your project.
