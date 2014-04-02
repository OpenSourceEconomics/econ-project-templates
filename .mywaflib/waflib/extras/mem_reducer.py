#! /usr/bin/env python
# encoding: UTF-8

"""
This tool can help to reduce the memory usage in very large builds featuring many tasks with after/before attributes.
It may also improve the overall build time by decreasing the amount of iterations over tasks.

Usage:
def options(opt):
	opt.load('mem_reducer')
"""

import itertools
from waflib import Utils, Task, Runner, Logs

class SetOfTasks(object):
	"""Wraps a set and a task which has a list of other sets.
	The interface is meant to mimic the interface of set. Add missing functions as needed.
	"""
	def __init__(self, owner):
		self._set = owner.run_after
		self._owner = owner

	def __iter__(self):
		for g in self._owner.run_after_groups:
			#print len(g)
			for task in g:
				yield task
		for task in self._set:
			yield task

	def add(self, obj):
		self._set.add(obj)

	def update(self, obj):
		self._set.update(obj)

def set_precedence_constraints(tasks):
	cstr_groups = Utils.defaultdict(list)
	for x in tasks:
		x.run_after = SetOfTasks(x)
		x.run_after_groups = []
		x.waiting_sets = []

		h = x.hash_constraints()
		cstr_groups[h].append(x)

	# create sets which can be reused for all tasks
	for k in cstr_groups.keys():
		cstr_groups[k] = set(cstr_groups[k])

	# this list should be short
	for key1, key2 in itertools.combinations(cstr_groups.keys(), 2):
		group1 = cstr_groups[key1]
		group2 = cstr_groups[key2]
		# get the first entry of the set
		t1 = next(iter(group1))
		t2 = next(iter(group2))

		# add the constraints based on the comparisons
		if Task.is_before(t1, t2):
			for x in group2:
				x.run_after_groups.append(group1)
			for k in group1:
				k.waiting_sets.append(group1)
		elif Task.is_before(t2, t1):
			for x in group1:
				x.run_after_groups.append(group2)
			for k in group2:
				k.waiting_sets.append(group2)

Task.set_precedence_constraints = set_precedence_constraints

def get_out(self):
	tsk = self.out.get()
	if not self.stop:
		self.add_more_tasks(tsk)
	self.count -= 1
	self.dirty = True

	# shrinking sets
	try:
		ws = tsk.waiting_sets
	except AttributeError:
		pass
	else:
		for k in ws:
			try:
				k.remove(tsk)
			except KeyError:
				pass

	return tsk
Runner.Parallel.get_out = get_out

if 1:
	def start(self):
		self.total = self.bld.total()

		while not self.stop:

			self.refill_task_list()

			# consider the next task
			tsk = self.get_next_task()
			if not tsk:
				if self.count:
					# tasks may add new ones after they are run
					continue
				else:
					# no tasks to run, no tasks running, time to exit
					break

			if tsk.hasrun:
				# if the task is marked as "run", just skip it
				self.processed += 1
				continue

			if self.stop: # stop immediately after a failure was detected
				break

			try:
				st = tsk.runnable_status()
			except Exception:
				self.processed += 1
				# TODO waf 1.7 this piece of code should go in the error_handler
				tsk.err_msg = Utils.ex_stack()
				if not self.stop and self.bld.keep:
					tsk.hasrun = Task.SKIPPED
					if self.bld.keep == 1:
						# if -k stop at the first exception, if -kk try to go as far as possible
						if Logs.verbose > 1 or not self.error:
							self.error.append(tsk)
						self.stop = True
					else:
						if Logs.verbose > 1:
							self.error.append(tsk)
					continue
				tsk.hasrun = Task.EXCEPTION
				self.error_handler(tsk)
				continue

			if st == Task.ASK_LATER:
				self.postpone(tsk)
			elif st == Task.SKIP_ME:
				self.processed += 1
				tsk.hasrun = Task.SKIPPED
				self.add_more_tasks(tsk)

				# shrinking sets
				try:
					ws = tsk.waiting_sets
				except AttributeError:
					pass
				else:
					for k in ws:
						try:
							k.remove(tsk)
						except KeyError:
							pass

			else:
				# run me: put the task in ready queue
				tsk.position = (self.processed, self.total)
				self.count += 1
				tsk.master = self
				self.processed += 1

				if self.numjobs == 1:
					tsk.process()
				else:
					self.add_task(tsk)

		# self.count represents the tasks that have been made available to the consumer threads
		# collect all the tasks after an error else the message may be incomplete
		while self.error and self.count:
			self.get_out()

		#print loop
		assert (self.count == 0 or self.stop)

		# free the task pool, if any
		self.free_task_pool()

	Runner.Parallel.start = start


