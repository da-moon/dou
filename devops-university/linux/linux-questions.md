## Linux Common Questions and answers

Please take this questions as a base for your interview, we can select basic or advance depending on the interviewee experience.

- **Basic questions**:
    - How to install a package?
        + `sudo apt-get install package-to-install`
        + `sudo yum install package-to-install`
    - How to move between directories?
        + `cd directory`
        + `cd .. (to go one directory back)`
    - How to create a user?
        + `sudo useradd username`
    - How to create a password?
        + `sudo passwd username`
    - Why we do use sudo?
        + The sudo command is used to give such permissions to any particular command that a user wants to execute once the user enters a user password to give system based permissions.
    - How to search for an specific file?
        +  `find . -name filename.txt`
    - How to show all the files inside a directory including hidden files?
        + `ls -a`
    - How to change the permissions of a file?
        + `chmod type-of-permissions(000) filename`
    - How you can change the name of a file?
        + `mv old-name new-name` 
    - How to create a directory in linux?
        + `mkdir name-of-directory`
    - How to remove a directory in linux?
        + `rmdir name-of-directory`
    - Get the last 4 lines of a file?
        + `tail -4 file-name`
    - Get the first 4 lines of a file?
        + `head -4 file-name`

- **Advance questions**:
    - How to create a file without using open it?
        + `touch filename`
    - How to check top ofenders process in yout machine (check your system process)?
        + `top`
    - How do you copy a file?
        + `cp [OPTION] Source Destination`
    - Can you name 3 different ways to copy a file?
        + `scp, cp, rsynch`
    - Where you can find the configuration files in a linux system?
        + `etc/`
    - How can you find an specific string inside a file?
        + `cat file-name | grep "string"`
    - How do you check how much space left in current drive ?
        + `df -h`
