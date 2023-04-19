import os
import sys

# FYI I know tests are a bit UGLY, but I'm ok with it, it's just tests! :)

## fewknow: If you get EOF exceptions like this:
## pexpect.exceptions.EOF: End Of File (EOF). Empty string style platform.
## It means you created a TestObj and are calling `.expect()` on it after the child
## process has already exited. For instance, creating a single DevGet() and calling .get() numerous times.
##
## ALSO: You must always have an `child.expect` looking for the _last_ line of output, otherwise pexpect will kill
## the child process even if the child process is still finishing some stuff in the background.
##
##
## If you forget "encoding='utf-8' on a spawn() call logs will break! Use TestUtils going forward.
##
## Do not set delaybeforeread - it is not needed and appears to cause issues if you set it to be too long. If the delay
## is too long, if the dwarf subprocess returns data before delaybeforeread seconds, that data may never get read thus resulting
## in a timeout exception.


def print_test():
    print(f"-----------------------------------------")
    print(f"             Starting test:              ")
    print(f"-----------------------------------------")


def run_test():

    print(f"-----------------------------------------")
    print(f"         TEST COMING SOON!!!!            ")
    print(f"-----------------------------------------")


def main():
    # clear_cache()

    print_test()
    run_test()

if __name__ == '__main__':
    main()
