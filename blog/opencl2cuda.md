---
title: Introduction to OpenCL2CUDA
layout: page 
date: 2017-06-07
author: Guilherme Lucas
---

# Introduction to OpenCL2CUDA
We all know that software is replacing many people functions. Said that, many very complicated data processing
are now made by computers, that are getting better and better ways to do those tasks. There are many libraries
and frameworks that helps programmers and engineers writing code to process some big amount of data. Two of these
well known libraries are OpenCL, developed for heterogeneous computing (gpu, processors, fpga), and CUDA, a NVIDIA
library created so people can write code to run on their GPUs. These libraries have some similar routines, cause there 
are many steps you have to do on both of them. Thinking about it, I started writing a OpenCL to CUDA converter.

## Implementation
The implementation of this code still really simple, since all I am doing is searching for some OpenCL functions and
replacing it for its equivalent on CUDA. Besides, if its not a direct translation, the converter suggests some possible fixes
for you code. To find the suggestions on your code search for the #tranlation# word. We are using Python 3. To run this code 
all you have to do is:   

```
chmod +x createCUDAkernel.py (just the first time)
./createCUDAkernel.py --opencl_name="name of the opencl file" --main_name="name of the C/C++ file"
```

## How to contribute
Now, I am searching for CUDA and OpenCL codes that do the same thing, so I can go on this project. Besides, you can 
[fork](https://github.com/Guilhermeslucas/OpenCL2CUDA) the project on Github.

Thanks a lot.
