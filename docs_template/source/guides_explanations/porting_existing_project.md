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
   templates. Create new `task_...` files.
1. Run `pytask`, adjusting the code for the errors you'll likely see.
1. Move on step-by-step like this.
1. Once you feel secure enough that you do not need the template files any more, delete
   all files carrying a `_template` in their names. You will also need to adjust the
   documents so they do not refer to figures and tables created by the template any
   more. Delete the build directory to make sure you do not rely on outputs from tasks
   that you removed.
