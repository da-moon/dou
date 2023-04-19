## Scripting Common Questions and answers

Please take this questions as a base for your interview, we can select basic or advance depending on the interviewee experience.

- **Bash**:
    - Basic questions:
        + How will you pass and access arguments to a script in Linux?
            - `scriptName "Arg1" "Arg2"…."Argn"` and can be accessed inside the script as `$1` , `$2` .. `$n`
        + What is the difference between soft and hard links?
            - Soft links are link to the file name and can reside on different filesytem as well; however hard links are link to the inode of the file and have to be on the same filesytem as that of the file.
        + How can you print in bash?
            - `echo`
    - Advance questions:
        + Print the 10th line without using tail and head command.
            - `sed –n '10p' filename`
        + How variables can be wiped out?
            - `unset variable-name`

- **Python**:
    - Basic questions:
        + Tell me 3 built-in types in python?
            - string, bool, int.
        + What is a list?
            - Lists are just like dynamic sized arrays, declared in other languages (vector in C++ and ArrayList in Java). 
        + What is the main difference between list and tuple in pyton?
            - list is mutable, whereas a tuple is immutable.
        + What is a dictionary in python?
            - Python dictionary is an unordered collection of items. Each item of a dictionary has a `key/value` pair.
        + What is PEP8?
            -  Is a document that provides guidelines and best practices on how to write Python code. It was written in 2001 by Guido van Rossum, Barry Warsaw, and Nick Coghlan. The primary focus of PEP 8 is to improve the readability and consistency of Python code.
        + What is Unit testing?
        	- UNIT TESTING is a type of software testing where individual units or components of a software are tested.
        + How can you get the atributes of an object?
        	- `dir("object_name")`
    - Advance questions:
        + What is a python generator?
            - A generator is a function that returns an object (iterator) which we can iterate over (one value at a time), do not store their contents in memory and after consuming it, you need to recreate it again.
        + What are decorators in python?
            - Decorators in Python are used to modify behaviours of functions. eg 
            ```
            @my_decorator
            def func1():
                pass
            ```
        + What is difference between module and package in python?
            - A package is a collection of Python modules: while a module is a single Python file, a package is a directory of Python modules containing an additional __init__.py file, to distinguish a package from a directory that just happens to contain a bunch of Python scripts.
        + What is `lambda` in python?
            - Python `lambdas` are little, anonymous functions, subject to a more restrictive but more concise syntax than regular Python functions.