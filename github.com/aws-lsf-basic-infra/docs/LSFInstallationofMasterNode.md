# LSF : Installation of Master node
## IBM Documentation Reference:
[lsf_hosts](https://www.ibm.com/docs/en/spectrum-lsf/10.1.0?topic=lsf-hosts) - LSF Hosts

#### Server host
Hosts that are capable of submitting and running jobs. A server host runs sbatchd to execute server requests and apply local policies.
Commands: lshosts — View hosts that are servers (server=Yes)
Configuration : Server hosts are defined in the lsf.cluster.cluster_name file by setting the value of server to 1

#### Client host 
Hosts that are only capable of submitting jobs to the cluster. Client hosts run LSF commands and act only as submission hosts. Client hosts do not execute jobs or run LSF daemons.
Commands: lshosts — View hosts that are clients (server=No)
Configuration: Client hosts are defined in the lsf.cluster.cluster_name file by setting the value of server to 0

## Sample install.config file for server host
```sh
LSF_TOP="/usr/share/lsf"
LSF_ADMINS="lsfadmin ec2-user"
LSF_CLUSTER_NAME="verification_cluster"
LSF_MASTER_LIST="<ip address of master vm>"    ## Example :"ip-10-0-x-x"  
LSF_ENTITLEMENT_FILE="/usr/share/lsf_files/lsf_distrib/lsf_std_entitlement.dat"
LSF_TARDIR="/usr/share/lsf_files/"
CONFIGURATION_TEMPLATE="HIGH_THROUGHPUT"
SILENT_INSTALL="Y"
LSF_SILENT_INSTALL_TARLIST="All"
ACCEPT_LICENSE="Y"
ENABLE_EGO="Y"
EGO_DAEMON_CONTROL="Y"
ENABLE_DYNAMIC_HOSTS="Y"
```

##Note that order of the hosts matters in LSF_MASTER_LIST , Reference : [lsf_master_list_doc] https://www.bsc.es/support/LSF/9.1.2/lsf_admin/index.htm?lsf_master_list_behavior.html~main

## Requirements

- Security Group : ICMP (ipv4) should be enabled for the Ec2-security group for the hosts to communicate with each other.
- As of now, SSH, TCP and UDP ports are also open for all IPs.

## Installation

1. On the new Server node, Make sure the LSF binaries are available and extracted on this path : /usr/share/lsf_files
```sh
cd /usr/share/lsf_files/lsf10.1_lsfinstall/
sudo ./lsfinstall -f custom_install.config
cd /usr/share/lsf/10.1/install && sudo ./hostsetup --top="/usr/share/lsf" --boot="y"
echo "source /usr/share/lsf/conf/profile.lsf" | sudo tee -a /etc/profile > /dev/null
sudo shutdown -r now
```

2. Wait for the Server node to come up and run the following command:
```sh
lsid
lshosts
bhosts
```

3. Login to the Master Node 
```sh
cd /usr/share/lsf/conf
cat lsf.cluster.<clustername>
```
4. OPTIONAL. If you selected "N" in the Dynamic Hosts variable in order to create the cluster edit the file lsf.cluster.<clustername> and add the Server nodes info between Begin Host and End Host section (example as below)
```sh
Begin   Host
HOSTNAME  model    type        server  RESOURCES    #Keywords
#apple    Sparc5S  SUNSOL       1     (sparc bsd)   #Example
#peach    DEC3100  DigitalUNIX  1     (alpha osf1)
ip-10-0-x-x   !   !   1   (mg)
ip-10-0-x-x  !   !   1   ()
End     Host
```
5. On Master node:
```sh
lsadmin reconfig
```

6. Verification on master node
```sh
lsid
lshosts
bhosts
```

#### Sample outputs
## Master node and server node after configuration
```sh
[ec2-user@ip-10-x-x-x conf]$ lsid
IBM Spectrum LSF Standard 10.1.0.0, Jul 08 2016
Copyright International Business Machines Corp. 1992, 2016.
US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.

My cluster name is verification_cluster
My master name is ip-10-0.x.x.us-west-1.compute.internal
```

```sh
[ec2-user@ip-10-0-x-x conf]$ lshosts
HOST_NAME      type    model  cpuf ncpus maxmem maxswp server RESOURCES
ip-10-0-x  X86_64 Intel_E5  12.5     1   806M      -    Yes (mg)
ip-10-0-x  X86_64 Intel_E5  12.5     1   806M      -    Yes ()
ip-10-0-x  X86_64 Intel_E5  12.5     1   806M      -    Dyn ()

[ec2-user@ip-10-0-x-x conf]$ bhosts
HOST_NAME          STATUS       JL/U    MAX  NJOBS    RUN  SSUSP  USUSP    RSV
ip-10-0-x-x.us ok              -      1      0      0      0      0      0
ip-10-0-x-x.us ok              -      1      0      0      0      0      0
ip-10-0-x-x.us-ok              -      1      0      0      0      0      0
```

#### Sample job runs
Can be run from Master node or server node
```sh
[ec2-user@ip-10-0-x-x ~]$ bsub -J my_job sleep 1000 
````

Verify the jobs
[ec2-user@ip-10-0-x-x ~]$ bjobs -r
JOBID   USER    STAT  QUEUE      FROM_HOST   EXEC_HOST   JOB_NAME   SUBMIT_TIME
20      ec2-use RUN   normal     ip-10-0-x ip-10-0-x my_job     Apr  5 15:37
21      ec2-use RUN   normal     ip-10-0-x ip-10-0-x my_job     Apr  5 15:38



[//]: # (These are reference links used in the body of this note and get stripped out when the markdown processor does its job. There is no need to format nicely because it shouldn't be seen. Thanks SO - http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax)
   [lsf_hosts] : <https://www.ibm.com/docs/en/spectrum-lsf/10.1.0?topic=lsf-hosts>

