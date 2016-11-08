#!/usr/bin/env python
# encoding: utf-8
# Hans-Martin von Gaudecker, 2012-16

"""
Run a Matlab script.

Note that the script is run in the directory where it lives -- Matlab won't
allow it any other way.

For error-catching purposes, keep an own log-file that is destroyed if the
task finished without error. If not, it will show up as mscript_[index].log
in the bldnode directory.

Strings supplied to the **prepend** and **append** keywords will be added
to the command line.

The **add_build_to_path** keyword allows to add the build directory to the
Matlab search path (defaults to True). Useful to include project paths etc..

Usage::

    ctx(
        features='run_m_script',
        source='some_script.m',
        target=['some_table.tex', 'some_figure.eps'],
        deps='some_data.mat',
        append='',
        prepend='',
        add_build_to_path=True
    )

"""

import os
from waflib import Task, TaskGen, Logs

MATLAB_COMMANDS = ['matlab']


def configure(ctx):
    ctx.find_program(
        MATLAB_COMMANDS,
        var='MATLABCMD',
        errmsg="""\n
No Matlab executable found!\n\n
If Matlab is needed:\n
    1) Check the settings of your system path.
    2) Note we are looking for Matlab executables called: %s
       If yours has a different name, please report to hmgaudecker [at] gmail\n
Else:\n
    Do not load the 'run_m_script' tool in the main wscript.\n\n"""
        % MATLAB_COMMANDS
    )
    ctx.env.MATLABFLAGS = '-wait -nodesktop -nosplash -minimize'


class run_m_script_base(Task.Task):
    """Run a Matlab script."""

    run_str = '${PREPEND} "${MATLABCMD}" ${MATLABFLAGS} -logfile "${LOGFILEPATH}" -r "try, ${ADDPATH} ${MSCRIPTTRUNK} ${APPEND}, exit(0), catch err, disp(err.getReport()), exit(1), end"'
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

        return "{prepend} [Matlab] {matlabflags} -logfile {lfn} -r {fn} {append}".format(
                prepend=self.env.PREPEND,
                matlabflags=self.env.MATLABFLAGS,
                lfn=self.env.LOGFILEPATH,
                fn=self.inputs[0].path_from(self.inputs[0].ctx.launch_node()),
                append=self.env.APPEND
            )


class run_m_script(run_m_script_base):
    """Erase the Matlab overall log file if everything went okay, else raise an
    error and print its 10 last lines.
    """

    def run(self):
        ret = run_m_script_base.run(self)
        logfile = self.env.LOGFILEPATH
        if ret:
            with open(logfile, mode='r') as f:
                tail = f.readlines()[-10:]
            Logs.error(
                """Running Matlab on %s returned the error %r\n
Check the log file %s, last 10 lines\n\n%s\n\n\n"""
                % (
                    self.inputs[0].relpath(),
                    ret,
                    logfile,
                    '\n'.join(tail)
                )
            )
        else:
            os.remove(logfile)
        return ret


@TaskGen.feature('run_m_script')
@TaskGen.before_method('process_source')
def apply_run_m_script(tg):
    """Task generator customising the options etc. to call Matlab in batch
    mode for running a m-script.
    """

    # Convert sources and targets to nodes
    src_node = tg.path.find_resource(tg.source)
    if src_node is None:
        tg.bld.fatal(
            "Could not find source file: {}".format(os.path.join(tg.path.relpath(), tg.source))
        )
    tgt_nodes = [tg.path.find_or_declare(t) for t in tg.to_list(tg.target)]

    tsk = tg.create_task('run_m_script', src=src_node, tgt=tgt_nodes)
    tsk.cwd = src_node.parent.abspath()
    if getattr(tg, 'add_build_to_path', True):
        tsk.env.ADDPATH = 'addpath ' + tg.bld.bldnode.abspath() + '; '
    else:
        tsk.env.ADDPATH = ''
    tsk.env.MSCRIPTTRUNK = os.path.splitext(src_node.name)[0]
    tsk.env.LOGFILEPATH = os.path.join(
        tg.bld.bldnode.abspath(),
        '%s_%d.log' % (tsk.env.MSCRIPTTRUNK, tg.idx)
    )
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
    Logs.debug('deps: found dependencies %r for running %r' % (
        tsk.dep_nodes, src_node.relpath()))

    # Bypass the execution of process_source by setting the source to an empty
    # list
    tg.source = []
