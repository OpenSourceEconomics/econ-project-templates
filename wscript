# The project root directory and the build directory.
top = '.'
out = 'bld'


def configure(ctx):
    ctx.load('sphinx_build')


def build(ctx):
    ctx.recurse('src')
