
*********************************************************
Templates for Reproducible Research Projects in Economics
*********************************************************

An empirical or computational research project only becomes a useful building block for science when **all** steps can be easily repeated and modified by others. This means that we should automate as much as possible, compared to pointing and clicking with a mouse or, more generally, keeping track yourself of what needs to be done.

This is a collection of templates where much of this automation is pre-configured via describing the research workflow as a directed acyclic graph (`DAG <http://en.wikipedia.org/wiki/Directed_acyclic_graph>`_) using `pytask <https://pytask-dev.readthedocs.io/en/latest/>`_. You just need to:

* Install the template for the main language in your project (Python, R, Stata, Matlab, ...)
* Move your programs to the right places and change the placeholder scripts
* Run pytask, which will build your entire project the first time you run it. Later, it will automatically figure out which parts of the project need to be rebuilt.


.. raw:: html

  <p><a class="reference download internal" href="../../../tutorial-econ-project-templates.pdf"><code class="xref download docutils literal"><span class="pre">Download</span> <span class="pre">this</span> <span class="pre">tutorial</span> <span class="pre">as</span> <span class="pre">pdf</span></code></a></p>


.. toctree::
    :maxdepth: 2

    getting_started
    introduction
    py-example
    r-example
    program_environments
    pre-commit
    faq
    feedback_welcome
    zreferences
    release_notes
    developer
