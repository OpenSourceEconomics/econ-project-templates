"""Example file demonstrating how to import the project_paths_join
convenience function.

"""


from bld.src.library.python.project_paths import project_paths_join


out_path = project_paths_join('OUT_ANALYSIS', 'simulation_results.txt')

with open(out_path, 'w') as results_file:
    results_file.write('This is a simple test.\n')


def autodoc_example():
    """Function doing nothing except testing math rendering by Sphinx
    extensions. So here we go for inline math: :math:`a^2 + b^2 = c^2`.

    And now a standalone formula:

    .. math::

        a^2 + b^2 = c^2

    """

    return
