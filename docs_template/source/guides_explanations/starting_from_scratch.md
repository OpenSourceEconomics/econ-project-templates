Your general strategy should be one of **divide and conquer**. If you are not used to
thinking in computer science / software engineering terms, it will be hard to wrap your
head around all of the things that are going on. So write one bit of code at a time,
understand what is happening and why, and move on.

Assuming you have installed the template for the language(s) of your choice as described
in {ref}`template_setup`, my recommendation would be as follows.

1. Leave the examples in place.
1. Now add your own data and code bit by bit. **Append** the `task_xxx` files as
   necessary or create new ones.
1. Remove the build directory regularly to make sure you do not rely on outputs from
   tasks that do not exist any more — this is a frequent source of confusion.
1. Once you feel secure enough that you do not need the template files any more, delete
   all files carrying a `_template` in their names. You will also need to adjust the
   documents so they do not refer to figures and tables created by the template any
   more. Delete the build directory to make sure you do not rely on outputs from tasks
   that you removed.
