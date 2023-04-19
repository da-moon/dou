
# NIS (Network Information Service)

Network Information System (known by its acronym NIS , which in Spanish means Network Information System ), is the name of a client-server directory services protocol for sending configuration data in distributed systems such as usernames and hosts between computers on a network.

Requirements Packages:
- ypserv 
- rpcbind 
- yp-tools 
- nss-pam-ldapd

### Required configurations on NIS Server
First you have to change to root user in order to do all the required configurations

```sh
sudo su -
```

We have to set `ypdomainname` environment variable with our user group (It could be any name we want)

or We can make it permanent change value of the variable `NISDOMAIN` in `/etc/sysconfig/network` (create it if doesn't exist)

```sh
NISDOMAIN=nisusers
```

Set the required ports in '/etc/sysconfig/network' config file

```sh
YPSERV_ARGS="-p 955"
YPXFRD_ARGS="-p 956"
```

We need to ensure the file /var/yp/securenets keeps empty

```sh
touch /var/yp/securenets
```

Add private dns of in here: `/etc/yp.conf` to tell the same server will be client for NIS server

`ypserver replace_wih_private_dns_of_NIS_server`

Run the follow commands to enable and start the services

```sh
systemctl enable rpcbind ypserv ypxfrd yppasswdd

systemctl start rpcbind ypserv ypxfrd yppasswdd
```

This are the estep to ad new user:
- adduser -d /fsx/user_name user_name 
- passwd user_pass
- mkdir -p /fsx/user_name/.ssh 
- ssh-keygen -q -f /fsx/user_name/.ssh/id_rsa -N ""
- cp /fsx/user_name/.ssh/id_rsa.pub /fsx/user_name/.ssh/authorized_keys
- chown -R user_name:user_name /fsx/user_name/.ssh 
- chmod 700 /fsx/user_name/.ssh
- chmod 400 /fsx/user_name/.ssh/authorized_keys
- usermod -a -G edagroup user_name

The home of the user should be a shared directory. (e.g. fsx, nfs).

 In order to update the db with current database we have to run the command: 

```sh
cd /var/yp && make
```

Change the value of `yppasswdd_args` to `yppasswdd_args="-p 957"` to make firewall running then run `systemctl restart rpcbind ypserv ypxfrd yppasswdd` 

Run the command rpcinfo -p and you should get something like: 

```sh
[root@ip-10-0-1-51 yp]$ rpcinfo -p
program vers proto   port  service
100000    4   tcp    111  portmapper
100000    3   tcp    111  portmapper
100000    2   tcp    111  portmapper
100000    4   udp    111  portmapper
100000    3   udp    111  portmapper
100000    2   udp    111  portmapper
100004    2   udp    955  ypserv
100004    1   udp    955  ypserv
100004    2   tcp    955  ypserv
100004    1   tcp    955  ypserv
600100069    1   udp    956  fypxfrd
600100069    1   tcp    956  fypxfrd
100009    1   udp    816  yppasswdd
```
---
---
## NIS client Configurations

Requirements Packages:
- ypbind 
- yp-tools 
- authconfig-gtk

First you have to change to root user in order to do all the required configurations

```sh
sudo su -
```

Run the follow command in order to install the required pakacges

```sh
yum install -y ypbind yp-tools authconfig-gtk
setenforce 0
```

Add NISDOMAIN variable in `/etc/sysconfig/network` as we added on master 
```sh
NISDOMAIN=nisusers
```
Add private dns of in here: `/etc/yp.conf` as we did on NIS server.

`ypserver replace_wih_private_dns_of_NIS_server`


Make sure that `NOZEROCONF` value be `yes`. Add `yes`. Add yes in case it doesn't have it.
```sh
NOZEROCONF=yes
```
As a final configuration run this command so users will automatically get home directory

```sh
authconfig --enablenis --nisdomain=nisusers --nisserver=replace_wih_private_dns_of_NIS_server --enablemkhomedir --update 
```

## Verify

To see which server is connecting to your client from the NIS client, run:

```sh
ypwhich
```
