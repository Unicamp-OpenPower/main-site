---
title: Setting up an OpenStack-based cloud with Power8 | Part 03 – Keystone 
layout: page 
date: 2015-09-09
author: Maurício Bezerra
---


This service provides a central directory of users mapped to the OpenStack services. It's used to provide an authentication and authorization service for other OpenStack services. In addition to the identity service, we will install two more packages, the Apache HTTP server and the Memcahed, responsible, respectively, for receiving requests and store the authentication tokens.

#Prerequisites

All the keystone data will be stored in a database, acess the mysql and execute the following commands:

```
>mysql -u root -p
CREATE DATABASE keystone;
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY 'keystone';
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY 'keystone';
```

#Install and Configure

The version Kilo uses a WSGI server to listen the requests to keystone, we choose to use the Apache Server running a WSGI mod.

Execute the following commands to disable keystone automatic start and install the packages:

```
>echo "manual" > /etc/init/keystone.override
apt-get install keystone python-openstackclient apache2 libapache2-mod-wsgi \
        memcached python-memcache
```

Edit the following sections in the file /etc/keystone/keystone.conf:</li>

```
>[DEFAULT]
...
admin_token = ADMIN_TOKEN
verbose = True

[database]
connection = mysql://keystone:KEYSTONE_DBPASS@controller/keystone

[memcache]
servers = localhost:11211

[token]
provider = keystone.token.providers.uuid.Provider
driver = keystone.token.persistence.backends.memcache.Token

[revoke]
driver = keystone.contrib.revoke.backends.sql.Revoke
```

Create the file /etc/apache2/sites-available/wsgi-keystone.conf with the following content:

```
>Listen 5000
Listen 35357

< VirtualHost *:5000 >
    WSGIDaemonProcess keystone-public processes=5 threads=1 user=keystone display-name=%{GROUP}
    WSGIProcessGroup keystone-public
    WSGIScriptAlias / /var/www/cgi-bin/keystone/main
    WSGIApplicationGroup %{GLOBAL}
    WSGIPassAuthorization On
    < IfVersion >= 2.4 >
      ErrorLogFormat "%{cu}t %M"
    < /IfVersion >
    LogLevel info
    ErrorLog /var/log/apache2/keystone-error.log
    CustomLog /var/log/apache2/keystone-access.log combined
< /VirtualHost >
< VirtualHost *:35357 >
    WSGIDaemonProcess keystone-admin processes=5 threads=1 user=keystone display-name=%{GROUP}
    WSGIProcessGroup keystone-admin
    WSGIScriptAlias / /var/www/cgi-bin/keystone/admin
    WSGIApplicationGroup %{GLOBAL}
    WSGIPassAuthorization On
    < IfVersion >= 2.4 >
      ErrorLogFormat "%{cu}t %M"
    < /IfVersion >
    LogLevel info
    ErrorLog /var/log/apache2/keystone-error.log
    CustomLog /var/log/apache2/keystone-access.log combined
< /VirtualHost >

```

Install and configure the WSGI mod for Apache:

```
>ln -s /etc/apache2/sites-available/wsgi-keystone.conf /etc/apache2/sites-enabled
mkdir -p /var/www/cgi-bin/keystone
curl http://git.openstack.org/cgit/openstack/keystone/plain/httpd/keystone.py?h=stable/kilo \
     | tee /var/www/cgi-bin/keystone/main /var/www/cgi-bin/keystone/admin
chown -R keystone:keystone /var/www/cgi-bin/keystone
chmod 755 /var/www/cgi-bin/keystone/*
```

Restart the Apache service:

```
>rm -f /var/lib/keystone/keystone.db
service apache2 restart
```

#Create the service endpoint

To really have the Keystone service working is needed to create a service endpoint to listen requests:


Export the following lines to obtain administrator privileges on Keystone:

```
>export OS_TOKEN=ADMIN
export OS_URL=http://controller:35357/v2.0
```

Registry the service:

```
>openstack service create --name keystone --description "OpenStack Identity" identity
openstack endpoint create --publicurl http://controller:5000/v2.0 \
          --internalurl http://controller:5000/v2.0 --adminurl http://controller:35357/v2.0 \
          --region RegionOne identity
```

#Create the environment entities

Each of the services that compose OpenStack uses the keystone as the authentication point, this process involves a combination of various entities (users, projects, etc.). You can better understand the functioning of Keystone at the [documentation page](http://docs.openstack.org/kilo/install-guide/install/apt/content/keystone-concepts.html): 


Create the Admininstration and Demo projetct:

```
>openstack project create --description "Admin Project" admin
openstack project create --description "Demo Project" demo
```

Create users and roles and after make sure each user is registred in one role:

```
>openstack role create admin
openstack role create user
openstack user create --password-prompt admin
openstack user create --password-prompt demo
openstack role add --project admin --user admin admin
openstack role add --project demo --user demo user
```

Each service that will be installed is represent as an user in Keystone, they will be part of an project that will contain all the services:

```
>openstack project create --description "Service Project" service
```
#OpenRC files

To simplify the keystone authentication process create a file that contains the credenditals and export to the system.


Create the file adm-credentials.sh and add the following:

```
>export OS_PROJECT_DOMAIN_ID=default
export OS_USER_DOMAIN_ID=default
export OS_PROJECT_NAME=admin
export OS_TENANT_NAME=admin
export OS_USERNAME=admin
export OS_PASSWORD=SENHA_ADMIN
export OS_AUTH_URL=http://controller:35357/v3
```

Load the file content:

```
>source adm-credentials.sh
```