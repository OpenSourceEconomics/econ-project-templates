from latexslides import TextSlide


project_root = r"""
\node (1) [
    rectangle split,
    rectangle split parts=10,
    draw,
    text width=4.50cm
]
{
    \nodepart{one}
        \begin{small}
            project\_root
        \end{small}
    \nodepart{two}
        waf
    \nodepart{three}
        wscript
    \nodepart{four}
        [bld]
    \nodepart{five}
        [project documentation]
    \nodepart{six}
        [project documentation.pdf]
    \nodepart{seven}
        [research\_paper.pdf]
    \nodepart{eight}
        [research\_pres\_30min.pdf]
    \nodepart{nine}
        [research\_pres\_90min.pdf]
    \nodepart{ten}
        src
};
"""


bld = r"""
\node (2) [
    rectangle split,
    rectangle split parts=3,
    draw,
    text width=2.50cm,
    right=of 1
]
{
    \nodepart{one}
        \begin{small}
            bld
        \end{small}
    \nodepart{two}
        src
    \nodepart{three}
        out
};
"""


src = r"""
\node (3) [
    rectangle split,
    rectangle split parts=11,
    draw,
    text width=2.50cm,
    below=of 2
]
{
    \nodepart{one}
        \begin{small}
            src
        \end{small}
    \nodepart{two}
        wscript
    \nodepart{three}
        documentation
    \nodepart{four}
        library
    \nodepart{five}
        manual\_input
    \nodepart{six}
        models
    \nodepart{seven}
        original\_data
    \nodepart{eight}
        data\_management
    \nodepart{nine}
        analysis
    \nodepart{ten}
        final
    \nodepart{eleven}
        paper
};
"""

out = r"""
\node (4) [
    rectangle split,
    rectangle split parts=6,
    draw,
    text width=2.50cm,
    right=of 2
]
{
    \nodepart{one}
        \begin{small}
            out
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


manual_input = r"""
\node (5) [
    rectangle split,
    rectangle split parts=5,
    draw,
    text width=2.50cm,
    right=of 3
]
{
    \nodepart{one}
        \begin{small}
            manual\_input
        \end{small}
    \nodepart{two}
        wscript
    \nodepart{three}
        some\_figure.pdf
    \nodepart{four}
        some\_table.tex
    \nodepart{five}
        etc.
};
"""


library = r"""
\node (6) [
    rectangle split,
    rectangle split parts=5,
    draw,
    text width=2.50cm,
    right=of 3
]
{
    \nodepart{one}
        \begin{small}
            library
        \end{small}
    \nodepart{two}
        wscript
    \nodepart{three}
        stata
    \nodepart{four}
        python
    \nodepart{five}
        etc.
};
"""

stata = r"""
\node (7) [
    rectangle split,
    rectangle split parts=3,
    draw,
    text width=2.50cm,
    right=of 6
]
{
    \nodepart{one}
        \begin{small}
            stata
        \end{small}
    \nodepart{two}
        ado\_ext
    \nodepart{three}
        ado\_local
};
"""


models = r"""
\node (8) [
    rectangle split,
    rectangle split parts=5,
    draw,
    text width=2.5cm,
    right= of 3
]
{
    \nodepart{one}
        \begin{small}
            models
        \end{small}
    \nodepart{two}
        wscript
    \nodepart{three}
        baseline.json
    \nodepart{four}
        robust\_unobs\_het.json
    \nodepart{five}
        etc.
};
"""


original_data = r"""
\node (9) [
    rectangle split,
    rectangle split parts=4,
    draw,
    text width=2.50cm,
    right=of 3
]
{
    \nodepart{one}
        \begin{small}
            original\_data
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
    draw,
    text width=3.0cm,
    right=of 3
]
{
    \nodepart{one}
        \begin{small}
            data\_management
        \end{small}
    \nodepart{two}
        wscript
    \nodepart{three}
        clean\_dataset\_1.do
    \nodepart{four}
        clean\_dataset\_2.do
    \nodepart{five}
        etc.
};
"""


analysis = r"""
\node (11) [
    rectangle split,
    rectangle split parts=6,
    draw,
    text width=2.5cm,
    right=of 3
]
{
    \nodepart{one}
        \begin{small}
            analysis
        \end{small}
    \nodepart{two}
        wscript
    \nodepart{three}
        descriptives.do
    \nodepart{four}
        regressions\_intuition.do
    \nodepart{five}
        serious\_approach.py
    \nodepart{six}
        etc.
};
"""

final = r"""
\node (12) [
    rectangle split,
    rectangle split parts=5,
    draw,
    text width=2.5cm,
    right=of 3
]
{
    \nodepart{one}
        \begin{small}
            final
        \end{small}
    \nodepart{two}
        wscript
    \nodepart{three}
        create\_tables.py
    \nodepart{four}
        simple\_simulations.py
    \nodepart{five}
        etc.
};
"""


paper = r"""
\node (13) [
    rectangle split,
    rectangle split parts=9,
    draw,
    text width=3cm,
    right=of 3
]
{
    \nodepart{one}
        \begin{small}
            paper
        \end{small}
    \nodepart{two}
        wscript
    \nodepart{three}
        bib
    \nodepart{four}
        formulas
    \nodepart{five}
        reserch\_paper.tex
    \nodepart{six}
        research\_pres\_30min.tex
    \nodepart{seven}
        research\_pres\_90min.tex
    \nodepart{eight}
        all\_tables.tex
    \nodepart{nine}
        all\_figures.tex
};
"""


formulas = r"""
\node (14) [
    rectangle split,
    rectangle split parts=4,
    draw,
    text width=2.50cm,
    right=of 13
]
{
    \nodepart{one}
        \begin{small}
            formulas
        \end{small}
    \nodepart{two}
        utility\_function.tex
    \nodepart{three}
        budget\_constraint.tex
    \nodepart{four}
        etc.
};
"""


documentation = r"""
\node (15) [
    rectangle split,
    rectangle split parts=11,
    draw,
    text width=3cm,
    right = of 3
]
{
    \nodepart{one}
        \begin{small}
            documentation
        \end{small}
    \nodepart{two}
        wscript
    \nodepart{three}
        conf.py
    \nodepart{four}
        index.rst
    \nodepart{five}
        introduction.rst
    \nodepart{six}
        data\_management.rst
    \nodepart{seven}
        analysis.rst
    \nodepart{eight}
        final.rst
    \nodepart{nine}
        paper.rst
    \nodepart{ten}
        library.rst
    \nodepart{eleven}
        models.rst
};"""


project_hierarchies = {}

project_hierarchies['big_pic'] = TextSlide(
    title=r"""\color{gray}Project hierarchies \\
\color{structure.fg} The highest level""",
    text=r"""
\begin{center}
    \begin{tiny}
    \resizebox{10cm}{!}{
        \begin{tikzpicture}[node distance=1cm, auto]
"""
    + project_root
    + bld
    + src
    + out
    + r"""
            \draw[-, out=10, in=170] (1) to (2);
            \draw[-, out=-13, in=152] (2) to (4);
            \draw[-, out=325, in=130] (1) to (3);
        \end{tikzpicture}}
    \end{tiny}
\end{center}
"""
)

project_hierarchies['original_data'] = TextSlide(
    title=r"""\color{gray}Project hierarchies \\
\color{structure.fg} Original data""",
    text=r"""
\begin{center}
    \begin{tiny}
        \begin{tikzpicture}[node distance=1cm, auto]
    """
    + src
    + original_data
    + r"""
            \draw[-, out=-14, in=160] (3) to (9);
        \end{tikzpicture}
    \end{tiny}
\end{center}
"""
)

project_hierarchies['library'] = TextSlide(
    title=r"""\color{gray}Project hierarchies \\
\color{structure.fg} The code library""",
    text=r"""
\begin{center}
    \begin{tiny}
        \begin{tikzpicture}[node distance=1cm, auto]
    """
    + src
    + library
    + stata
    + r"""
            \draw[-, out=25, in=155] (3) to (6);
            \draw[-, out=-3, in=167] (6) to (7);
        \end{tikzpicture}
    \end{tiny}
\end{center}
"""
)

project_hierarchies['models'] = TextSlide(
    title=r"""\color{gray}Project hierarchies \\
\color{structure.fg} Model specifications""",
    text=r"""
\begin{center}
    \begin{tiny}
        \begin{tikzpicture}[node distance=1cm, auto]
    """
    + src
    + models
    + r"""
            \draw[-, out=0, in=156] (3) to (8);
        \end{tikzpicture}
    \end{tiny}
\end{center}
"""
)

project_hierarchies['data_management'] = TextSlide(
    title=r"""\color{gray}Project hierarchies \\
\color{structure.fg} Step 1: Data management""",
    text=r"""
\begin{center}
    \begin{tiny}
        \begin{tikzpicture}[node distance=1cm, auto]
    """
    + src
    + data_management
    + r"""
            \draw[-, out=-26, in=157] (3) to (10);
        \end{tikzpicture}
    \end{tiny}
\end{center}
"""
)

project_hierarchies['analysis'] = TextSlide(
    title=r"""\color{gray}Project hierarchies \\
\color{structure.fg} Step 2: Model estimation / simulation""",
    text=r"""
\begin{center}
    \begin{tiny}
        \begin{tikzpicture}[node distance=1cm, auto]
    """
    + src
    + analysis
    + r"""
            \draw[-, out=-39, in=148] (3) to (11);
        \end{tikzpicture}
    \end{tiny}
\end{center}
"""
)

project_hierarchies['final'] = TextSlide(
    title=r"""\color{gray}Project hierarchies \\
\color{structure.fg} Step 3: Visualisation and results formatting""",
    text=r"""
\begin{center}
    \begin{tiny}
        \begin{tikzpicture}[node distance=1cm, auto]
    """
    + src
    + final
    + r"""
            \draw[-, out=-46, in=152] (3) to (12);
        \end{tikzpicture}
    \end{tiny}
\end{center}
"""
)

project_hierarchies['manual_input'] = TextSlide(
    title=r"""\color{gray}Project hierarchies \\
\color{structure.fg} Aside: Manual figures and tables""",
    text=r"""
\begin{center}
    Just copy everything to tables/figures directories.\\[2ex]
    \begin{tiny}
        \begin{tikzpicture}[node distance=1cm, auto]
    """
    + src
    + manual_input
    + r"""
            \draw[-, out=10, in=155] (3) to (5);
        \end{tikzpicture}
    \end{tiny}
\end{center}
"""
)

project_hierarchies['paper'] = TextSlide(
    title=r"""\color{gray}Project hierarchies \\
\color{structure.fg} Step 4: Paper and presentations""",
    text=r"""
\begin{center}
    \begin{tiny}
        \begin{tikzpicture}[node distance=1cm, auto]
    """
    + src
    + paper
    + formulas
    + r"""
            \draw[-, out=-52, in=140] (3) to (13);
            \draw[-, out=10, in=160] (13) to (14);
        \end{tikzpicture}
    \end{tiny}
\end{center}
"""
)


structure_of_the_documentation_directory = TextSlide(
    title=r"Structure of the documentation directory",
    text=r"""
\begin{center}
    \begin{tiny}
        \begin{tikzpicture}
            \node (2) {};
"""
    + src
    + documentation
    + r"""
            \draw[-, out=35, in=135] (3) to (15);
        \end{tikzpicture}
    \end{tiny}
\end{center}
"""
)
