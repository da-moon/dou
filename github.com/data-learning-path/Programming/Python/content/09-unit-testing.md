# Python 3

## Unit Testing
What is [unit testing](https://www.atlassian.com/continuous-delivery/software-testing/types-of-software-testing)? It is the most basic type of automated testing. It is the kind of test closer to the application. Unit testing consists of testing the individual parts of an application:
- Methods & Functions of the classes
- Components
- Modules


## Unit Testing in Python
The module/framework you need to introduce unit testing into your application is the `unit test` module.

Things to consider when writing tests:
- Each set of test cases should be written inside a class that inherits `unittest.TestCase`.
- Python will not check tests cases that do not include the `test` prefix in their function declaration.
- Test positive and negative scenarios (when it applies).

### Writing tests
To check if something will return a exact value:
```py
def test_upper(self):
    # upper(): it changes all characters to CAPITAL letter   
    self.assertEqual('foo'.upper(), 'FOO')
```

Test a boolean value:
```py
def test_isupper(self):
    # checks if `FOO` contains all Upper characters   
    self.assertTrue('FOO'.isupper())
    # validates that not all characters are Uppercase
    self.assertFalse('Foo'.isupper())
```

Test to expect an error:
```py
def test_sum_string(self):
    with self.assertRaises(TypeError):
        sum(10, "b")
```

### Run tests
You must call the tests with
```py
unittest.main()
```

### Outputs
The result of each test is divided into `OK` or `FAILED`. `OK` won't give any extra information. On the other hand, `FAILED` will describe the error (**CAUTION:** it may be an error of writing the test). Read the message carefully.
 
If you haven't added any test case or you may not follow the declaration conventions (e.g., test case prefix), you may see something like the following:

```py
Ran 0 tests in 0.000s

OK
```

If everything is `OK` you may see the following message:
```py
Ran 2 tests in 0.000s

OK
```

If it encounters an error, a detailed **error message** will appear:
```py
FF
======================================================================
FAIL: test_sum (__main__.TestSum)
----------------------------------------------------------------------
Traceback (most recent call last):
  File "tests.py", line 11, in test_sum
    self.assertEqual(31, sum(10, 20))
AssertionError: 31 != 30

======================================================================
FAIL: test_sum_string (__main__.TestSum)
----------------------------------------------------------------------
Traceback (most recent call last):
  File "tests.py", line 8, in test_sum_string
    sum(10, 2)
AssertionError: TypeError not raised

----------------------------------------------------------------------
Ran 2 tests in 0.001s

FAILED (failures=2)
```

### In-Depth
For more information (if you wish to go deeper into unit testing), check the [`unitest`](https://docs.python.org/3/library/unittest.html) documentation.