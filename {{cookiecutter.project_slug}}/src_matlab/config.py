from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SRC = Path(__file__).resolve().parent
BLD = SRC.joinpath("..", "bld").resolve()
