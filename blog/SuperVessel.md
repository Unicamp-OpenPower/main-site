---
title: Setting Up SuperVessel and SSH connection to Machines on Debian Based
layout: page
date: 2016-08-19
author: Guilherme Lucas
---

# Setting Up SuperVessel and SSh connection to the Machines on Debian Based
SuperVessel is a cloud based plataform created by IBM Research - China
It allows you to set up containers on the cloud to run experiments, 
test aplications, do some data analysis and so on. One great feature
of SuperVessel is to allow FPGA and GPU acelleration for C/C++
aplications.

## Creating an acount on SuperVessel
First, go to the page below:

```
https://ptopenlab.com/cloudlabconsole/?cm_mc_uid=35942743919214714482383&cm_mc_sid_50200000=1471628149#/
```
When you reach this adress, you will see that the first item of the
Service Zone is for **SuperVessel Cloud**. Click on **Apply VM -> Direct Acces**.
After doing that, you can **login**, or **create an account**. You can login as **Community user** . Do one of these
steps and you have an SuperVessel account. This wil allow you to use all the other services on the page, like Acceleration and Big Data Services.

## Setting up a Machine
After creating an account, you're good to launch a machine. On the left side of the page, click on **Instances**. On the up menu of the page, there is a **Current Region** box. Make sure it is assigned to Beijing so we can access the machines via SSH easily.
Now, click on **Launch Instance**. This should redirect you to a page with the specs of the machine on it. On the first drop-down menu, select **Launch Docker Image** and choose the specs that best fit your needs and then click on the button on the bottom of the forms to launch the instance and wait. It will appear a box with the instance's information. If you want to access the machine from the browser, go to **More Actions -> Console**. The informations to log in appear on the top of the terminal.

## Connecting VPN
First, install the VPNC:
```
sudo apt-get install vpnc
```
Then, create a SuperVessel conf file with the following command:
```
sudo vim /etc/vpnc/supervessel.conf
```
Note: you can use any editor, just don't forget to run with sudo or as root user.
The content of this file has to be:
```
IPSec gateway 36.110.51.131
IPSec ID Gemini    
IPSec secret G3m!ni1bmVpn           
Xauth username PoXXXX (change PoXXXX to your own VPN account)    
Xauth password secret_password (change secret_passsword to your own VPN password) 
```
The Xauth username and password have to be changed to your personal informattion, that you can find at the person symbol ate the upper left of the SuperVessel page, that you used to create an instance. Click on **VPN Conf** and put the Beijing fields on the **supervessel.conf** file.
Now, run the vpnc:

```
sudo vpnc-connect supervessel.conf
```
A message like that should appear:
```
VPNC started in background (pid: 12434)...
```

## Running SSH
Now, on the **Instances** page, find the **External IP(VPN)** field. Now run:
```
ssh opuser@ExternalIP 
```
Note: change ExternalIP with the number you just saw. You can use ssh -X to xforward and ssh -C to compress connection.

After you logout, don't forget to run :
```
sudo vpnc-disconnect
```
That should do the work!

Post written by Guilherme Lucas.
You can see some of my work at https://github.com/Guilhermeslucas .

