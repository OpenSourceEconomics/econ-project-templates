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
    print("No arguments supplied. Trying to activate environment. If it doesn't exist, run again with 'create' and 'install' as arguments")
    # args.extend(('create', 'install'))

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
        stderr=sys.stderr
    ).wait()


""" Prepend source for unix systems in activate command. We do this first to ensure the packages
    get installed in the right environment
"""

activate = 'activate {}'.format(env_name)
if sys.platform in ["linux", "linux2", "darwin"]:
    activate = 'source ' + activate

# Command array for installing/updating
cmds = []

# Fill command array given inputs and package specifications
if 'install' in args:
    args.remove('install')
    # We keep track of the installed packages after that to configure update
    if conda_deps:
        cmds.append('conda install {}'.format(conda_deps))
        cmds.append('conda list > installed_conda_pkgs')

    if pip_deps:
        cmds.append('pip install {}'.format(pip_deps))
        cmds.append('pip freeze > installed_pip_pkgs')

if 'update' in args:
    args.remove('update')
    if os.path.isfile('installed_pip_pkgs') or os.path.isfile('installed_conda_pkgs'):
        if conda_deps:
            cmds.append('conda update {}'.format(conda_deps))

        if pip_deps:
            cmds.append('pip install -U {}'.format(pip_deps))
    else:
        print("No previous installation detected. Please install packages first by running 'source set-env.sh install'")

# Yell, if invalid arguments were supplied
if len(args) > 0:
    print("Unknown option(s)")


for cmd in cmds:
    full_cmd = ' && '.join((activate, cmd))
    if sys.platform in ["win32"]:
        # Write commands in batch file and execute there
        file = open('.env/workaround.bat', 'a')
        file.write('call ' + cmd + '\r\n')
        file.close()
    else:
        print('Executing: \n{}\n'.format(full_cmd))
        try:
            subprocess.check_call(
                full_cmd,
                shell=True,
                stdin=sys.stdin,
                stdout=sys.stdout,
                stderr=subprocess.DEVNULL
            )
        except subprocess.CalledProcessError as e:
            print("If the environment could not be found, run again supplying 'create' and 'install' as arguments.")
            exit(1)
