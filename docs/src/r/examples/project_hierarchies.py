import sys

project_root = r"""
        \node (1) [
            rectangle split,
            rectangle split parts=10,
            rectangle split part fill={
                blue!15,
                brown!25,
                brown!25,
                brown!25,
                brown!25,
                brown!25,
                blue!15,
                blue!15,
                blue!15,
                blue!15
            },
            draw,
            text width=4.50cm
        ]
        {
            \nodepart{one}
                \begin{small}
                    \textbf{Project Root}
                \end{small}
            \nodepart{two}
                bld
            \nodepart{three}
                project documentation
            \nodepart{four}
                project documentation.pdf
            \nodepart{five}
                research\_paper.pdf
            \nodepart{six}
                research\_pres\_30min.pdf
            \nodepart{seven}
                src
            \nodepart{eight}
                waf.py
            \nodepart{nine}
                wscript
            \nodepart{ten}
                .mywaflib
        };
"""


bld = r"""
        \node (2) [
            rectangle split,
            rectangle split parts=3,
            rectangle split part fill={
                brown!25,
                brown!25,
                brown!25
            },
            draw,
            text width=2.50cm,
            right=of 1
        ]
        {
            \nodepart{one}
                \begin{small}
                    \textbf{bld}
                \end{small}
            \nodepart{two}
                src
            \nodepart{three}
                out
        };
"""

_src_body = r"""
        {
            \nodepart{one}
                \begin{small}
                    \textbf{src}
                \end{small}
            \nodepart{two}
                analysis
            \nodepart{three}
                data\_management
            \nodepart{four}
                documentation
            \nodepart{five}
                final
            \nodepart{six}
                library
            \nodepart{seven}
                model\_code
            \nodepart{eight}
                model\_specs
            \nodepart{nine}
                original\_data
            \nodepart{ten}
                paper
            \nodepart{eleven}
                wscript
        };
"""

src_below_2 = (
    r"""
        \node (3) [
            rectangle split,
            rectangle split parts=11,
            rectangle split part fill={
                blue!15,
                blue!15,
                blue!15,
                blue!15,
                blue!15,
                blue!15,
                blue!15,
                blue!15,
                blue!15,
                blue!15,
                blue!15
            },
            draw,
            text width=2.50cm,
            below=of 2
        ]"""
    + _src_body
)

src_no_loc = (
    r"""
        \node (3) [
            rectangle split,
            rectangle split parts=11,
            rectangle split part fill={
                blue!15,
                blue!15,
                blue!15,
                blue!15,
                blue!15,
                blue!15,
                blue!15,
                blue!15,
                blue!15,
                blue!15,
                blue!15
            },
            draw,
            text width=2.50cm
        ]"""
    + _src_body
)

src_left_of_8 = (
    r"""
        \node (3) [
            rectangle split,
            rectangle split parts=11,
            rectangle split part fill={
                blue!15,
                blue!15,
                blue!15,
                blue!15,
                blue!15,
                blue!15,
                blue!15,
                blue!15,
                blue!15,
                blue!15,
                blue!15
            },
            draw,
            text width=2.50cm,
            left=of 8
        ]"""
    + _src_body
)

out = r"""
        \node (4) [
            rectangle split,
            rectangle split parts=6,
            rectangle split part fill={
                brown!25,
                brown!25,
                brown!25,
                brown!25,
                brown!25,
                brown!25
            },
            draw,
            text width=2.50cm,
            right=of 2
        ]
        {
            \nodepart{one}
                \begin{small}
                    \textbf{out}
                \end{small}
            \nodepart{two}
                data
            \nodepart{three}
                analysis
            \nodepart{four}
                final
            \nodepart{five}
                figures
            \nodepart{six}
                tables
        };
"""


library = r"""
        \node (6) [
            rectangle split,
            rectangle split parts=5,
            rectangle split part fill={
                blue!15,
                blue!15,
                blue!15,
                blue!15,
                blue!15,
            },
            draw,
            text width=2.50cm,
            right=of 3
        ]
        {
            \nodepart{one}
                \begin{small}
                    \textbf{library}
                \end{small}
            \nodepart{two}
                wscript
            \nodepart{five}
                etc.
        };
"""


model_code = r"""
        \node (8) [
            rectangle split,
            rectangle split parts=3,
            rectangle split part fill={
                blue!15,
                blue!15,
                blue!15,
            },
            draw,
            text width=2.5cm
        ]
        {
            \nodepart{one}
                \begin{small}
                    \textbf{model\_code}
                \end{small}
            \nodepart{two}
                \_\_init.py\_\_
            \nodepart{three}
                agent.py
        };
"""


model_specs = r"""
        \node (222) [
            rectangle split,
            rectangle split parts=3,
            rectangle split part fill={
                blue!15,
                blue!15,
                blue!15,
            },
            draw,
            text width=2.5cm,
            below= of 8
        ]
        {
            \nodepart{one}
                \begin{small}
                    \textbf{model\_specs}
                \end{small}
            \nodepart{two}
                baseline.json
            \nodepart{three}
                max\_moves\_2.json
        };
"""


original_data = r"""
        \node (9) [
            rectangle split,
            rectangle split parts=4,
            rectangle split part fill={
                blue!15,
                blue!15,
                blue!15,
                blue!15,
            },
            draw,
            text width=2.50cm,
            right=of 3
        ]
        {
            \nodepart{one}
                \begin{small}
                    \textbf{original\_data}
                \end{small}
            \nodepart{two}
                dataset\_1
            \nodepart{three}
                dataset\_2
            \nodepart{four}
                documentation
        };
"""


data_management = r"""
        \node (10) [
            rectangle split,
            rectangle split parts=5,
            rectangle split part fill={
                blue!15,
                blue!15,
                blue!15,
                blue!15,
                blue!15,
            },
            draw,
            text width=3.0cm,
            right=of 3
        ]
        {
            \nodepart{one}
                \begin{small}
                    \textbf{data\_management}
                \end{small}
            \nodepart{two}
                \_\_init.py\_\_
            \nodepart{three}
                get\_simulation\_draws.py
            \nodepart{four}
                wscript
        };
"""


analysis = r"""
        \node (11) [
            rectangle split,
            rectangle split parts=4,
            rectangle split part fill={
                blue!15,
                blue!15,
                blue!15,
                blue!15,
            },
            draw,
            text width=2.5cm,
            above=of 8
        ]
        {
            \nodepart{one}
                \begin{small}
                    \textbf{analysis}
                \end{small}
            \nodepart{two}
                \_\_init.py\_\_
            \nodepart{three}
                schelling.py
            \nodepart{four}
                wscript
        };
"""

final = r"""
        \node (12) [
            rectangle split,
            rectangle split parts=4,
            rectangle split part fill={
                blue!15,
                blue!15,
                blue!15,
                blue!15,
            },
            draw,
            text width=2.5cm,
            right=of 3
        ]
        {
            \nodepart{one}
                \begin{small}
                    \textbf{final}
                \end{small}
            \nodepart{two}
                \_\_init.py\_\_
            \nodepart{three}
                plot\_locations.py
            \nodepart{four}
                wscript
        };
"""


paper = r"""
        \node (13) [
            rectangle split,
            rectangle split parts=6,
            rectangle split part fill={
                blue!15,
                blue!15,
                blue!15,
                blue!15,
                blue!15,
                blue!15,
            },
            draw,
            text width=3cm,
            right=of 3
        ]
        {
            \nodepart{one}
                \begin{small}
                    \textbf{paper}
                \end{small}
            \nodepart{two}
                formulas
            \nodepart{three}
                refs.bib
            \nodepart{four}
                reserch\_paper.tex
            \nodepart{five}
                research\_pres\_30min.tex
            \nodepart{six}
                wscript
        };
"""


formulas = r"""
        \node (14) [
            rectangle split,
            rectangle split parts=2,
            rectangle split part fill={
                blue!15,
                blue!15,
            },
            draw,
            text width=2.50cm,
            right=of 13
        ]
        {
            \nodepart{one}
                \begin{small}
                    \textbf{formulas}
                \end{small}
            \nodepart{two}
                decision\_rule.tex
        };
"""


documentation = r"""
        \node (15) [
            rectangle split,
            rectangle split parts=11,
            rectangle split part fill={
                blue!15,
                blue!15,
                blue!15,
                blue!15,
                blue!15,
                blue!15,
                blue!15,
                blue!15,
                blue!15,
                blue!15,
                blue!15
            },
            draw,
            text width=3cm,
            right = of 3
        ]
        {
            \nodepart{one}
                \begin{small}
                    \textbf{documentation}
                \end{small}
            \nodepart{two}
                analysis.rst
            \nodepart{three}
                conf.py
            \nodepart{four}
                data\_management.rst
            \nodepart{five}
                final.rst
            \nodepart{six}
                index.rst
            \nodepart{seven}
                introduction.rst
            \nodepart{eight}
                library.rst
            \nodepart{nine}
                model\_code.rst
            \nodepart{ten}
                model\_specs.rst
            \nodepart{eleven}
                wscript
        };
"""


project_hierarchies = {}

project_hierarchies["big_pic"] = (
    r"""
\begin{tiny}
    \resizebox{10cm}{!}{\begin{tikzpicture}[node distance=1cm, auto]"""
    + project_root
    + bld
    + src_below_2
    + out
    + r"""
        \draw[-, out=22, in=170] (1) to (2);
        \draw[-, out=-13, in=152] (2) to (4);
        \draw[-, out=-13, in=133] (1) to (3);
    \end{tikzpicture}}
\end{tiny}
"""
)

project_hierarchies["original_data"] = (
    r"""
\begin{tiny}
    \begin{tikzpicture}[node distance=1cm, auto]"""
    + src_no_loc
    + original_data
    + r"""
        \draw[-, out=-14, in=160] (3) to (9);
    \end{tikzpicture}
\end{tiny}
"""
)

project_hierarchies["library"] = (
    r"""
\begin{tiny}
    \begin{tikzpicture}[node distance=1cm, auto]"""
    + src_no_loc
    + library
    + r"""
        \draw[-, out=25, in=155] (3) to (6);
        \draw[-, out=-3, in=167] (6) to (7);
    \end{tikzpicture}
\end{tiny}
"""
)

project_hierarchies["data_management"] = (
    r"""
\begin{tiny}
    \begin{tikzpicture}[node distance=1cm, auto]"""
    + src_no_loc
    + data_management
    + r"""
        \draw[-, out=-26, in=157] (3) to (10);
    \end{tikzpicture}
\end{tiny}
"""
)

project_hierarchies["analysis"] = (
    r"""
\begin{tiny}
    \begin{tikzpicture}[node distance=1cm, auto]"""
    + model_code
    + analysis
    + model_specs
    + src_left_of_8
    + r"""
        \draw[-, out=40, in=160] (3) to (11);
        \draw[-, out=-12, in=170] (3) to (8);
        \draw[-, out=-22, in=170] (3) to (222);
    \end{tikzpicture}
\end{tiny}
"""
)

project_hierarchies["final"] = (
    r"""
\begin{tiny}
    \begin{tikzpicture}[node distance=1cm, auto]"""
    + src_no_loc
    + final
    + r"""
        \draw[-, out=-46, in=152] (3) to (12);
    \end{tikzpicture}
\end{tiny}
"""
)


project_hierarchies["paper"] = (
    r"""
\begin{tiny}
    \begin{tikzpicture}[node distance=1cm, auto]"""
    + src_no_loc
    + paper
    + formulas
    + r"""
        \draw[-, out=-52, in=140] (3) to (13);
        \draw[-, out=10, in=160] (13) to (14);
    \end{tikzpicture}
\end{tiny}
"""
)


structure_of_the_documentation_directory = (
    r"""
\begin{tiny}
    \begin{tikzpicture}
        \node (2) {};"""
    + src_no_loc
    + documentation
    + r"""
        \draw[-, out=35, in=135] (3) to (15);
    \end{tikzpicture}
\end{tiny}
"""
)


prelude = r"""\documentclass[convert={density=300,size=1080x800,outext=.png}]{standalone}
\usepackage{tkz-graph}
\usetikzlibrary{arrows,positioning,shapes,shapes.multipart,patterns,mindmap,shadows}
\usepackage{xcolor}
\usepackage{helvet}
\renewcommand{\familydefault}{\sfdefault}

\begin{document}
"""

end_doc = """

\end{document}
"""


if __name__ == "__main__":
    key = sys.argv[1]
    with open("src/r/examples/project_hierarchies_{}.tex".format(key), "w") as f:
        f.write(prelude)
        f.write(project_hierarchies[key])
        f.write(end_doc)
