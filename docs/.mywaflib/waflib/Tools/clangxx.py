#!/usr/bin/env python
# Thomas Nagy 2009-2018 (ita)
"""
Detect the Clang++ C++ compiler
"""
from waflib.Configure import conf
from waflib.Tools import ar
from waflib.Tools import ccroot
from waflib.Tools import gxx


@conf
def find_clangxx(conf):
    """
	Finds the program clang++, and executes it to ensure it really is clang++
	"""
    cxx = conf.find_program("clang++", var="CXX")
    conf.get_cc_version(cxx, clang=True)
    conf.env.CXX_NAME = "clang"


def configure(conf):
    conf.find_clangxx()
    conf.find_program(["llvm-ar", "ar"], var="AR")
    conf.find_ar()
    conf.gxx_common_flags()
    conf.gxx_modifier_platform()
    conf.cxx_load_tools()
    conf.cxx_add_flags()
    conf.link_add_flags()
