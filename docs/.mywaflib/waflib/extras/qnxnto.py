#!/usr/bin/env python
# Jérôme Carretero 2011 (zougloub)
# QNX neutrino compatibility functions
import os
import sys

from waflib import Utils


class Popen:
    """
    Popen cannot work on QNX from a threaded program:
    Forking in threads is not implemented in neutrino.

    Python's os.popen / spawn / fork won't work when running in threads (they will if in the main program thread)

    In waf, this happens mostly in build.
    And the use cases can be replaced by os.system() calls.
    """

    __slots__ = ["prog", "kw", "popen", "verbose"]
    verbose = 0

    def __init__(self, prog, **kw):
        try:
            self.prog = prog
            self.kw = kw
            self.popen = None
            if Popen.verbose:
                sys.stdout.write(f"Popen created: {prog!r}, kw={kw!r}...")

            do_delegate = kw.get("stdout") == -1 and kw.get("stderr") == -1
            if do_delegate:
                if Popen.verbose:
                    print("Delegating to real Popen")
                self.popen = self.real_Popen(prog, **kw)
            else:
                if Popen.verbose:
                    print("Emulating")
        except Exception as e:
            if Popen.verbose:
                print("Exception: %s" % e)
            raise

    def __getattr__(self, name):
        if Popen.verbose:
            sys.stdout.write("Getattr: %s..." % name)
        if name in Popen.__slots__:
            return object.__getattribute__(self, name)
        else:
            if self.popen is not None:
                if Popen.verbose:
                    print("from Popen")
                return getattr(self.popen, name)
            else:
                if name == "wait":
                    return self.emu_wait
                else:
                    raise Exception("subprocess emulation: not implemented: %s" % name)

    def emu_wait(self):
        if Popen.verbose:
            print(f"emulated wait ({self.prog!r} kw={self.kw!r})")
        if isinstance(self.prog, str):
            cmd = self.prog
        else:
            cmd = " ".join(self.prog)
        if "cwd" in self.kw:
            cmd = 'cd "{}" && {}'.format(self.kw["cwd"], cmd)
        return os.system(cmd)


if sys.platform == "qnx6":
    Popen.real_Popen = Utils.subprocess.Popen
    Utils.subprocess.Popen = Popen
