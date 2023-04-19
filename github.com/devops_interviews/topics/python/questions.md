## Python Common Questions and answers

Please take this questions as a base for your interview, we can select basic or advance depending on the interviewee experience.

### Cheat Sheet

![Python Cheat Sheet-1](https://github.com/DigitalOnUs/devops_interviews/blob/master/img/cheat-sheet/python-cheat-sheet.png)

### Questions

- **Basic questions**:
    - What are lists and tuples? What is the key difference between the two?
        + Lists and Tuples are both sequence data types that can store a collection of objects in Python. The objects stored in both sequences can have different data types. Lists are represented with square brackets `['sara', 6, 0.19]`, while tuples are represented with parantheses `('ansh', 5, 0.97)`.<br>But what is the real difference between the two? The key difference between the two is that while lists are mutable, tuples on the other hand are immutable objects. This means that lists can be modified, appended or sliced on the go but tuples remain constant and cannot be modified in any manner.
    -  What is Scope in Python?
        + Every object in Python functions within a scope. A scope is a block of code where an object in Python remains relevant. Namespaces uniquely identify all the objects inside a program. However, these namespaces also have a scope defined for them where you could use their objects without any prefix. A few examples of scope created during code execution in Python are as follows:
            * A local scope refers to the local objects available in the current function.
            * A global scope refers to the objects available throughout the code execution since their inception.
            * A module-level scope refers to the global objects of the current module accessible in the program.
            * An outermost scope refers to all the built-in names callable in the program.
    - What is PEP 8 and why is it important?
        + PEP stands for Python Enhancement Proposal. A PEP is an official design document providing information to the Python community, or describing a new feature for Python or its processes. PEP 8 is especially important since it documents the style guidelines for Python Code. Apparently contributing to the Python open-source community requires you to follow these style guidelines sincerely and strictly.
    - What is a dictionary in python?
        + Python dictionary is an unordered collection of items. Each item of a dictionary has a `key/value` pair.
    - How can you get the atributes of an object?
        + `dir("object_name")`
    - What is difference between module and package in python?
        + A package is a collection of Python modules: while a module is a single Python file, a package is a directory of Python modules containing an additional __init__.py file, to distinguish a package from a directory that just happens to contain a bunch of Python scripts.
    - What are decorators in python?
        + Decorators in Python are used to modify behaviours of functions. eg 
            ```
            @my_decorator
            def func1():
                pass
            ```
    - What is docstring in Python?
        + Documentation string or docstring is a multiline string used to document a specific code segment.
        + The docstring should describe what the function or method does.


- **Advance questions**:
    - What is break, continue and pass in Python?
        + Break: The break statement terminates the loop immediately and the control flows to the statement after the body of the loop.
        + Continue: The continue statement terminates the current iteration of the statement, skips the rest of the code in the current iteration and the control flows to the next iteration of the loop.
        + Pass: As explained above, the pass keyword in Python is generally used to fill up empty blocks and is similar to an empty statement represented by a semi-colon in languages such as Java, C++, Javascript, etc.
        + Example:
        ```
        pat = [1, 3, 2, 1, 2, 3, 1, 0, 1, 3]
        for p in pat:
           pass
           if (p == 0):
               current = p
               break
           elif (p % 2 == 0):
               continue
           print(p)    # output => 1 3 1 3 1
        print(current)    # output => 0
        ```
    - What are unit tests in Python?
        + Unit test is a unit testing framework of Python.
        + Unit testing means testing different components of software separately. Can you think about why unit testing is important? Imagine a scenario, you are building software that uses three components namely A, B, and C. Now, suppose your software breaks at a point time. How will you find which component was responsible for breaking the software? Maybe it was component A that failed, which in turn failed component B, and this actually failed the software. There can be many such combinations.
        + This is why it is necessary to test each and every component properly so that we know which component might be highly responsible for the failure of the software.
    - What is slicing in Python?
        + As the name suggests, ‘slicing’ is taking parts of. Syntax for slicing is [start : stop : step]
    - What is the difference between Python Arrays and lists?
        + Arrays in python can only contain elements of same data types i.e., data type of array should be homogeneous. It is a thin wrapper around C language arrays and consumes far less memory than lists.
        + Lists in python can contain elements of different data types i.e., data type of lists can be heterogeneous. It has the disadvantage of consuming large memory.
    - How is memory managed in Python?
        + Memory management in Python is handled by the Python Memory Manager. The memory allocated by the manager is in form of a private heap space dedicated to Python. All Python objects are stored in this heap and being private, it is inaccessible to the programmer. Though, python does provide some core API functions to work upon the private heap space.<br>Additionally, Python has an in-built garbage collection to recycle the unused memory for the private heap space.
    - What are Dict and List comprehensions?
        + Python comprehensions, like decorators, are syntactic sugar constructs that help build altered and filtered lists, dictionaries, or sets from a given list, dictionary, or set. Using comprehensions saves a lot of time and code that might be considerably more verbose (containing more lines of code).<br>Example:
            ```
            my_list = [2, 3, 5, 7, 11]
            squared_list = [x**2 for x in my_list]    # list comprehension
            # output => [4 , 9 , 25 , 49 , 121]
            ```
    -  What is lambda in Python? Why is it used?
        + Lambda is an anonymous function in Python, that can accept any number of arguments, but can only have a single expression. It is generally used in situations requiring an anonymous function for a short time period.
    - How do you copy an object in Python?
        + In Python, the assignment statement (= operator) does not copy objects. Instead, it creates a binding between the existing object and the target variable name. To create copies of an object in Python, we need to use the copy module. Moreover, there are two ways of creating copies for the given object using the copy module.
        + Shallow Copy is a bit-wise copy of an object. The copied object created has an exact copy of the values in the original object. If either of the values is a reference to other objects, just the reference addresses for the same are copied.
        + Deep Copy copies all values recursively from source to target object, i.e. it even duplicates the objects referenced by the source object.
    - What is a python generator?
        + A generator is a function that returns an object (iterator) which we can iterate over (one value at a time), do not store their contents in memory and after consuming it, you need to recreate it again.
    - What is PYTHONPATH in Python?
        + PYTHONPATH is an environment variable which you can set to add additional directories where Python will look for modules and packages. This is especially useful in maintaining Python libraries that you do not wish to install in the global default location.
    - Explain how to delete a file in Python?
        ```
        import os
        os.remove("ChangedFile.csv")
        print("File Removed!")
        ```
    - What does `*args` and `**kwargs` mean?
        + `*args` allows you to pass the desired number of arguments to the function. Args generally means arguments in this case.
        + `**kwargs` The term Kwargs generally represents keyword arguments, suggesting that this format uses keyword-based Python dictionaries.
