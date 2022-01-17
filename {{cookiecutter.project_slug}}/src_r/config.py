from pathlib import Path

ROOT = Path(__file__).parent.parent.resolve()
SRC = Path(__file__).parent.resolve()
BLD = SRC.joinpath("..", "bld").resolve()
