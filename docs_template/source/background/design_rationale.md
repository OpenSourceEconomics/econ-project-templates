(design_rationale)=

## Design Rationale

The design of the project templates is guided by the following main thoughts:

1. **Separation of logical chunks:** A minimal requirement for a project to scale.
1. **Only execute required tasks, automatically:** Again required for scalability. It
   means that the machine needs to know what is meant by a "required task".
1. **Reuse of code and data instead of copying and pasting:** Else you will forget the
   copy & paste step at some point down the road. At best, this leads to errors; at
   worst, to misinterpreting the results.
1. **Be as language-agnostic as possible:** Make it easy to use the best tool for a
   particular task and to mix tools in a project.
1. **Separation of inputs and outputs:** Required to find your way around in a complex
   project.
