## Bash Sccripting Common Questions and answers

Please take this questions as a base for your interview, we can select basic or advance depending on the interviewee experience.

### Cheat Sheet

![Bash Cheat Sheet](https://github.com/DigitalOnUs/devops_interviews/blob/master/img/cheat-sheet/shell-script-cheats-sheet.png)

### Questions

- **Basic questions**:
	- What is shebang and where to use it?
		- It is called a shebang or a "bang" line. It is nothing but the absolute path to the Bash interpreter. It consists of a number sign and an exclamation point character (#!), followed by the full path to the interpreter such as /bin/bash. All scripts under Linux execute using the interpreter specified on a first line.

	- How do you set a variable?
		- The format is to type the name, the equals sign =, and the value. Note there isn’t a space before or after the equals sign. eg: `me=Devops`

	- How can you create an array?
		- myArray=("cat" "dog" "mouse" "frog).

	- How do you define a [IF, FOR, CASE] statement?
		- For:
			```
			for item in [LIST]
			do
	  			[COMMANDS]
			done
			```
		- If:
			```
			if [ <some test> ]
			then
				<commands>
			fi
			```
		- Case:
			```
			case expression in
	    		pattern1 )
	        		statements ;;
	    		pattern2 )
	        		statements ;;
	    		...
			esac
			```

	- Which command can be used to print variables?
		- `echo "$var"`

    - How variables can be wiped out?
        - `unset variable-name`

	- Which commands are used to print output in bash?
		- You can use `echo` BUT we are looking for `printf` to have more control over formatting. eg: `printf [-v var] format [arguments]`

	- How to take input from the terminal in bash?
		- `read` command

    - How will you pass and access arguments to a script in Linux?
        - `scriptName "Arg1" "Arg2"…."Argn"` and can be accessed inside the script as `$1` , `$2` .. `$n`

	- How can you know the total number of parameters passed to a script?
		- $#

	- How to read the second word or column from each line of a file?
		- echo `cat example.txt | awk '{print $2}'`

	- What are the conditional statements in bash and its syntax?
		```
		if [ condition ]; then
		statement 1
		elif [ condition ]; then
		statement 2
		….
		else
		statement n
		fi
		```

	- Which conditional statement can be used as an alternative to if-elseif-else statements in bash?
		- Case

- **Advance questions**:

	- What different types of loops can be used in bash?
		- The while loop
		  The for loop
		  The until loop
		  The select loop

	- What is the difference between while and until loop?
		- The main difference is that while loops are designed to run while a condition is satisfied and then terminate once that condition returns false. On the other hand, until loops are designed to run while the condition returns false and only terminate when the condition returns true.

	- How integer comparition is done in bash?
		- `-eq`	Integer equality
		  `-ne`	Integer inequality
		  `-lt`	Integer less than
		  `-le`	Integer less than or equal to
		  `-gt`	Integer greater than
		  `-ge`	Integer greater than or equal to

	- How to loop through array elements in bash?
		```
		for str in ${myArray[@]}; do
  			echo $str
		done
		```

	- How to loop through array indices in bash?
		```
		for i in ${!myArray[@]}; do
  			echo "element $i is ${myArray[$i]}"
		done
		```

	- What are the debug shell options in bash?
		- Disabling the Shell ( -n option)
		  Displaying the Scripts Commands ( -v option )
		  Combining the -n & -v Options.
		  Tracing Script Execution ( -x option )