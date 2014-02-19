#!/usr/bin/env python
# encoding: utf-8
# Hans-Martin von Gaudecker, 2012

"""
Create Sphinx documentation. Currently only LaTeX and HTML are supported.

The source file **must** be the conf.py file used by Sphinx. Everything
else has defaults, passing in the parameters is optional.

Usage for getting both html and pdf docs:

    ctx(features='sphinx', source='docs/conf.py')
    ctx(features='sphinx', source='docs/conf.py', buildername='latex')

Optional parameters and their defaults:

    * buildername: html
    * srcdir: confdir (the directory where conf.py lives)
    * outdir: confdir/buildername (in the build directory tree)
    * doctreedir: outdir/.doctrees
    * type: pdflatex (only applies to 'latex' builder)

"""


import os
from waflib import Task, TaskGen, Errors
from sphinx.application import Sphinx


class RunSphinxBuild(Task.Task):

	def scan(self):
		"""Use Sphinx' internal environment to find the dependencies."""
		s = self.sphinx_instance
		msg, dummy, iterator = s.env.update(s.config, s.srcdir, s.doctreedir, s)
		s.info(msg)
		dep_nodes = []
		for docname in s.builder.status_iterator(iterator, "reading sources... "):
			filename = docname + s.config.source_suffix
			dep_nodes.append(self.srcdir.find_node(filename))

		for dep in s.env.dependencies.values():
			for d in dep:
				temp = self.srcdir.find_node(str(d))  # Need the 'str' call because Sphinx might return Unicode strings.
				if temp is None:  # Try as absolute path if no success relative to srcdir
					temp = self.srcdir.ctx.root.find_resource(str(d))  # Need the 'str' call because Sphinx might return Unicode strings.

				if temp is not None:
					dep_nodes.append(temp)

		return (dep_nodes, [])

	def run(self):
		"""Run the Sphinx build."""
		self.sphinx_instance.build(force_all=False, filenames=None)
		return None

	def post_run(self):
		"""Add everything found in the output directory tree as an output.
		Not elegant, but pragmatic."""
		for n in self.outdir.ant_glob("**", quiet=True, remove=False):
			if n not in self.outputs: self.set_outputs(n)
		super(RunSphinxBuild, self).post_run()


def _get_main_targets(tg, s):
	"""Return some easy targets known from the Sphinx build environment **s.env**."""
	out_dir = tg.bld.root.find_node(s.outdir)
	tgt_nodes = []
	if s.builder.name == "latex":
		for tgt_info in s.env.config.latex_documents:
			tgt_nodes.append(out_dir.find_or_declare(tgt_info[1]))
	elif s.builder.name == "html":
		suffix = getattr(s.env.config, "html_file_suffix", ".html")
		tgt_name = s.env.config.master_doc + suffix
		tgt_nodes.append(out_dir.find_or_declare(tgt_name))
	else:
		raise Errors.WafError("Sphinx builder not implemented: %s" % s.builder.name)
	return tgt_nodes


@TaskGen.feature("sphinx")
@TaskGen.before_method("process_source")
def apply_sphinx(tg):
	"""Set up the task generator with a Sphinx instance and create a task."""

	# Put together the configuration based on defaults and tg attributes.
	conf = tg.path.find_node(tg.source)
	confdir = conf.parent.abspath()
	buildername = getattr(tg, "buildername", "html")
	srcdir = getattr(tg, "srcdir", confdir)
	outdir = getattr(tg, "outdir", os.path.join(conf.parent.get_bld().abspath(), buildername))
	doctreedir = getattr(tg, "doctreedir", os.path.join(outdir, ".doctrees"))

	# Set up the Sphinx instance.
	s = Sphinx(srcdir, confdir, outdir, doctreedir, buildername, status=None)

	# Get the main targets of the Sphinx build.
	tgt_nodes = _get_main_targets(tg, s)

	# Create the task and set the required attributes.  
	task = tg.create_task("RunSphinxBuild", src=conf, tgt=tgt_nodes)
	task.srcdir = tg.bld.root.find_node(s.srcdir)
	task.outdir = tg.bld.root.find_node(s.outdir)
	task.sphinx_instance = s

	# Build pdf if we have the LaTeX builder, allow for building with xelatex.
	if s.builder.name == "latex":
		compile_type = getattr(tg, "type", "pdflatex")
		tg.bld(features="tex", type=compile_type, source=tgt_nodes, name="sphinx_pdf", prompt=0)

	# Bypass the execution of process_source by setting the source to an empty list
	tg.source = []
