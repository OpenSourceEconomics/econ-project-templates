Your general strategy should be one of **divide and conquer**. If you are not used to
thinking in computer science / software engineering terms, it will be hard to wrap your
head around all of the things that are going on. So move one bit of code at a time to
the template, understand what is happening and why, and move on.

1. Assuming that you use Git, first move all the code in the existing project to a
   subdirectory called old_code. Commit.
1. Now set up the templates.
1. Start with the data management code and move your data files to the spot where they
   belong under the new structure.
1. Move (the first steps of) your data management code to the folder under the
   templates. Modify the `task_xxx` files accordingly or create new ones.
1. Run `pytask`, adjusting the code for the errors you'll likely see.
1. Move on step-by-step like this.
1. Delete the example files and the corresponding sections of the `task_xxx` files / the
   entire files in case you created new ones.
