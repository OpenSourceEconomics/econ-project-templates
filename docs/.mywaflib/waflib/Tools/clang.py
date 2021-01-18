#!/usr/bin/env python
# Krzysztof Kosiński 2014
"""
Detect the Clang C compiler
"""
from waflib.Configure import conf
from waflib.Tools import ar
from waflib.Tools import ccroot
from waflib.Tools import gcc


@conf
def find_clang(conf):
    """
    Finds the program clang and executes it to ensure it really is clang
    """
    cc = conf.find_program("clang", var="CC")
    conf.get_cc_version(cc, clang=True)
    conf.env.CC_NAME = "clang"


def configure(conf):
    conf.find_clang()
    conf.find_program(["llvm-ar", "ar"], var="AR")
    conf.find_ar()
    conf.gcc_common_flags()
    conf.gcc_modifier_platform()
    conf.cc_load_tools()
    conf.cc_add_flags()
    conf.link_add_flags()
