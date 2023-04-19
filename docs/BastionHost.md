# Installation of Bastion Host

## IBM Documentation Reference:
[lsf_hosts](https://www.ibm.com/docs/en/spectrum-lsf/10.1.0?topic=lsf-hosts) - LSF Hosts


Bastion host will be an instance in a public subnet where the jobs are goin gto be sent to LSF cluster. This host will be installed as LSF client so it won't try to execute jobs.

#### Client host 
Hosts that are only capable of submitting jobs to the cluster. Client hosts run LSF commands and act only as submission hosts. Client hosts do not execute jobs or run LSF daemons.
Commands : lshosts — View hosts that are clients (server=No)
Configuration : Client hosts are defined in the lsf.cluster.cluster_name file by setting the value of server to 0

## Sample install.config file for client host
```sh
LSF_TOP="/usr/share/lsf"
LSF_ADMINS="lsfadmin ec2-user"
LSF_CLUSTER_NAME="verification_cluster"
LSF_MASTER_LIST="<ip address of master vm>"    ## Example :"ip-10-0-x-x"  

LSF_ADD_CLIENTS= "<ip address of server vm>"   ## Example :ip-10-0-x-x
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

2. Wait for the Client node to come up and run the following command:
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
4. (OPTIONAL if the Client host doesnt gets added Dynamically) Edit the file lsf.cluster.<clustername> and add the Client nodes info between Begin Host and End Host section (example as below)
```sh
Begin   Host
HOSTNAME  model    type        server  RESOURCES    #Keywords
#apple    Sparc5S  SUNSOL       1     (sparc bsd)   #Example
#peach    DEC3100  DigitalUNIX  1     (alpha osf1)
ip-10-0-x-x   !   !   1   (mg)
ip-10-0-x-x   !   !   0   ()
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
## Master node and client node after configuration
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
ip-10-0-x-x  X86_64 Intel_Pl  15.0     1   7.4G      -    Yes (mg)
ip-10-0-101 UNKNOWN UNKNOWN_   1.0     -      -      -     No ()
```
Client host will not appear when running 'bhosts' since this will not be able to execute jobs

```sh
[ec2-user@ip-10-0-x-x conf]$ bhosts
HOST_NAME          STATUS       JL/U    MAX  NJOBS    RUN  SSUSP  USUSP    RSV
ip-10-0-x-x.us ok              -      1      0      0      0      0      0
```


[//]: # (These are reference links used in the body of this note and get stripped out when the markdown processor does its job. There is no need to format nicely because it shouldn't be seen. Thanks SO - http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax)
   [lsf_hosts] : <https://www.ibm.com/docs/en/spectrum-lsf/10.1.0?topic=lsf-hosts>

