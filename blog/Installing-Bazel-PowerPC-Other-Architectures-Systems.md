---
title: Installing Bazel on PowerPC and Other Unsupported Architectures/Systems
layout: page
date: 2018-11-07
author: Gustavo Salibi
---
Bazel is a free software tool that allows for the automation of building and testing of software. Similar to build tools like Make, Maven, and Gradle, Bazel builds software applications from source code using a set of rules.

It uses a human-readable, high-level build language. Bazel supports projects in multiple languages and builds outputs for multiple platforms and supports large codebases across multiple repositories, and large numbers of users.

In designing Bazel, emphasis has been placed on build speed, correctness, and reproducibility. The tool uses parallelization to speed up parts of the build process. It includes a Bazel Query language that can be used to analyze build dependencies in complex build graphs

Bazel must have PowerPC support in the future, making its installation possible through community-supported methods. However, currently, if you want to install on PowerPC or other architectures or systems that do not have support, you need compiling Bazel from source.

So let's see how to install Bazel on architectures and systems not officially supported. I will use Ubuntu 14.04 as the basis of this tutorial, but it can be easily adapted to other Linux systems.


# Building Bazel from scratch (bootstrapping)

Here we will see how to do self-compilation. If you use Ubuntu 14.04 or Ubuntu 16.04 in ppc64le, you can skip right to: Using ready binaries. <a href="#ready">Visit the Useful Tips Section</a>

<div id="ready">Useful Tips Section</div>
