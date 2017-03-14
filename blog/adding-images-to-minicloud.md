---
title: Adding images to Minicloud
layout: page
date: 2017-02-22
author: Guilherme Tiaki Sato
---

**Note: This feature is disabled by default, and may be enabled upon request.**

To add your own images to Minicloud, open the **Images** section in the dashboard and select **Create image**

<center><img src="./adding_images_to_minicloud_images/1.png" width="80%"/></center>

Give it a name and optionally a description. To send the image file, it is possible browse and upload directly from your computer or provide an URL from which Minicloud can download it.

The **Format** is usually **QCOW2**. There is no need to fill the architecture. Choose a minimum RAM and Disk if necessary.

Confirm the image creation.

<center><img src="./adding_images_to_minicloud_images/2.png" width="80%"/></center>

After the process finishes, choose **Update Metadata** and add the following property:

	hw_video_model

<center><img src="./adding_images_to_minicloud_images/3.png" width="80%"/></center>

<center><img src="./adding_images_to_minicloud_images/4.png" width="80%"/></center>

Attribute the following value to it:

	vga

<center><img src="./adding_images_to_minicloud_images/5.png" width="80%"/></center>

You can now launch an instance as usual.


