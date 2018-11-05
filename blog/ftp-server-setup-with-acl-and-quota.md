---
title: Setting up a FTP Server with Access List and Disk Quota
layout: page
date: 2018-11-05
author: Luciano Zago
---

In this guide, we will show how to setup a public FTP server with directory access control and disk quota per-user.
We used Ubuntu Server 16.04, running on ppc64le architecture, but it should work on other architectures as well, because no exclusive software was used, only open source software.


# Disk space

You will need an `ext4` partition with enough space, that can be mounted on `/` or on `/var/www`. If you need help, look at [this tutorial](https://www.howtogeek.com/106873/how-to-use-fdisk-to-manage-partitions-on-linux/).

After that, create the directories that will be used in the web and ftp servers:
```
sudo mkdir /var/www/html
sudo mkdir /var/www/html/pub
```
Set the permissions to these directories:
```
sudo chown nobody:nogroup /var/www/html
sudo chmod a-w /var/www/html
```


# HTTP Server (apache)

We intend that our files can be accessed through a web browser. In that case, we will need a HTTP Server, like Apache.

## Installation
Install the package `apache2`, with the following commands:
```
sudo apt-get update
sudo apt-get install apache2
```
Restart the service to make sure that the web server works:
```
sudo systemctl restart apache2
```

## Content
You can create a welcome page in HTML with links to `/pub` folder, to show the files though the browser. Your page `index.html` need to be in the directory `/var/www/html`.

For reference, you can look at our web page in [this link](https://oplab9.parqtec.unicamp.br/).


# SSL Certificate (certbot)

Certbot is a client that deploy free SSL certificates from Let's Encrypt to any web server.
If you already have a SSL certificate, you can [*skip this part*](#firewall-ufw).

## Installation
Run these commands to install the package `certbot`:
```
sudo apt-get update
sudo apt-get install software-properties-common
sudo add-apt-repository ppa:certbot/certbot
sudo apt-get update
sudo apt-get install python-certbot-apache
```

## Configuration
We need to configure the web server to work with the certificate. Run this command to use the Certbot certificate with the Apache web server:
```
sudo certbot --apache
```

The certificate expires in 90 days, so you need to renew this certificate periodically. To schedule the execution of `certobot renew` command, we will use `cronjob`, a time-base job scheduler. To use the scheduler, run this command:
```
sudo crontab -e
```
And add the following line in the end of the file:
```
0 0 * * * sudo certbot renew
```
Save the file.
After that, the renew command is scheduled to run everyday.


# Firewall (ufw)

The UFW is an easy frontend interface for iptables. We need to configure the firewall to work with the other installed software.

## Installation
Install the package `ufw` to manage the firewall, with the following commands:
```
sudo apt-get update
sudo apt-get install ufw
```

## Configuration
Forwarding the ports:
```
sudo ufw allow 20/tcp
sudo ufw allow 21/tcp
sudo ufw allow 990/tcp
sudo ufw allow 60000:60500/tcp
sudo ufw allow ssh
sudo ufw allow 'Apache Full'
sudo ufw status
```

Restart to conclude the steps:
```
sudo ufw disable
sudo ufw enable
```


# FTP Server (vsftpd)

We will use the vsftpd software to run the FTP server, the default in the Ubuntu, CentOS, Fedora, NimbleX, Slackware and RHEL Linux distributions.

## Installation
Install the package `vsftpd` with the following command:
```
sudo apt-get install vsftpd
```

## Configuration
Backup your original file:
```
sudo cp /etc/vsftpd.conf /etc/vsftpd.orig
```

Edit the configuration file with the following command:
```
sudo nano /etc/vsftpd.conf
```
Example config file:
<script src="https://gist.github.com/lcnzg/233a7b406f2528cb0d517fc6fbeed5c9.js"></script>

In the previous config, we allowed read permission for anonymous.

To create the userlist that have permission to access the FTP server, and allow the anonymous user, use the following commands:
```
sudo touch /etc/vsftpd.userlist
sudo echo "anonymous" >> /etc/vsftpd.userlist
```

## Disabling shell for ftp users
With these commands, we will create a new shell with no functionalities, to restrict the access of the FTP users:
```
sudo touch /bin/ftponly
sudo echo -e '#!/bin/sh\necho "This account is limited to FTP access only."' >> /bin/ftponly
sudo chmod a+x /bin/ftponly
sudo echo "/bin/ftponly" >> /etc/shells
```

Restart the FTP server service:
```
sudo systemctl restart vsftpd
```


# Disk Quota

We will use a disk quota to limit the disk space used by the FTP users.

## Installation
Install the package `quota` with the following command:
```
sudo apt install quota
```
## Configuration
Edit the `fstab` file and add `usrquota` option in the partition you chose earlier:
```
sudo nano /etc/fstab
```

Remount partition and enable the quota:
```
sudo mount -o remount /var/www
sudo quotacheck -cum /var/www
sudo quotaon /var/www
```
## Defining a default quota
Create a new user to copy the quota settings for the new users:
```
sudo adduser ftpuser
```
Insert a password.

After that, you will need to edit the quota of `ftpuser` with this command:
```
sudo edquota ftpuser
```
Put the values of soft and hard quota in these columns.

Example: 10GB: 10000000 and 10485760 in block quota session.

Let 0 if you don't want to have a limit.

Set the default quota user as `ftpuser` to copy a quota for the new users:
```
sudo sed -i -e 's/.*QUOTAUSER="".*/QUOTAUSER="ftpuser"/' /etc/adduser.conf
```

## Commands
There are a few commands useful for controlling the quota:
- `quota user` shows the `user` quota.
- `repquota -a` shows the general quota report.
- `edquota user` to edit `user` quota.


# Access List (acl)

We will use Access List Control, or ACL, to have a better control of file permissions. With ACL we can set different file permissions, in different directories, to each FTP user.

## Installation
Install the package `acl` with the following command:
```
sudo apt install acl
```

## Configuration
Edit the `fstab` file and add `acl` option in the `/var/www` partition:
```
sudo nano /etc/fstab
```

Remount the partition to apply the changes:
```
sudo mount -o remount /var/www
```

## Commands
The commands used to enable write permission to `$USER` in `$DIRECTORY` were:
```
setfacl -d -R -m u:$USER:rwX $DIRECTORY
setfacl -R -m u:$USER:rwX $DIRECTORY
```

# Adding new users
We created the following script to manage the creation of new users:
<script src="https://gist.github.com/lcnzg/54a44d87babcf3f33523fbcae152c47f.js"></script>

```
chmod +x create_user.sh
```
Add new users by running the script this way:
```
sudo ./create_user.sh 'user' 'pass' 'directory'
```

**Directory instructions:**

- for the root of FTP directory, use ```.``` .
- for other directories, don't write the initial and final slashes (ex: ppc64el/debian for /www/html/pub/ppc64el/debian/).

Should any problem with file permissions ocurr, use the ```fix_acl.sh``` script, that will remake the permissions based on ```acl.list``` file.

<script src="https://gist.github.com/lcnzg/51258738564989bc8e2b0b7d25397b02.js"></script>

Add execute permission to the script:
```
chmod +x fix_acl.sh
```

Run the script with sudo, this way:
```
sudo ./fix_acl.sh
```


# References

- <https://www.digitalocean.com/community/tutorials/how-to-install-the-apache-web-server-on-ubuntu-16-04>
- <https://www.digitalocean.com/community/tutorials/how-to-setup-a-firewall-with-ufw-on-an-ubuntu-and-debian-cloud-server>
- <https://www.digitalocean.com/community/tutorials/how-to-set-up-vsftpd-for-a-user-s-directory-on-ubuntu-16-04>


*Post written by [Luciano Zago](https://github.com/lcnzg).*
