#!/usr/bin/env python
# encoding: utf-8
# Hans-Martin von Gaudecker, 2012-14

"""
Run a R script in the directory specified by **ctx.bldnode**.

Strings supplied to the **prepend** and **append** keywords will be
added to the command line.

Usage::

    ctx(
        features='run_r_script',
        source='some_script.r',
        target=['some_table.tex', 'some_figure.eps'],
        deps='some_data.csv',
        append='',
        prepend=''
    )

"""


from waflib import Task, TaskGen, Logs

R_COMMANDS = ['RScript', 'Rscript']


def configure(ctx):
    ctx.find_program(
        R_COMMANDS,
        var='RCMD',
        errmsg="""\n
No R executable found!\n\n
If R is needed:\n
    1) Check the settings of your system path.
    2) Note we are looking for R executables called: %s
       If yours has a different name, please report to hmgaudecker [at] gmail\n
Else:\n
    Do not load the 'run_r_script' tool in the main wscript.\n\n"""
        % R_COMMANDS
    )
    ctx.env.RFLAGS = ''


class run_r_script(Task.Task):
    """Run a R script."""

    run_str = '${PREPEND} "${RCMD}" ${RFLAGS} "${SRC[0].abspath()}" ${APPEND}'
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

        return "{prepend} [R] {rflags} {fn} {append}".format(
            prepend=self.env.PREPEND,
            rflags=self.env.RFLAGS,
            fn=self.inputs[0].path_from(self.inputs[0].ctx.launch_node()),
            append=self.env.APPEND
        )


@TaskGen.feature('run_r_script')
@TaskGen.before_method('process_source')
def apply_run_r_script(tg):
    """Task generator customising the options etc. to call R in batch
    mode for running a R script.
    """

    # Convert sources and targets to nodes
    src_node = tg.path.find_resource(tg.source)
    tgt_nodes = [tg.path.find_or_declare(t) for t in tg.to_list(tg.target)]

    tsk = tg.create_task('run_r_script', src=src_node, tgt=tgt_nodes)
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
        else:
            tsk.dep_nodes.append(node)
    Logs.debug(
        'deps: found dependencies %r for running %r' % (
            tsk.dep_nodes, src_node.relpath())
    )

    # Bypass the execution of process_source by setting the source to an empty
    # list
    tg.source = []
