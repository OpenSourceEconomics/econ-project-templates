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
        cmds.append('conda list > .env/installed_conda_pkgs')

    if pip_deps:
        cmds.append('pip install {}'.format(pip_deps))
        cmds.append('pip freeze > .env/installed_pip_pkgs')

if 'update' in args:
    args.remove('update')
    # Check if an installation was carried out
    if os.path.isfile('.env/installed_pip_pkgs') or os.path.isfile('.env/installed_conda_pkgs'):

        # Get all packages from pip and conda
        entire_spec = specs['conda-deps'] + specs['pip-deps']

        # Initialize Helper Class
        from pkg_management import check_packages
        check = check_packages()

        # Check if no new packages were added to the spec since the last installation
        if check.compare_package_sets(entire_spec):

            # Run necessary updates
            if conda_deps:
                cmds.append('conda update {}'.format(conda_deps))

            if pip_deps:
                cmds.append('pip install -U --no-deps {}'.format(pip_deps))
        else:
            print("Specification changed since last install, please run 'install' first.")
    else:
        print("No previous installation detected. Please install packages first via 'source set-env.sh install'")


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
        with subprocess.Popen(full_cmd, stdout=sys.stdout, shell=True) as process:
            try:
                output, unused_err = process.communicate()
            except subprocess.TimeoutExpired:
                process.kill()
                output, unused_err = process.communicate()
                raise subprocess.TimeoutExpired(process.args, output=output)
            except:
                process.kill()
                process.wait()
                raise
            retcode = process.poll()
            if retcode:
                raise subprocess.CalledProcessError(retcode, process.args, output=output)
        # try:
        #     subprocess.check_output(
        #         full_cmd,
        #         shell=True,
        #         stderr=subprocess.STDOUT,
        #         # stdin=subprocess.STDIN
        #     )
        # except subprocess.CalledProcessError as e:
        #     exit(1)
