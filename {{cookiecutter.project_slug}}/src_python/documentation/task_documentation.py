import pytask
from pathlib import Path
import subprocess
from src.config import BLD, SRC


@pytask.mark.depends_on(
    list(Path(__file__).parent.glob("*.rst")) + [SRC / "documentation" / "conf.py"]
)
@pytask.mark.parametrize(
    "builder, produces",
    [
        ("latexpdf", BLD / "documentation" / "latex" / "project_documentation.pdf"),
        ("html", (BLD / "documentation" / "html").rglob("*.*")),
    ],
)
def task_build_documentation(builder, produces):
    subprocess.run(
        [
            "sphinx-build",
            "-M",
            builder,
            SRC.joinpath("documentation").as_posix(),
            BLD.joinpath("documentation").as_posix(),
        ]
    )
