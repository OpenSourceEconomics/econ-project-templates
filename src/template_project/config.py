"""All the general configuration of the project."""

from pathlib import Path

SRC = Path(__file__).parent.resolve()
BLD = SRC.joinpath("..", "..", "bld").resolve()

ROOT = SRC.joinpath("..", "..").resolve()

TEST_DIR = ROOT.joinpath("tests").resolve()
PAPER_DIR = ROOT.joinpath("paper").resolve()
DOCS_DIR = ROOT.joinpath("docs").resolve()

GROUPS = ["marital_status", "qualification"]
