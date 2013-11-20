#!/usr/bin/env python
# encoding: ISO8859-1
# Thomas Nagy, 2005-2012

"""
Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:

1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.

3. The name of the author may not be used to endorse or promote products
   derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS OR
IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT,
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.
"""

import os, sys

VERSION="1.7.13"
REVISION="adea09bccb360e1c5dc9b905e340584a"
INSTALL=''
C1='#,'
C2='#)'
cwd = os.getcwd()
join = os.path.join


WAF='waf'
def b(x):
	return x
if sys.hexversion>0x300000f:
	WAF='waf3'
	def b(x):
		return x.encode()

def err(m):
	print(('\033[91mError: %s\033[0m' % m))
	sys.exit(1)

def test(dir):
	try:
		os.stat(join(dir, 'waflib'))
		return os.path.abspath(dir)
	except OSError:
		pass

def find_lib():
	name = sys.argv[0]
	base = os.path.dirname(os.path.abspath(name))

	#devs use $WAFDIR
	w=test(os.environ.get('WAFDIR', ''))
	if w: return w

	#waf-light
	if name.endswith('waf-light'):
		w = test(base)
		if w: return w
		err('waf-light requires waflib -> export WAFDIR=/folder')

	dirname = '%s-%s-%s' % (WAF, VERSION, REVISION)
	for i in [INSTALL,'/usr','/usr/local','/opt']:
		w = test(i + '/lib/' + dirname)
		if w: return w

	#waf-local
	dir = join(base, (sys.platform != 'win32' and '.' or '') + dirname)
	w = test(dir)
	if w: return w

	#unpack
	unpack_wafdir(dir)
	return dir

wafdir = find_lib()
sys.path.insert(0, wafdir)

if __name__ == '__main__':

	from waflib import Scripting
	Scripting.waf_entry_point(cwd, VERSION, wafdir)
