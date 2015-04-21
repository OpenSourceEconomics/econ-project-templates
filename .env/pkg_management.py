from pip.req import parse_requirements


class check_packages:
    """
        Helper class to check if package specs changed
    """

    def get_pip_pkgs(self):
        install_reqs = parse_requirements(".env/installed_pip_pkgs", session=False)
        pip_pkgs = [str(ir.req).split("==", 1)[0] for ir in install_reqs]
        return pip_pkgs

    def get_conda_pkgs(self):
        conda_pkgs = []
        for line in open('.env/installed_conda_pkgs', 'r'):
            li = line.strip()
            # Get rid of the comments
            if not li.startswith('#'):
                conda_pkgs.append(li.split()[0])
        return conda_pkgs

    def compare_package_sets(self, spec):
        packages_from_last_install = self.get_conda_pkgs() + self.get_pip_pkgs()
        if set(spec).issubset(set(packages_from_last_install)):
            return True
        else:
            return False
