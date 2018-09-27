import hashlib

from pathlib import Path
from typing import Dict, List

import click
import requests

from tqdm import tqdm

CONTEXT_SETTINGS = {"help_option_names": ["-h", "--help"]}

FILES: Dict[str, List[str]] = {}
"""Dict[str, List[str]]: Contains file information.

The keys of the dictionary are the file names on the disk. The values are a
list containing urls in the first and file hashes in the second position.

The has can be computed in Powershell with ``Get-FileHash <file>``. Notice
that Powershell returns uppercase letters and Python uses lowercase.

"""

DOWNLOAD_FOLDER = Path("src", "data", "downloaded")


def downloader(file: Path, url: str, resume_byte_pos: int = None):
    """Download url in ``URLS[position]`` to disk with possible resumption.

    Parameters
    ----------
    file : str
        Path of file on disk
    url : str
        URL of file
    resume_byte_pos: int
        Position of byte from where to resume the download

    """
    # Get size of file
    r = requests.head(url)
    file_size = int(r.headers.get("content-length", 0))

    # Append information to resume download at specific byte position
    # to header
    resume_header = (
        {"Range": f"bytes={resume_byte_pos}-"} if resume_byte_pos else None
    )

    # Establish connection
    r = requests.get(url, stream=True, headers=resume_header)

    # Set configuration
    block_size = 1024
    initial_pos = resume_byte_pos if resume_byte_pos else 0
    mode = "ab" if resume_byte_pos else "wb"

    with open(file, mode) as f:
        with tqdm(
            total=file_size,
            unit="B",
            unit_scale=True,
            unit_divisor=1024,
            desc=file.name,
            initial=initial_pos,
            ascii=True,
            miniters=1,
        ) as pbar:
            for chunk in r.iter_content(32 * block_size):
                f.write(chunk)
                pbar.update(len(chunk))


def download_file(filename: str, url: str):
    """Execute the correct download operation.

    Depending on the size of the file online and offline, resume the
    download if the file offline is smaller than online.

    Parameters
    ----------
    filename : str
        Name of file
    url : str
        URL of file

    """
    # Establish connection to header of file
    r = requests.head(url)

    # Get filesize of online and offline file
    file_size_online = int(r.headers.get("content-length", 0))
    file = DOWNLOAD_FOLDER / filename

    if file.exists():
        file_size_offline = file.stat().st_size

        if file_size_online != file_size_offline:
            click.echo(f"File {file} is incomplete. Resume download.")
            downloader(file, url, file_size_offline)
        else:
            click.echo(f"File {file} is complete. Skip download.")
            pass
    else:
        click.echo(f"File {file} does not exist. Start download.")
        downloader(file, url)


def validate_file(filename: str, hash_value: str = None):
    """Validate a given file with its hash.

    The downloaded file is compared with a hash to validate the download
    procedure.

    Parameters
    ----------
    file_name : str
        Name of file
    hash_value : str
        Hash value of file

    """
    if not hash_value:
        click.echo(f"File {filename} has no hash.")
        return 0

    file = DOWNLOAD_FOLDER / filename

    sha = hashlib.sha256()
    with open(file, "rb") as f:
        while True:
            chunk = f.read(1000 * 1000)  # 1MB so that memory is not exhausted
            if not chunk:
                break
            sha.update(chunk)
    try:
        assert sha.hexdigest() == hash_value
    except AssertionError:
        click.echo(
            f"File {filename} is corrupt. "
            "Delete it manually and restart the program."
        )
    else:
        click.echo(f"File {filename} is validated.")


@click.group(context_settings=CONTEXT_SETTINGS, chain=True)
def cli():
    """Program for preparing the data for the project.

    \b
    The program covers three steps:
    1. Downloading data.
    2. Validating the downloaded data with hash values.

    To download and validate a file, add file name, url and hash to `FILES`.

    """
    pass


@cli.command()
def download():
    """Download files specified in ``URLS``."""
    click.echo("\n### Start downloading required files.\n")
    for filename, (url, _) in FILES.items():
        download_file(filename, url)
    click.echo("\n### End\n")


@cli.command()
def validate():
    """Validate downloads with hashes in ``HASHES``."""
    click.echo("### Start validating required files.\n")
    for filename, (_, hash_value) in FILES.items():
        validate_file(filename, hash_value)
    click.echo("\n### End\n")


if __name__ == "__main__":
    cli()
