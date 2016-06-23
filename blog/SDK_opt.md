---
title: Optimizing C/C++ applications
layout: page
date: 2016-05-30
author: Guilherme Lucas da Silva
---

# Optimizing C/C++ Applications with IBM SDK Build Advisor
This is a brief text about how to use the IBM SDK Build Advisor to optimize C/C++ aplications on Power Servers.

## Running seismic applications without optimization flags
Here are some results on Power Machine before the optimization process.  
real    0m46.837s   
real    0m48.391s  
real    0m52.570s  
real    0m49.249s  
real    0m48.863s   

## Importing a C\C++ Project to IBM SDK 
Before you begin, make sure there is a Makefile inside your project. Now, inside the SDK:  
1. Go to **File > Import**
2. In the import window, expand **C\C++** and click in **Existing Code as Makefile Project**
3. Now go to **Browse** next to the **Existing code Location**.
4. Type a name for your project
5. Locate the code and then click **OK**.
6. Back to the **Import Existing Code** window, click the Advanced Toolchain Version corresponding to the one you have installed on the Power Machine.
7. Click **Finish**

## Using the Build Advisor
1. Right Click on the project, go to **Properties**
2. Select the build advisor
3. Enable **Enable extra advice** and then **Finish**.
4. Right click on the project and build. The suggestions will appear.

## Final results
After using the flags that the SDK suggested 

```
-std=c99 -Ofast -fpeel-loops -flto -fopenmp -mcmodel=medium -ftree-vectorize -mcpu=power8 -mtune=power8 -funroll-loops
```
I got the following results:  
real	0m3.177s  
real	0m2.573s  
real	0m3.066s  
real	0m2.954s  
real	0m2.930s  

As you can see, Build Advisor is very effective.





