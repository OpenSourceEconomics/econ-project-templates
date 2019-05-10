import functools
from pathlib import Path

import graphviz as gv
from waflib import Utils
from waflib.Node import Nod3


graph = functools.partial(gv.Graph, format="png")
digraph = functools.partial(gv.Digraph, format="png")

styles = {
    "graph": {
        "label": "DAG of Project",
        "fontsize": "48",
        "fontcolor": "white",
        "bgcolor": "#333333",
        "rankdir": "LR",
    },
    "nodes": {
        "fontname": "Helvetica",
        "shape": "hexagon",
        "fontcolor": "white",
        "color": "white",
        "style": "filled",
        "fillcolor": "#006699",
    },
    "edges": {
        "style": "dashed",
        "color": "white",
        "arrowhead": "open",
        "fontname": "Courier",
        "fontsize": "12",
        "fontcolor": "white",
    },
}


def apply_styles(graph, styles):
    graph.graph_attr.update(("graph" in styles and styles["graph"]) or {})
    graph.node_attr.update(("nodes" in styles and styles["nodes"]) or {})
    graph.edge_attr.update(("edges" in styles and styles["edges"]) or {})
    return graph


def get_name(str_or_nod):
    try:
        out = Path(str_or_nod).name
    except TypeError:
        out = Path(str_or_nod.abspath()).name
    return out


def add_nodes(graph, nodes):
    for n in nodes:
        if isinstance(n, tuple):
            graph.node(n[0], **n[1])
        else:
            graph.node(n)
    return graph


def add_edges(graph, edges):
    for e in edges:
        if isinstance(e[0], tuple):
            graph.edge(*e[0], **e[1])
        else:
            graph.edge(*e)
    return graph


def make_dot_file(ctx):
    # Lazy load module
    from bld.project_paths import project_paths_join as ppj

    # Select task groups, drop first which are project paths
    groups = [group for group in ctx.groups if len(group) != 0]
    groups = groups[1:]
    # Create
    dag = digraph()
    for group in groups:
        for taskgen in group:
            name = taskgen.get_name()

            add_nodes(dag, [name])
            # Add dependencies
            deps = Utils.to_list(getattr(taskgen, "deps", []))
            for dep in deps:
                d = get_name(dep)
                add_nodes(dag, [d])
                add_edges(dag, [(d, name)])

            # Add sources
            sources = Utils.to_list(getattr(taskgen, "source", []))
            for source in sources:
                s = get_name(source)
                add_nodes(dag, [s])
                add_edges(dag, [(s, name)])

            # Write targets
            targets = Utils.to_list(getattr(taskgen, "target", []))
            for target in targets:
                t = get_name(target)
                add_nodes(dag, [t])
                add_edges(dag, [(name, t)])

    dag = apply_styles(dag, styles)

    # Save DAG
    dag.render(ppj("OUT_FIGURES", "dag"))


def make_project_dependency_graph(ctx):
    make_dot_file(ctx)
