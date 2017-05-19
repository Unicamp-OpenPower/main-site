---
title: How to recover access to a Minicloud instance
layout: page
date: 2017-05-18
author: Guilherme Tiaki Sato
---

If you lost your private key, there is no way to recover it, however, you can still access your instances by assigning a new key to it

First, creste a new key (either importing or creating a new one directly)

<img src="./how-to-recover-access-to-a-minicloud-instance-images/1-create-new-key.png" width="100%"/>

Then, shut off your inaccessible instance

<img src="./how-to-recover-access-to-a-minicloud-instance-images/2-shut-off-instance.png" width="100%"/>

Now, create a snapshot of it

<img src="./how-to-recover-access-to-a-minicloud-instance-images/3-create-snapshot.png" width="100%"/>

Using the snapshot as image, launch a new instance, and select the newly created key.

<img src="./how-to-recover-access-to-a-minicloud-instance-images/4-launch-instance.png" width="100%"/>

<img src="./how-to-recover-access-to-a-minicloud-instance-images/5-select-new-key-pair.png" width="100%"/>

Now you can [connect to the new instance as usual](./minicloud-tutorial.html#3-accessing-our-virtual-machine). The username remains the same as before.