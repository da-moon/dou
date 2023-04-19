## Linux Common Questions and answers

Please take this questions as a base for your interview, we can select basic or advance depending on the interviewee experience.

### Cheat Sheet

![Linux Cheat Sheet](https://github.com/DigitalOnUs/devops_interviews/blob/master/img/cheat-sheet/linux-cheat-sheet.png)

### Questions

- **Basic questions**:
    - What is Linux?
        + Linux is an operating system based on UNIX, and was first introduced by Linus Torvalds. It is based on the Linux Kernel, and can run on different hardware platforms.
    - What is the core of Linux Operating System?
    	+ The Kernel
    - What is the kernel?
    	+ The Linux Kernel is a low-level systems software whose main role is to manage hardware resources for the user. It is also used to provide an interface for user-level interaction.
    - What is PID?
    	+ Pid is short for process ID
    - How can you find out how much memory Linux is using?
    	+ Use command   `cat /proc/meminfo`
    - How can you see a list of running processes?
    	+ Use any of the commands:
		+ `top`
		+ `htop`
		+ `ps -fea`
	- How you can display the name of the operating system name?
		+ `uname -a`

	- How can you identify a zombie process?
		+ using `ps` command by the presence of `Z` in the stat column.
	- How can you find a zombie process?
		+ `ps aux | grep 'Z'`
	- How you can you end a process?
		+ `kill - 9 <process name>`
	- What are daemons?
		+ A daemon is a long-running background process that answers requests for services. The term originated with Unix, but most operating systems use daemons in some form or another. In Unix, the names of daemons conventionally end in "d". Some examples include inetd , httpd , nfsd , sshd , named , and lpd .
	- What would be a simple way to continuously monitor the log file for a service that is running?
		+ Command `tail`
	- What would be the sintax to use the tail command?
		- tail - f "filename"
	- What does the "su" command do?
		+ Substitute User
	- What are the kinds of permissions under Linux?
		+ read, write and execute
	- How I can see the ethernet cards?
		+ `ifconfig`
	- How to check which ports are listening in my Linux Server?
		+ Use the Command `netstat –listen` and `lsof -i`
	- What is a swap space?
		+ A swap space is a certain amount of space used by Linux to temporarily hold some programs that are running concurrently.
	- What are filenames that are preceded by a dot?
		+ In general, filenames that are preceded by a dot are hidden files. These files can be configuration files that hold important data or setup info. Setting these files as hidden makes it less likely to be accidentally deleted.
	- You need to search for the string “Tecmint” in all the “.txt” files in the current directory. How will you do it?
		+ We need to run the fine command to search for the text “Tecmint” in the current directory, recursively. `find . ­name ".txt" | xargs grep "Tecmint"`
	- How you check the disk space?
		+ Using command `df -h`
	- What does rpm do?
		+ RPM (RPM Package Manager) is a popular utility for installing software on Unix-like systems, particularly Red Hat Linux.
	- What does pipe do on the command line?
		+ Pipes in general are a means of re-directing input/output
	- How to move between directories?
        + `cd directory`
        + `cd .. (to go one directory back)`
    - How to create a user?
        + `sudo useradd username`
    - How to create a password?
        + `sudo passwd username`
    - Why we do use sudo?
        + The sudo command is used to give such permissions to any particular command that a user wants to execute once the user enters a user password to give system based permissions.
    - How to show all the files inside a directory including hidden files?
        + `ls -a`
    - How to change the permissions of a file?
        + `chmod type-of-permissions(000) filename`
    - How you can change the name of a file?
        + `mv old-name new-name` 
    - Get the first 4 lines of a file?
        + `head -4 file-name`
    - What are cron, cron job, and crontab?
    	+ Cron is a system that helps Linux users to schedule any task. However, a cron job is any defined task to run in a given time period. It can be a shell script or a simple bash command. Cron job helps us automate our routine tasks, it can be hourly, daily, monthly, etc.<br>Meanwhile, the crontab stands for cron table. It is a Linux system file that contains a list of the cron job. We define our task — bash command, shell script, Python script, etc scheduled in crontab.

- **Advance questions**:
	- How to create partition from the raw disk?
		+ Using `fdisk` utility.
	- What would the fdisk sintax be?
		+ `fdisk  /dev/hd* (IDE) or /dev/sd* (SCSI)`
	- What is typical size for a swap partition under a Linux system?
		+ twice the amount of physical memory available.
	- Which Port should you open in your host firewall to run web server?
		+ default 80 and 443
	- Where does Linux keep the passwords?
		+ `/etc/shadow`
	- Mention differences between softlink and hardlink:
		+ 1) Hardlink cannot be created for directories. HardLink can only be created for a file
		+ 2) Symbolic links or symlinks can link to a directory
		+ 3) If you remove the hardlink or the symlink itself, the original file will stay intact
	- Which of the following commands will you run to list all files that have been modified within the last 60 minutes?
		+ `find start -dir -cmin -60`
	- How would you upgrade the linux kernel in a server?
		+ Using rpm command, but with the awareness that upgrading a kenel can make your linux box in a unbootable state.
	- What happens if you do a wget `http://google.com`?
		+ Will download the headers and content of the html
	- How would you track events on your linux system?
		+ For tracking the events on the system, we need a daemon called `syslogd`. The `syslogd` daemon is useful in tracking the information of system and then saving it to specified log files. Usually the logfiles can be found in the file `/var/log/syslog`
	- How will you restrict IP so that the restricted IP’s may not use the FTP Server?
		+ Block suspicious IP by integrating tcp_wrapper. You need to enable the parameter `tcp_wrapper=YES` in the configuration file at `/etc/vsftpd.conf.` And then add the suspicious IP in the file at location `/etc/host.deny.`
	- What is the difference between `locate` and `slocate` command?
		+ The `slocate` looks for the files that user have access whereas `locate` will search for the file with updated result.
	- You want to send a message to all connected users as `Server is going down for maintenance`, what will you do?
		+ This can be achieved using the `wall` command. The `wall` command sends a message to all connected users on the sever.<br>`echo "please save your work, immediately. The server is going down for Maintenance at 12:30 pm, sharply." | wall`
	- Are drives such as harddrive and floppy drives represented with drive letters?
		+ No. In Linux, each drive and device has different designations. For example, floppy drives are referred to as `/dev/fd0`, `IDE/EIDE` hard drives are referred to as `/dev/` `hda`, `/dev/hdb`, and so forth