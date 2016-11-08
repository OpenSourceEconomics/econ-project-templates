#! /usr/bin/env python
# encoding: utf-8
# Calle Rosenquist, 2016 (xbreak)

"""
Provides Python unit test support using :py:class:`waflib.Tools.waf_unit_test.utest`
task via the **pytest** feature.

The "use" dependencies are used for both update calculation and to populate
``sys.path`` via the ``PYTHONPATH`` environment variable.

1. Load **pytest** and the dependency ``waf_unit_test`` in configure.
2. Create a task generator with feature **pytest** and customize behaviour with the following attributes:

   * ``pytest_source``: Test input files.
   * ``ut_str``: Test runner command, e.g. ``${PYTHON} -B -m unittest discover`` or
				 if nose is used: ``${NOSETESTS} --no-byte-compile ${SRC}``.
   * ``ut_shell``: Determines if ``ut_str`` is executed in a shell. Default: False.
   * ``ut_cwd``: Working directory for test runner. Defaults to directory of
	             first ``pytest_source`` file.

For example::

	def build(bld):
		# Python package to test
		bld(name         = 'foo',
			features     = 'py'
			source       = bld.path.ant_glob('src/**/*.py),
			install_from = 'src')

		# Corresponding unit test
		bld(features     = 'pytest',
			use          = 'foo',
			pytest_source = bld.path.ant_glob('test/*.py'),
			ut_str       = '${PYTHON} -B -m unittest discover')

"""

import os
from waflib import Task, TaskGen, Errors

def _process_use_rec(self, name):
	"""
	Recursively process ``use`` for task generator with name ``name``..
	Used by pytest_process_use.
	"""
	if name in self.pytest_use_not or name in self.pytest_use_seen:
		return
	try:
		tg = self.bld.get_tgen_by_name(name)
	except Errors.WafError:
		self.pytest_use_not.add(name)
		return

	self.pytest_use_seen.append(name)
	tg.post()

	for n in self.to_list(getattr(tg, 'use', [])):
		_process_use_rec(self, n)

@TaskGen.feature('pytest')
@TaskGen.after_method('process_source')
def pytest_process_use(self):
	"""
	Process the ``use`` attribute which contains a list of task generator names.
	"""
	self.pytest_use_not = set()
	self.pytest_use_seen = []
	self.pytest_paths = set()
	self.pytest_dep_nodes = []

	names = self.to_list(getattr(self, 'use', []))
	for name in names:
		_process_use_rec(self, name)

	# Collect dependent nodes
	for name in self.pytest_use_seen:
		tg = self.bld.get_tgen_by_name(name)

		if 'py' in tg.features:
			# Python dependencies are added to PYTHONPATH
			# Use only py-files in multi language sources
			self.pytest_dep_nodes.extend([s for s in tg.source if s.suffix() == '.py'])

			pypath = getattr(tg, 'install_from', None)
			if not pypath:
				pypath = tg.path
			self.pytest_paths.add(pypath.abspath())

		if getattr(tg, 'link_task', None):
			# For tasks with a link_task (C, C++, D et.c.) add
			# the output nodes as dependencies for test to be re-run if it's updated.
			self.pytest_dep_nodes.extend(tg.link_task.outputs)

@TaskGen.feature('pytest')
@TaskGen.after_method('pytest_process_use')
def make_pytest(self):
	"""
	Creates a ``utest`` task with a modified PYTHONPATH environment for Python.
	"""
	nodes = self.to_nodes(self.pytest_source)
	tsk = self.create_task('utest', nodes)
	tsk.dep_nodes.extend(self.pytest_dep_nodes)

	if getattr(self, 'ut_str', None):
		self.ut_run, lst = Task.compile_fun(self.ut_str, shell=getattr(self, 'ut_shell', False))
		tsk.vars = lst + tsk.vars

	if getattr(self, 'ut_cwd', None):
		if isinstance(self.ut_cwd, str):
			# we want a Node instance
			if os.path.isabs(self.ut_cwd):
				self.ut_cwd = self.bld.root.make_node(self.ut_cwd)
			else:
				self.ut_cwd = self.path.make_node(self.ut_cwd)
	else:
		self.ut_cwd = tsk.inputs[0].parent

	if not self.ut_cwd.exists():
		self.ut_cwd.mkdir()

	self.ut_env = dict(os.environ)
	self.ut_env['PYTHONPATH'] = os.pathsep.join(self.pytest_paths) + self.ut_env.get('PYTHONPATH', '')

