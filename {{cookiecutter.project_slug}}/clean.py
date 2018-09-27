import os

import click

CONTEXT_SETTINGS = {"help_option_names": ["-h", "--help"]}


@click.command(context_settings=CONTEXT_SETTINGS)
@click.option("--force", is_flag=True, default=False, help="Delete files")
def cli(force):
    """This program performs a preconfigured `git clean` call which is a dry
    run by default. Use the `force` flag if you are really sure about removing
    files.

    Use the ``-e`` flag to exclude files.

    """
    if force:
        os.system("git clean -f -x -d -e *.dta src")
    else:
        os.system("git clean -n -x -d -e *.dta src")


if __name__ == "__main__":
    cli()
