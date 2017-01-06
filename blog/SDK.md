---
title: How to Install IBM SDK on Ubuntu 16.04 Power Machines
layout: page
date: 2016-05-30
author: Guilherme Lucas da Silva
---

This is a brief tutorial about how to install the IBM SDK on Power Machines. I decided
to do this, cause Ubuntu 16.04 is not oficially supported, but it is possible to install it through the provided packages.

# Downloading Packages
You can use a script to download the necessary packages in the link above:

```
ftp://ftp.unicamp.br/pub/linuxpatch/toolchain/at/at_downloader/?cm_mc_uid=92476109699314629396752&cm_mc_sid_50200000=1464625581
```
Download the script and change its permission with the command above:

```
chmod +x <script name>
```
And then run the script with:

```
./<script name>
```

Please download the packages for Ubuntu 14.10. Then, the folder will be full of .deb
files. The next step is to install some of these packages using dpkg.

# Instaling Packages and Toolchain
Now, you need to install some of these. This is simple, but you have to do it following
the order above. The command for each of those is
```
dpkg -i <package name>
```
The correct order is (the X is the version of the software):
```
advance-toolchain-atX.X-runtime-X.X-X
advance-toolchain-atX.X-devel-X.X-X
advance-toolchain-atX.X-perf-X.X-X
advance-toolchain-atX.X-mcore-libs-X.X-X
```
You can ignore the errors and move on.

# Installing IBM SDK
After all the dependencies issues are solved, you can run

```
apt-get install ibm-sdk-lop
```
and try to run the software.
	

Note: to run the ibm-sdk-loop on the Power Machines using ssh, you will have to connect 
to the server using

```
ssh -XC -c blowfish-cbc,arcfour <user>@<host> -p <port_number>
``` 

The blowfish-cbc,arcfour will make your connection even better.
This command is necessary to xforward the image of the sdk running.
Note2: if you get the "no matching cipher found" error, here you go the solution:

run the command above:
```
ssh -Q cipher localhost | paste -d , -s
```

Now its time to change the sshd_config file on the server(super privileges needed).
Add on the /etc/ssh/sshd_config a line with:
```
Ciphers <output of the last command>
```

Reboot the machine to make this alterations running:
```
sudo shutdown -r now
```

Post written by Guilherme Lucas.
You can see some of my work at https://github.com/Guilhermeslucas .

