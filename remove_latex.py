with open(r"{{cookiecutter.project_slug}}/wscript") as f:
    lines = f.read()

out = lines.replace('ctx.load("sphinx_build")', "")
out = out.replace(r'ctx.load("biber")', "")
out = out.replace(r'ctx.load("tex")', "")

with open(r"{{cookiecutter.project_slug}}/wscript", "w") as f:
    f.write(out)

for folder in ["julia", "matlab", "stata", "r", "python"]:
    with open(r"{{cookiecutter.project_slug}}" + f"/src_{folder}/wscript") as f:
        lines = f.read()
    out = lines.replace('ctx.recurse("paper")', "")
    out = out.replace('ctx.recurse("documentation")', "")

    with open(
        r"{{cookiecutter.project_slug}}}/src_{}/wscript".format(folder), "w"
    ) as f:
        f.write(out)
