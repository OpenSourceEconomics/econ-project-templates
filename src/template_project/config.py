"""All the general configuration of the project."""

from pathlib import Path

SRC = Path(__file__).parent.resolve()
ROOT = SRC.joinpath("..", "..").resolve()

BLD = ROOT.joinpath("bld").resolve()


DOCUMENTS = ROOT.joinpath("documents").resolve()

TEMPLATE_GROUPS = ["marital_status", "highest_qualification"]
