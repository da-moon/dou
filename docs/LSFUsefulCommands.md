Useful commands and directories
=============================

A collection of useful commands for IBM LSF (verion 10.1.0)

#### LSF  Commands 

| Command | Description | Notes |
|------|-------------|-------- |
| `bjobs -u all`| View jobs from all users | Use -w to see output in long format |
| `bjobs -l` | detailed info about a job | |
| `bjobs -r`  | view running jobs | |
| `bjobs -d` | view finished jobs | |
| `bjobs -u all -d` | check done jobs from all users  | |
| `bjobs -a` | show details about all jobs | |
| `bjobs -s`  | to view suspended jobs | |
| `bjobs -p` | Displays information for pending jobs (PEND state) and their reasons | To get specific host names along with pending reasons, run bjobs -lp. To view the pending reasons for all users, run bjobs -p -u all. |
| `bpeek job_id` | To get job output as produced so far | |
| `bkill -r` | to kill a job | |
| `bsub --outdir` |  Creates the job output directory | |
| `bsub -m` | Submits a job to be run on specific hosts, host groups, or compute units.  | |
| `bsub -K` |  Submits a job and waits for the job to complete. Sends job status messages to the terminal | |
| `bsub -cwd` | Specifies the current working directory for job execution | |
| `bsub -R "select[type==any]"` | Normal jobs submitted to Normal queue | |
| `bsub -R "select[awshost]" -q awsexample sleep 200` | Jobs submited to awsexample queue | works after resource connector setup |
| `bsub -I < test.sh` | submits an interactive job (-I flag) | |
| `bsub -R "awshost && pricing==spot" -q awsexample < rev_num.sh` | To run a shell script on AWS queue | |
| `bsub -R "awshost && pricing==spot" -q awsexample python3 /fsx/rev_num.py` | to run a python script | all VMs should have python installed, this was just for testing |
| `bhosts -w` | shows the host which can run jb (server nodes and master) | |
| `lshosts -w` | shows all hosts in the cluster | |
| `lsinfo` | lsf configration information | |
| `busers -w` |  to show lsf users and Prints pending job thresholds for users and user groups and exits | Output shows PEND, MPEND, PJOBS, and MPJOBS fields.|
| `bugroup -l` | display info about groups in long format | use  -w in wide format |
| `bqueues` | displays information about queues | |
| `brun` | forces a job to run immediately | |

#### Important Directories

Installer location : /usr/share/lsf_files

Logs : /usr/share/lsf/log

Conf files : /usr/share/lsf/conf
* LSF_CONFDIR/lsf.conf
* LSF_CONFDIR/lsf.cluster.cluster_name
* LSF_CONFDIR/lsf.shared
* LSB_CONFDIR/cluster_name/configdir/lsb.queues

Aws enable files : /usr/share/lsf/10.1/install  ( aws_enable.sh and aws_enable.config)

LSF profile : /usr/share/lsf/conf/profile.lsf

Cloud init logs : /var/log/cloud-init-output.log

## Resource connector
Json file and cred location : /usr/share/lsf/conf/resource_connector/aws/conf

Other (aws_db.json etc.): /usr/share/lsf/work/clustername/resource_connector


#### References
[IBM LSF official documentation](https://www.ibm.com/docs/en/spectrum-lsf/10.1.0?topic=reference-command)

[IBM LSF directories](https://www.ibm.com/docs/en/spectrum-lsf/10.1.0?topic=overview-important-directories-configuration-files)
