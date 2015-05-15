"""Helper class for package management"""
from __future__ import print_function
import json
# Conditionally import pip as is might not be installed when using conda only
try:
    from pip.req import parse_requirements
    PIP_INSTALLED = True
except ImportError:
    PIP_INSTALLED = False
    print("Pip not installed, trying to update conda packages...")


class CheckPackages:
    """
        Helper class to check if package specs changed
    """

    def get_installed_spec(self):
        # Read specs from specification file
        JSON_DATA = open('.env/installed_spec.json')
        SPEC = json.load(JSON_DATA)
        JSON_DATA.close()
        return SPEC

    def get_pip_pkgs(self):
        if PIP_INSTALLED:
            install_reqs = parse_requirements('.env/installed_pip_pkgs', session=False)
            pip_pkgs = [str(ir.req).split("==", 1)[0] for ir in install_reqs]
            return pip_pkgs

    def get_conda_pkgs(self):
        conda_pkgs = []
        for line in open('.env/installed_conda_pkgs', 'r'):
            li = line.strip()
            # Get rid of the comments and read accordingly by line
            if not li.startswith('#'):
                conda_pkgs.append(li.split()[0])
        return conda_pkgs


    def packages_from_last_install(self):
        return self.get_conda_pkgs() + self.get_pip_pkgs()

    # handle the case where new packages were added by validiating subset property of installed pkgs
    def check_conda_additions(self, spec):
        # look at conda part of spec
        conda_spec = spec['conda-deps']
        diff = list(set(conda_spec) - (set(self.packages_from_last_install()) - set(spec['pip-deps'])))
        if len(diff) > 0:
            return diff

    # check whether packages were removed by comparing to last snapshot of installed spec
    def check_conda_removals(self, spec):
        conda_spec = spec['conda-deps']
        installed_conda_spec = self.get_installed_spec()['conda-deps']
        diff = list(set(installed_conda_spec) - set(conda_spec))
        if len(diff) > 0:
            return diff


    # handle the case where new packages were added by validiating subset property of installed pkgs
    def check_pip_additions(self, spec):
        # look at pip part of spec
        pip_spec = spec['pip-deps']
        diff = list(set(pip_spec) - (set(self.packages_from_last_install()) - set(spec['conda-deps'])))
        if len(diff) > 0:
            return diff

    # check whether packages were removed by comparing to last snapshot of installed spec
    def check_pip_removals(self, spec):
        pip_spec = spec['pip-deps']
        installed_pip_spec = self.get_installed_spec()['pip-deps']
        diff = list(set(installed_pip_spec) - set(pip_spec))
        if len(diff) > 0:
            return diff


    # use comp methods above to return a dict with "pip/conda", "install/remove" and pkg_names
    def compare_package_sets(self, spec):
        diff = {}

        #make nicer syntax-wise (map?)
        if self.check_conda_additions(spec):
            diff["conda install"] = self.check_conda_additions(spec)

        if self.check_conda_removals(spec):
            diff["conda remove"] = self.check_conda_removals(spec)

        if self.check_pip_additions(spec):
            diff["pip install"] = self.check_pip_additions(spec)

        if self.check_pip_removals(spec):
            diff["pip uninstall"] = self.check_pip_removals(spec)

        return diff