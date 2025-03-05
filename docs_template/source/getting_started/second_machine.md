If you already have the templates running on your computer and hosted on GitHub, it is
very easy to invite a collaborator or to use a second machine. Importantly you do not
need to create the template repository again.

On the second machine prepare the system and open a terminal on Mac/Linux or the
Powershell on Windows. Then type

```console
$ git clone <url_of_your_repository>
$ cd <name_of_your_project>
$ pixi global install pre-commit
$ pre-commit install
```

Now your're all set!
