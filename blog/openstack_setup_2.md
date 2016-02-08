---
title: Setting up an OpenStack-based cloud with Power8 | Part 02 – Environment Setup 
layout: page 
date: 2015-08-21
author: Maurício Bezerra
---

The environment will consist of two Power8 machines with Ubuntu 15.04 installed, one of the machines will contain the core cloud services (controller node), and the other one the virtualization services (compute node). In this guide we are going to install the newest OpenStack release, the Kilo version. However, before installing the cloud services it's necessary to properly set up the environment, this post will cover all the datails.

#Passwords

As a convention, passwords for each service will be the service name in lowercase, do not forget that in a real environment passwords must be chosen carefully.

#Network

It's possible to install OpenStack with two different network architectures, legacy networking (nova-network) and Neutron. Initially we will use nova-network, our network environment is represented as shown below:


![Nova-network](http://i.imgur.com/cULbdw1.png)


Note that we have two networks, the 10.0.0.0/24 is the management network (where the nodes will establish comunicate) and the 10.0.2.0/24 is the external network (each created VM will have an IP external acessible).


Edit the file */etc/hosts* on all machines and add the following:

```
#controller
10.0.0.10 controller
#compute
10.0.0.11 compute01
```

#Network Time Protocol (NTP)

In order to synchronize services installed on different nodes we will install NTP.

First of all install NTP on all machines:
```
apt-get install ntp
```

##On controller

Edit the file */etc/ntp.conf* and add or edit the follwing lines:
```
server 0.ubuntu.pool.ntp.org iburst
restrict -4 default kod notrap nomodify
restrict -6 default kod notrap nomodify
```

Restart the NTP service:

```
service ntp restart
```

##On compute

Edit the file */etc/ntp.conf* and change the server to:

```
server controller iburst
```

Restart the NTP service:

```
service ntp restart
```

#Openstack and system packages

We have to configure the package respository to point to the Openstack Kilo release and verify if the system is up-to-date. Perform the followig step on all nodes.

Install Ubuntu keyring and set the Kilo repository:

```
apt-get install ubuntu-cloud-keyring
echo "deb http://ubuntu-cloud.archive.canonical.com/ubuntu" \
"trusty-updates/kilo main" > /etc/apt/sources.list.d/cloudarchive-kilo.list
```

Upgrade the packages on your system:

```
apt-get update
apt-get dist-upgrade
```

#SQL database

The SQL database will be installed only on controlle node, the openstack services mostly use a database to store all the information they need. We choose to install MySQL server.

Install packages:

```
apt-get install mysql-server python-mysqldb
```

Edit the file */etc/mysql/mysql.conf.d/mysqld.conf* in the \[mysqld\] section:

```
[mysqld]
...
bind-address = 10.0.0.10
default-storage-engine = innodb
innodb_file_per_table
collation-server = utf8_general_ci
init-connect = 'SET NAMES utf8'
character-set-server = utf8
```

Restart the Mysql service:

```
service mysql restart
```

Execute the following mysql script to secure the database service:

```
mysql_secure_installation
```

##Message Queue

Openstack uses the strategy of a queue message to coordinate the actions related to the services, in other words, a message queue running on the controller node coordinates the comunication between the services in order to have all the services properly. In this guide we will use a message queue server called RabbitMQ.


Install the packages:

```
apt-get install rabbitmq-server
```

Create the openstack user:

```
rabbitmqctl add_user openstack RABBIT_PASS
```

As mentioned in password section, replace *RABBIT_PASS* by *rabbit*.


Configure permissions to openstack user:

```
rabbitmqctl set_permissions openstack ".*" ".*" ".*"
```

##Next steps

With the environment properly configured we can setup the OpenStack services, in the next post we will configure the identity service, known as Keystone.
