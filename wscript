#! python


import os


# The project root directory and the build directory.
top = '.'
out = 'bld'


def set_project_paths(ctx):
    """Return a dictionary with project paths represented by Waf nodes."""

    pp = {}
    pp['PROJECT_ROOT'] = '.'
    pp['IN_DATA'] = 'src/original_data'
    pp['IN_MODEL_CODE'] = 'src/model_code'
    pp['IN_MODEL_SPECS'] = 'src/model_specs'
    pp['OUT_DATA'] = '{}/out/data'.format(out)
    pp['OUT_ANALYSIS'] = '{0}/out/analysis'.format(out)
    pp['OUT_FINAL'] = '{0}/out/final'.format(out)
    pp['OUT_FIGURES'] = '{0}/out/figures'.format(out)
    pp['OUT_TABLES'] = '{0}/out/tables'.format(out)

    # Convert the directories into Waf nodes.
    for key, val in pp.items():
        pp[key] = ctx.path.make_node(val)

    return pp


def path_to(ctx, pp_key, *args):
    """Return the relative path to os.path.join(*args*) in the directory
    PROJECT_PATHS[pp_key] as seen from ctx.path (i.e. the directory of the
    current wscript).

    Use this to get the relative path---as needed by Waf---to a file in one
    of the directory trees defined in the PROJECT_PATHS dictionary above.

    We always pretend everything is in the source directory tree, Waf takes
    care of the correct placing of targets and sources.

    """

    # Implementation detail:
    #   We find the path to the directory where the file lives, so that
    #   we do not accidentally declare a node that does not exist.
    dir_path_in_tree = os.path.join('.', *args[:-1])
    # Find/declare the directory node. Use an alias to shorten the line.
    pp_key_fod = ctx.env.PROJECT_PATHS[pp_key].find_or_declare
    dir_node = pp_key_fod(dir_path_in_tree).get_src()
    # Get the relative path to the directory.
    path_to_dir = dir_node.path_from(ctx.path)
    # Return the relative path to the file.
    return os.path.join(path_to_dir, args[-1])


def configure(ctx):
    ctx.env.PYTHONPATH = os.getcwd()
    # Disable on a machine where security risks could arise
    ctx.env.PDFLATEXFLAGS = '-shell-escape'
    ctx.load('biber')
    ctx.load('run_py_script')
    ctx.load('sphinx_build')
    ctx.load('write_project_headers')


def build(ctx):
    ctx.env.PROJECT_PATHS = set_project_paths(ctx)
    ctx.path_to = path_to
    # Generate header file with project paths in 'bld' directory
    ctx(features='write_project_paths', target='project_paths.py')
    ctx.add_group()
    ctx.recurse('src')
