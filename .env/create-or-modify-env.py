#!/usr/bin/env python
import subprocess
import os
import sys
import json


# Determine directory name, since this will be the name of the environment
abspath_here = os.path.dirname(os.path.abspath(__file__))
env_name = os.path.split(os.path.split(abspath_here)[0])[1]


# Read specs from specification file
json_data = open('.env/specification.json')
specs = json.load(json_data)
json_data.close()

# Parse spec
python_version = specs['python-version']
conda_deps = " ".join(map(str, specs['conda-deps']))
pip_deps = " ".join(map(str, specs['pip-deps']))

# Get args from shell script
args = sys.argv[1:]

# Set default if no arguments are supplied
if len(args) < 1:
    print("No arguments supplied. Continuing with 'create' and 'install' as default")
    args.extend(('create', 'install'))

# Create environment
if 'create' in args:
    args.remove('create')
    popen = subprocess.Popen(
        'conda create -n {} python={} --no-default-packages'.format(
            env_name,
            python_version
        ),
        shell=True,
        stdin=sys.stdin,
        stdout=sys.stdout,
        stderr=sys.stdout
    ).wait()


# Prepend source for unix systems
activate = 'activate {}'.format(env_name)
if sys.platform in ["linux", "linux2", "darwin"]:
    activate = 'source ' + activate

# Command array for installing/updating
cmds = []

# Fill command array given inputs and package specifications
if 'install' in args:
    args.remove('install')
    if conda_deps:
        cmds.append('conda install {}'.format(conda_deps))

    if pip_deps:
        cmds.append('pip install {}'.format(pip_deps))

if 'update' in args:
    args.remove('update')
    if conda_deps:
        cmds.append('conda update {}'.format(conda_deps))

    if pip_deps:
        cmds.append('pip install -U {}'.format(pip_deps))

# Yell, if invalid arguments were supplied
if len(args) > 0:
    print("Unknown option(s)")


for cmd in cmds:
    full_cmd = '\n'.join((activate, cmd))
    if sys.platform in ["win32"]:
        # Write commands in batch file and execute there
        file = open('.env/workaround.bat', 'a')
        file.write('call ' + cmd + '\r\n')
        file.close()
    else:
        print('Executing: \n{}\n'.format(full_cmd))
        popen = subprocess.Popen(
            full_cmd,
            shell=True,
            stdin=sys.stdin,
            stdout=sys.stdout,
            stderr=sys.stdout
        ).wait()
