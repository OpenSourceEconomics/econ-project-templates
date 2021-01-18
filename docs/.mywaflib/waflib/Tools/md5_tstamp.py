#! /usr/bin/env python
"""
Re-calculate md5 hashes of files only when the file times or the file
size have changed.

The hashes can also reflect either the file contents (STRONGEST=True) or the
file time and file size.

The performance benefits of this module are usually insignificant.
"""
import os
import stat

from waflib import Build
from waflib import Node
from waflib import Utils

STRONGEST = True

Build.SAVED_ATTRS.append("hashes_md5_tstamp")


def h_file(self):
    filename = self.abspath()
    st = os.stat(filename)

    cache = self.ctx.hashes_md5_tstamp
    if filename in cache and cache[filename][0] == st.st_mtime:
        return cache[filename][1]

    if STRONGEST:
        ret = Utils.h_file(filename)
    else:
        if stat.S_ISDIR(st[stat.ST_MODE]):
            raise OSError("Not a file")
        ret = Utils.md5(str((st.st_mtime, st.st_size)).encode()).digest()

    cache[filename] = (st.st_mtime, ret)
    return ret


h_file.__doc__ = Node.Node.h_file.__doc__
Node.Node.h_file = h_file
