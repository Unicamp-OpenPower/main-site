---
title: Setting up an OpenStack-based cloud with Power8 | Part 04 – Glance
layout: page 
date: 2015-09-16
author: Maurício Bezerra
---


Glance is the Openstack Image Service and enables users to discover, register, and retrieve virtual machine images. This service allows users to query virtual machine images information and retrieve the image itself using a REST API and must be installed in the controller node.

#Prerequisites


Load the OpenRC file:

```
source adm-credentiansl.sh 
```

Create a database for Glance:

```
mysql -u root -p
CREATE DATABASE glance;
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' IDENTIFIED BY 'glance';
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY 'glance';
```

Create the keystone entities, service and endpoint:

```
openstack user create --password-prompt glance
openstack role add --project service --user glance admin
openstack service create --name glance --description "OpenStack Image service" image
openstack endpoint create --publicurl http://controller:9292 \
          --internalurl http://controller:9292  --adminurl http://controller:9292 \
          --region RegionOne image
```

#Install and Configure


Install the packages:

```
apt-get install glance python-glanceclient 
```

Edit the file */etc/glance/glance-api.cnf* as following:

```
[DEFAULT]
...
notification_driver = noop
verbose = True

[database]
connection = mysql://glance:GLANCE_DBPASS@controller/glance

[keystone_authtoken]
auth_uri = http://controller:5000
auth_url = http://controller:35357
auth_plugin = password
project_domain_id = default
user_domain_id = default
project_name = service
username = glance
password = GLANCE_PASS

[paste_deploy]
flavor = keystone

[glance_store]
default_store = file
filesystem_store_datadir = /var/lib/glance/images/
```

Also edit the file */etc/glance/glance-registry.cnf*:

```
[DEFAULT]
...
notification_driver = noop
verbose = True

[database]
connection = mysql://glance:GLANCE_DBPASS@controller/glance
[keystone_authtoken]
auth_uri = http://controller:5000
auth_url = http://controller:35357
auth_plugin = password
project_domain_id = default
user_domain_id = default
project_name = service
username = glance
password = GLANCE_PASS

[paste_deploy]
flavor = keystone
```

Populate the image service database:

```
su -s /bin/sh -c "glance-manage db_sync" glance
```

Finalize the installation process:

```
service glance-registry restart
service glance-api restart
rm -f /var/lib/glance/glance.sqlite
```

#Greenlet Fix


The Greenlet version that is in the Ubuntu repository has problems with PPC64le architecture, therefore we need to manually download and install a newer version of the library.


Download and unpack the package code:

```
wget https://github.com/python-greenlet/greenlet/archive/master.zip -D greenlet.zip
unzip greenlet.zip -D 
cd greenlet
```

Install the package:

```
export CFLAGS=-O1;
./setup.py install
```

Restart the glance services:

```
service glance-registry restart
service glance-api restart
```

#Upload an image to the Image Server


Configure the server to use the API version 2.0 and reload the credentials:

```
echo "export OS_IMAGE_API_VERSION=2" | tee -a adm-credentials.sh
source adm-credentials.sh
```

As an example upload Ubuntu 14.04.02 PPC64le to the server:

```
glance image-create --name="ubuntu1404-ppc64le" --disk-format=qcow2  --container-format=bare \
       --is-public=true \
       -copy-from https://cloud-images.ubuntu.com/releases/14.04/14.04.2/ubuntu-14.04-server-cloudimg-ppc64el-disk1.img
```

Check the list of images:

```
glance image-list
```