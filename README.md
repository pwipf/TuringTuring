# TuringTuring
A simple Turing Machine simulator using the programming language TURING.

# What?
This is a small project (1 file) created for a school assignment.

Turing is a programming language, named for Alan Turing of course, often described as similar to Pascal. I have not spent much time with Pascal, but I believe Turing is a little higher level, with support for things Pascal cannot do, like dynamic arrays. Turing was started in 1982 and it seems to be in some ways a response to C. There is much emphasis on safety and security, catching bugs, and not doing unexpected or uncontrolled things.

# Purpose
To learn the Turing programming language, and also learn and understand Turing Machines.
Also the finished product can be used to verify proper operation given a Turing Machine (TM) description, and help a user to understand the basics of a TM.

# Description
The program runs on the  Turing 4.1.1 for Windows compiler/interpreter (found at http://compsci.ca/holtsoft/).
When started it will interactively read a turing machine from a file, read or accept an input tape from a file, and then upon accepting or rejecting, display the output (tape).

The TM file will consist of the formal description of a turing machine:

A Turing machine is a 7-tuple, (Q, Σ, Γ, δ, q0, qaccept, qreject), where
Q, Σ, Γ are all finite sets and

1. Q is the set of states,
2. Σ is the input alphabet not containing the blank symbol ,
3. Γ is the tape alphabet, where ∈ Γ and Σ ⊆ Γ,
4. δ : Q × Γ−→Q × Γ × {L, R} is the transition function,
5. q0 ∈ Q is the start state,
6. qaccept ∈ Q is the accept state, and
7. qreject ∈ Q is the reject state, where qreject 6= qaccept.

(Introduction to the Theory of Computation by Michael Sipser, Third Edition, Course Technology)

Therefore the TM file will include:

1. First an integer n which will be the number of states, labeled Qsub1 through Qsubn.
2. The input alphabet will be skipped, as it will be inferred from the input tape and transition function.
3. The tape alphabet will be skipped, as it will be inferred from the input tape and transition function.
4. The transition function will be a list of transitions which are:

    a. integer representing beginning state for the transition.
    
    b. character to read under the head.
    
    c. integer representing the goto state of the transition.
    
    d. character to write to the tape.
    
    e. character 'R' or 'L' specifying which way to move the head.
5. The start state, as a single integer.
6. The accept state, and
7. The reject state.

The input TAPE file will include:

1. The characters on the input tape consecutively.

Upon starting the program will read the TM file and use this information to run the turing machine on the input. The (text based) output will be along the lines of "Read a '1', Wrote a '2', Move Head Right, now in State 4.  And "Entered accept state, tape contents: >785.32<

This is a learning project so every effort will be made to make the program easily understandable, and hardly any effort will be made to make it efficient.
