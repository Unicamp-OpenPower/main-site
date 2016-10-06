---
title: A Brief tutorial about how to use the SDAccel service
layout: page 
date: 2016-10-06
author: Guilherme Lucas
---

# How to use the SDAccel Service
SDAccel is a service that allow the user to load C/C++ aplications and optmize it using FPGA acceleration.
To use this service, first go to the link below:

```
https://ny1.ptopenlab.com/sdaccel/auth/login/?next=/sdaccel/project/#/projects/b767365a-8402-41a5-97b4-d148c359b114/detail?_k=p64eew
```

In this page, you can enter your username and password to log in the SDAccel service. If you do not have on account,
just create one and get back to that link.

You will be redirect to a page with the following tabs:
- *Overview* : this page contains some explanation about how the SDAccel is built and the advantages of using a service like that.
- *Document* : tutorials about SDAccel and some C/C++ code to run.
- *Project* : manage your projects and upload some code.

To create a new project, go to *Project* -> *New Project*.

Just put a any name and description and press *Submit*.

Click on the project name (that should be blue) and you wil be redirect to a files page.

Go to the *compile* tab and wait a little till the loading is finished and, the *console password* on the password place and hit *Enter*.
A desktop environment will appear on the screen.

Now, on the virtualized desktop, go to *Applications* -> *System Tools* -> *Terminal*. Now type the following commands:

```
cd 
mkdir test
cd test
git clone https://github.com/Guilhermeslucas/SDAccel_Examples.git
```

Now, close the terminal and click on the *SDAccel Icon* on the desktop, and hit ok on the first window and *close the welcome tab*.

On the *Project Explorer* -> *New* -> *Xilinx SDAccel Project*

Now, enter any string to be the *Project Name* and change the locarion for the folder you placed the vadd project(just the *src* folder, from de *SDACell_Examples*.
I will name the project as *tutorial_code*.
The next step, is to click with the right button of the button on the *project folder* and hit *build project*. It will ask you to create a solution.
Go ahed and create one. In order to do that click on *add*(change the name if you want) -> *ok* -> *>>* -> *ok*
Now, try to build the project again as we said above (it should take some seconds).

Now, open a *terminal* and go to the *src* folder for the project we are using. In that folder, should appear o .tcl file. Type:

```
sdaccel "some_name".tcl
```

It will run and the results will appear on the folder.
Hope it was helpful.
