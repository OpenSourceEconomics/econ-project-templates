#!/usr/bin/env python
# encoding: utf-8
# Hans-Martin von Gaudecker and David Birke, 2012-16

"""
Run a Perl script in the directory specified by **ctx.bldnode**.

Strings supplied to the **prepend** and **append** keywords will be added
to the command line.

Usage::

    ctx(
        features='run_pl_script',
        source='some_script.pl',
        target=['some_table.tex', 'some_figure.eps'],
        deps='some_data.csv',
        append='',
        prepend=''
    )

"""


import os
from waflib import Task, TaskGen, Logs

PERL_COMMANDS = ['perl']


def configure(ctx):
    ctx.find_program(
        PERL_COMMANDS,
        var='PERLCMD',
        errmsg="""\n
No Perl executable found!\n\n
If Perl is needed:\n
    1) Check the settings of your system path.
    2) Note we are looking for Perl executables called: %s
       If yours has a different name, please report to hmgaudecker [at] gmail\n
Else:\n
    Do not load the 'run_pl_script' tool in the main wscript.\n\n"""
        % PERL_COMMANDS
    )


class run_pl_script(Task.Task):
    """Run a Perl script."""

    run_str = '${PREPEND} "${PERLCMD}" "${SRC[0].abspath()}" ${APPEND}'
    shell = True

    def exec_command(self, cmd, **kw):
        bld = self.generator.bld
        try:
            if not kw.get('cwd', None):
                kw['cwd'] = bld.cwd
        except AttributeError:
            bld.cwd = kw['cwd'] = bld.variant_dir
        if not self.buffer_output:
            kw["stdout"] = kw["stderr"] = None
        return bld.exec_command(cmd, **kw)

    def keyword(self):
        """
        Override the 'Compiling' default.

        """

        return 'Running'

    def __str__(self):
        """
        More useful output.

        """

        return "{prepend} [Perl] {fn} {append}".format(
            prepend=self.env.PREPEND,
            fn=self.inputs[0].path_from(self.inputs[0].ctx.launch_node()),
            append=self.env.APPEND
        )


@TaskGen.feature('run_pl_script')
@TaskGen.before_method('process_source')
def apply_run_pl_script(tg):
    """Task generator customising the options etc. to call Perl
    for running a script.
    """

    # Convert sources and targets to nodes
    src_node = tg.path.find_resource(tg.source)
    if src_node is None:
        tg.bld.fatal(
            "Could not find source file: {}".format(os.path.join(tg.path.relpath(), tg.source))
        )
    tgt_nodes = [tg.path.find_or_declare(t) for t in tg.to_list(tg.target)]

    tsk = tg.create_task('run_pl_script', src=src_node, tgt=tgt_nodes)
    tsk.env.APPEND = getattr(tg, 'append', '')
    tsk.env.PREPEND = getattr(tg, 'prepend', '')
    tsk.buffer_output = getattr(tg, 'buffer_output', True)

    # dependencies (if the attribute 'deps' changes, trigger a recompilation)
    for x in tg.to_list(getattr(tg, 'deps', [])):
        node = tg.path.find_resource(x)
        if not node:
            tg.bld.fatal(
                'Could not find dependency %r for running %r'
                % (x, src_node.relpath())
            )
        tsk.dep_nodes.append(node)
    Logs.debug(
        'deps: found dependencies %r for running %r'
        % (tsk.dep_nodes, src_node.relpath())
    )

    # Bypass the execution of process_source by setting the source to an empty
    # list
    tg.source = []
