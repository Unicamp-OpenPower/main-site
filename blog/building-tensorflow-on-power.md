---
title: Building Tensorflow on POWER - CPU only
layout: page
date: 2018-01-16
author: Nathalia Harumi Kuromiya
---

TensorFlow is a widespread software library for numerical computation using data flow graphs. It is very common on machine learning and deep neural networks projects. Therefore, today we are going to see how to install it on POWER with CPU only configuration.  

<center><img src="./building-tensorflow-on-power-images/tf-logo.png" style="padding: 25px 0px"/></center>

Before installing TensorFlow, there are a couple of details we have to pay attention to:
1. Due to Bazel, one of TF dependencies, the operating system must be Ubuntu 14.04 or Ubuntu 16.04.
2. We are going to use Python 2.7, since TF doesn't seem to be supported by Python 3.5 <strong>on POWER</strong>.

# Tensorflow Dependencies
You can use the commands below to solve most of the dependencies:

<div class="codehilite"><pre><span></span>
<span data-text="# "></span>apt-get update
<span data-text="# "></span>apt-get install python-numpy python-dev python-pip python-wheel
</pre></div>

# Bazel installation
Bazel is one of the TF dependencies, but its installation is less intuitive than the others due to its community does not officially support POWER architecture. That said, we must compile it from the Source. First of all, we need to install its own dependencies by the following commands:

<div class="codehilite"><pre><span></span>
<span data-text="# "></span>apt-get update
<span data-text="# "></span>apt-get install unzip openjdk-8-jdk protobuf-compiler zip g++ zlib1g-dev
</pre></div>

It is also important to add enviroment variables on .bashrc for JDK.

<div class="codehilite"><pre><span></span>
<span data-text="# "></span>vi .bashrc
	export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-ppc64el
	export JRE_HOME=${JAVA_HOME}/jre
	export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib
	export PATH=${JAVA_HOME}/bin:$PATH
</pre></div>

For compiling Bazel, we are going to download and unpack its distribution archive (the zip file from the release page https://github.com/bazelbuild/bazel/releases. The .sh is not compatible with ppc64le) and compile it.

<div class="codehilite"><pre><span></span>
<span data-text="# "></span>mkdir bazel
<span data-text="# "></span>cd bazel
<span data-text="# "></span>wget -c https://github.com/bazelbuild/bazel/releases/download/0.9.0/bazel-0.9.0-dist.zip #if you want to download other version of bazel, this link must be switched by the one you are intenting to use.
<span data-text="# "></span>unzip bazel-0.9.0-dist.zip
<span data-text="# "></span>./compile.sh
</pre></div>

As we can see, this tutorial was tested with bazel 0.9.0, but feel free to try other version and see if it works properly.

# Installing Tensorflow

Since we are going to use the current version of TF, we need to clone it from the official GitHub and execute the configuration script.

<div class="codehilite"><pre><span></span>
<span data-text="# "></span>git clone https://github.com/tensorflow/tensorflow
<span data-text="# "></span>cd ~/tensorflow
<span data-text="# "></span>./configure
</pre></div>

On this step, we have to specify the pathname of all relevant TF dependencies and other build configuration options. On most of them we can use the answers suggested on each question. Here, I will show how it was done for this tutorial. (Yours might be a little different, depending on the pathnames)

<div class="codehilite"><pre><span></span>Please specify the location of python. [Default is /usr/bin/python]: <strong>/usr/bin/python2.7</strong>
Found possible Python library paths:
  /usr/local/lib/python2.7/dist-packages
  /usr/lib/python2.7/dist-packages
Please input the desired Python library path to use.  Default is [/usr/lib/python2.7/dist-packages]:<strong> /usr/lib/python2.7/dist-packages </strong>

Using python library path: /usr/local/lib/python2.7/dist-packages

#Y/N Answers given: All of them as suggested in each question.

Please specify optimization flags to use during compilation when bazel option "--config=opt" is specified [Default is -march=native]: <strong>-mcpu=native</strong>
Configuration finished
</pre></div>

To build and install TF, we use:

<div class="codehilite"><pre><span></span>
<span data-text="# "></span>bazel build --copt="-mcpu=native" --jobs 1 --local_resources 2048,0.5,1.0 //tensorflow/tools/pip_package:build_pip_package
<span data-text="# "></span> bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg #creates the pip package
<span data-text="# "></span>$ sudo pip install /tmp/tensorflow_pkg/tensorflow-1.5.0rc0-cp27-cp27mu-linux_ppc64le.whl #installs the pip package. This name depends on your operating system, Python version and CPU only vs. GPU support. Therefore, check it out its name before this step.
</pre></div>

By this moment, your TF must be working. Remember not to import it into its own directory: you have to chance directory before execute Python.

# Build Issues and Support Websites:

While testing this tutorial, I could separate some useful issues reports and links to help some of the troubles you might have on the way.

1. https://github.com/tensorflow/tensorflow/issues/14540 It solves a protobuf problem I had. It seems pretty common on PPC TF installation.
2. https://github.com/tensorflow/tensorflow/issues/349 This one is about local resources. If you are running out of memory (your build fails on C++ compilation rules), you have to specify your resources on the command line when you build TF. On the tutorial, it is already done.
3. https://www.tensorflow.org/install/install_sources An official tutorial about how to install TF from Sources
4. https://docs.bazel.build/versions/master/install-compile-source.html An official tutorial about how to install Bazel from Sources.
5. https://www.ibm.com/developerworks/community/blogs/fe313521-2e95-46f2-817d-44a4f27eba32/entry/Building_TensorFlow_on_OpenPOWER_Linux_Systems?lang=en IBM source about Tensorflow installation. Provides interesting information about bazel installation on PPC and how to install TF with GPU support. It also points to an IBM Bazel modified to PPC (which we are not using in this tutorial, but you can take a look on it).
6. https://github.com/tensorflow/tensorflow/issues/7979#issuecomment-283559640 An issue about enviroment variables: on the configuration step, if it does not recognize some of the TF variables, this might help you to solve the problem.
