import os

import click


def cli():
    """Starts reformatting with isort and black.

    The order is currently important as black does not insert commas to single
    line from imports. Should be fixed in the next version and then we can also
    include flake8-isort to tox.

    """
    click.echo("Start reformatting files with isort.")
    os.system("isort . -rc")
    click.echo("Start reformatting files with black.")
    os.system("black .")
    click.echo("Start reformatting files with isort again for commas.")
    os.system("isort . -rc")
    click.echo("End reformatting files.")


if __name__ == "__main__":
    cli()
