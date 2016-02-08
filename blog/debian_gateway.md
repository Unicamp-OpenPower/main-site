---
title: Setting up a Debian Gateway Virtual Machine on PowerKVM 
layout: page 
date: 2015-08-08
author: Juliana Rodrigues
---

There are many reasons why one would want to build its custom router instead of buying one. Control and flexibility are two reasons, and we need both when dealing with large traffic. The purpose of this guide is to give a step-by-step solution starting on how to build a virtual machine. For this, we will assume that PowerKVM is already up and running along with its network configurations.
 
So, for this guide we will need:

* A PowerKVM machine
* Two network cards


In this case, **eth0** will be our internal network interface and **eth1** our external network interface. Both of them will be bridged to the virtual machine and this configuration can be made through Kimchi's web interface.

# Creating a Debian Virtual Machine

## Downloading the right ISO
First we'll download Debian's 8.1 DVD Image for PPC64el architecture. It can be found on [this link](http://cdimage.debian.org/debian-cd/8.1.0/ppc64el/iso-dvd/) and should be stored in /var/lib/kimchi/isos/ folder.

```
cd /var/lib/kimchi/isos
wget http://cdimage.debian.org/debian-cd/8.1.0/ppc64el/iso-dvd/debian-8.1.0-ppc64el-DVD-1.iso
```


Then run *md5sum* to see if the file is corrupted:
```
wget http://cdimage.debian.org/debian-cd/8.1.0/ppc64el/iso-dvd/MD5SUMS
md5sum -c MD5SUMS
```

The result should be:
```
debian-8.1.0-ppc64el-DVD-1.iso: OK
```

Otherwise, try downloading again.

## Bringing to Life
Now that we have our ISO, we'll create an *qcow2* image using *qemu* to act as a hard drive. Those images should be stored in */var/lib/libvirt/images/*.
```
qemu-img create -f qcow2 -o preallocation=metadata storage.qcow2 10G
```

Then, we can start the installation using *virt-install*:
```
virt-install -r 12228 --os-variant=debianwheezy --network bridge=virbr0,model=virtio --accelerate -n debian --vcpus=maxvcpus=16,sockets=2,cores=2,threads=4 -f ./storage.qcow2 --graphics vnc,listen=0.0.0.0 -c /var/lib/kimchi/isos/debian-8.1.0-ppc64el-DVD-1.iso
```

If you're using a different OS, you can list all available options with:
```
virt-install --os-variant list
```

Instalation will start. In this case, it was done throught Kimchi's web monitor, but can be done using libvirt. Proceed normally. After it's finished, you can start your VM and login with:
```
virsh start debian
virsh console debian
```

#Network Configuration

As said before, **eth0** and **eth1** will be bridged to the VM through Kimchi's web interface, where **eth0** is our internal network interface and **eth1**, external network.

##Setting IPs
We'll edit */etc/network/interfaces* file and assign static IP's both internal and external. Your external address and gateway should be provided by your ISP.
```
nano /etc/network/interfaces
```

```
auto lo
iface lo inet loopback

# The primary network interface
allow-hotplug eth0
iface eth0 inet static
   address 10.0.0.1
   netmask 255.255.255.0

allow-hotplug eth1
iface eth1 inet static
   address 0.0.0.0
   netmask 255.255.255.0
   gateway 0.0.0.0
```

Edit your */etc/resolv.conf* if needed by your ISP:
```
nano /etc/resolv.conf
```

```
nameserver ISP_server;
search ISP_address;
```

After restarting your network service, you should have something like this:
```
systemctl restart networking && ifconfig

eth0      Link encap:Ethernet  HWaddr 52:54:00:37:bc:11
          inet addr:10.0.0.1  Bcast:10.0.0.255  Mask:255.255.255.0

eth1      Link encap:Ethernet  HWaddr 52:54:00:7b:74:6f
          inet addr: 0.0.0.0  Bcast:0.0.0.0  Mask:255.255.255.0

lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
```

See if it's working by pinging internal and external addresses:
```
ping www.cnn.com 
ping 10.0.0.5
```

##Routing
Start by flushing all previous configurations, if they exist.
```
iptables -F
iptables -t nat -F
iptables -t mangle -F
iptables -X
```

We'll now allow established connections, outgoing connections and setup masquerade as follows:
```
iptables -A INPUT -i lo -j ACCEPT
iptables -A FORWARD -i eth1 -o eth0 -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -i eth0 -o eth1 -j ACCEPT
iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE
```

And now, we'll allow IP Forwarding:
```
echo 1 > /proc/sys/net/ipv4/ip_forward
```

And your Iptables should look like this:
```
iptables -L
```

```
Chain INPUT (policy ACCEPT)
target     prot opt source               destination
ACCEPT     all  --  anywhere             anywhere

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination
ACCEPT     all  --  anywhere             anywhere             state RELATED,ESTABLISHED
ACCEPT     all  --  anywhere             anywhere

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination
```

Now a client should successfully connect to the internet.

##Making it Permanent
Now we want to apply these iptables configurations everytime we start this machine. This can be done by saving them in a file and restoring on the next boot.

```
iptables-save >> /etc/iptables.rules
```

On */etc/network/interfaces*, add this line underneath &ldquo;iface lo inet loopback&rdquo;:
```
nano /etc/network/interfaces
```

```
pre-up iptables-restore < /etc/iptables.rules
```

#That's it

By now you should have a basic Linux gateway for your network. Much more advanced configuration can be done that can add enormous flexibility. It's up to you to start exploring and unleash the true power of having a dedicated machine as your router.