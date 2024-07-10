"""All the general configuration of the project."""

from pathlib import Path

SRC = Path(__file__).parent.resolve()
BLD = SRC.joinpath("..", "..", "bld").resolve()

ROOT = SRC.joinpath("..", "..").resolve()

TESTS = ROOT.joinpath("tests").resolve()
DOCUMENTS = ROOT.joinpath("documents").resolve()

TEMPLATE_GROUPS = ["marital_status", "qualification"]