""" Create and maintain anaconda envionment"""
from __future__ import print_function
import subprocess
import os
import sys
import json
import shutil

USAGE = """set-env.sh [help] [arguments]:

This script activates the conda environment associated with the current directory name.
By supplying one of more of the arguments below you can also create the environment if
it does not exist and/or install required packages.

where arguments can be:
    help, -h      Show this help text
    create        Create a new miniconda environment with the current foldername
    install       Install the packages specified in .env/specification.json. Also run
                  this after updating the specifications file.
    update        Update previously installed packages"""


# Determine directory name, since this will be the name of the environment
ABSPATH_HERE = os.path.dirname(os.path.abspath(__file__))
ENV_NAME = os.path.split(os.path.split(ABSPATH_HERE)[0])[1]


# Read specs from specification file
JSON_DATA = open('specification.json')
SPECS = json.load(JSON_DATA)
JSON_DATA.close()

# Parse spec
PYTHON_VERSION = SPECS['python-version']
CONDA_DEPS = " ".join(map(str, SPECS['conda-deps']))
PIP_DEPS = " ".join(map(str, SPECS['pip-deps']))

# Get args from shell script
args = sys.argv[1:]

# Call help file
if 'help' in args or '-h' in args:
    args.remove('help') if 'help' in args else args.remove('-h')
    print(USAGE)
    sys.exit(1)


""" Prepend source for unix systems in activate command. We do this first to ensure the packages
    get installed in the right environment"""
activate = 'activate {}'.format(ENV_NAME)
if sys.platform in ["linux", "linux2", "darwin"]:
    activate = 'source ' + activate

def try_to_activate_env():
    # See if environment can be activated to determine further process
    try:
        FNULL = open(os.devnull, 'w')
        subprocess.check_call(activate, stdout=FNULL, stderr=subprocess.STDOUT, shell=True)
        return True
    except subprocess.CalledProcessError:
        return False

ACT_STATUS = try_to_activate_env()

# Case with no arguments
# Set default if no arguments are supplied
if len(args) < 1:
    # If env exists we return 0 and activate the env in bash/batch
    if ACT_STATUS:
        sys.exit(0)
    else:
        Q_CREATE = input("Environment {} does not exist. Do you want to create it? (y/n)".format(ENV_NAME))
        if Q_CREATE in ("Y", "y"):
            args.append('create')
            Q_INSTALL = input("Also install specified packages? (y/n)")
            if Q_INSTALL in ("Y", "y"):
                args.append('install')
                args.append('silent')
        else:
            sys.exit(1)
            print("Nothing done")


def create_env():
    """Creates a new environment"""
    if 'create' in args:
        args.remove('create')
    subprocess.Popen(
        'conda create -n {} python={} --no-default-packages'.format(
            ENV_NAME,
            PYTHON_VERSION
        ),
        shell=True,
        stdin=sys.stdin,
        stdout=sys.stdout,
        stderr=sys.stderr
    ).wait()


# Handle case with arguments
# Create environment
if 'create' in args:
    create_env()

# Command array for installing/updating
cmds = []

def install_deps():
    """Installs specified dependencies"""

    if not 'silent' in args:
    # We need to update this for the Windows case as install gets executed from batch file
        ACT_STATUS = try_to_activate_env()

        # If there's no env present, ask to create one
        if not ACT_STATUS:
            Q_CREATE = input("Environment {} does not exist. Do you want to create it? (y/n)".format(ENV_NAME))

            if Q_CREATE in ("Y", "y"):
                create_env()

            else:
                sys.exit(1)
                print("Nothing done")
    else:
        args.remove('silent')

    if 'install' in args:
        args.remove('install')

    # Handle the case of a fresh install, we just pass all required pkgs to pip and conda
    if not os.path.isfile('.env/installed_spec.json'):
        # We keep track of the packages to install to have an indication if something changed later
        # This works for first time install. After that we only want to install/remove diffs

        if CONDA_DEPS:
            cmds.append('conda install {}'.format(CONDA_DEPS))
            cmds.append('conda list > .env/installed_conda_pkgs')

        if PIP_DEPS:
            cmds.append('pip install {}'.format(PIP_DEPS))
            cmds.append('pip freeze > .env/installed_pip_pkgs')

    else:
        from pkg_management import CheckPackages
        check = CheckPackages()
        comp = check.compare_package_sets(SPECS)

        # We look at the diff in requirements or installs to determine how to change our installation
        # Note that we can't really remove packages that are installed but not in the spec easily since
        # they might be dependencies of packages in the spec.
        # That's why we look at the last installed spec when checking for removals



        # Note: https://github.com/ContinuumIO/anaconda-issues/issues/232
        # When running install, unused dependencies are not removed at this point due to
        # potential incompatibilities.
        # This might change when the #232 is being taken care of

        if len(comp) > 0:
            changes = []
            for item in comp.keys():
                changes.append(item + " " + " ".join(map(str, comp[item])))
            update_installation = input("The following changes have to made in order to bring your installation up to date: {}. Proceed? (y/n)".format(str(changes)[1:-1]))
            if update_installation in ("Y", "y"):
                cmds.append(item + " " + " ".join(map(str, comp[item])))
            else:
                print("Nothing done.")
                sys.exit(1)

    # Keep copy of spec to be installed for further diffs
    shutil.copy("specification.json", ".env/installed_spec.json")


# Fill command array given inputs and package specifications
if 'install' in args:
    install_deps()


if 'update' in args:
    if not ACT_STATUS:
        install_deps()

    args.remove('update')
    # Check if an installation was carried out before
    if os.path.isfile('.env/installed_pip_pkgs') or os.path.isfile('.env/installed_conda_pkgs'):

        # Initialize Helper Class and get package comparison
        from pkg_management import CheckPackages
        check = CheckPackages()

        # This now returns a dict with instructions (conda/pip, install/remove [pkgs]).
        # Parse them and show which packages are to be removed/added.
        # Then call install/remove with those packages and then proceed to update
        comp = check.compare_package_sets(SPECS)

        # Check if spec changed
        if len(comp) == 0:
            # Run necessary updates
            if CONDA_DEPS:
                cmds.append('conda update {}'.format(CONDA_DEPS))

            if PIP_DEPS:
                cmds.append('pip install -U --no-deps {}'.format(PIP_DEPS))
        else:
            print("Specification changed since last install, please run 'install' first to update your installation.")
            sys.exit(1)
    else:
        print("No previous installation detected. Please install packages first via 'source set-env.sh install'")
        sys.exit(1)


# Yell, if invalid arguments were supplied
if len(args) > 0:
    print("Unknown option(s)")


for cmd in cmds:
    full_cmd = ' && '.join((activate, cmd))
    if sys.platform in ["win32"]:
        print("You must use the _force_ option when creating a conda environment with this script")
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
