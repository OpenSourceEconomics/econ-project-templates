Your general strategy should be one of **divide and conquer**. If you are not used to
thinking in computer science / software engineering terms, it will be hard to wrap your
head around a lot of the things going on. So write one bit of code at a time, understand
what is going on, and move on.

Assuming you have installed the template for the language(s) of your choice as described
in :ref:`cookiecutter_dialogue`, my recommendation would be as follows.

#. Leave the examples in place.
#. Now add your own data and code bit by bit. **Append** the `task_xxx` files as
   necessary or create new ones.
#. Remove the build directory regularly to make sure you do not rely on outputs from
   tasks that do not exist anymore — this is a frequent source of confusion.
#. Once you got the hang of how things work, remove the examples (both the data files
   and the code in the `task_xxx` files). Also remove the build directory.
