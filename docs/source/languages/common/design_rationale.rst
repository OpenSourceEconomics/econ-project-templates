The design of the project templates is guided by the following main thoughts:

#. **Separation of logical chunks:** A minimal requirement for a project to scale.
#. **Only execute required tasks, automatically:** Again required for scalability. It
   means that the machine needs to know what is meant by a "required task".
#. **Re-use of code and data instead of copying and pasting:** Else you will forget the
   copy & paste step at some point down the road. At best, this leads to errors; at
   worst, to misinterpreting the results.

   .. comment:: What is the difference between re-use code and copy-paste?

#. **Be as language-agnostic as possible:** Make it easy to use the best tool for a
   particular task and to mix tools in a project.
#. **Separation of inputs and outputs:** Required to find your way around in a complex
   project.

I will not touch upon the last point until the section on how to organise the workflow
below. The remainder of this page introduces an example and a general concept of how to
think about the first four points.
