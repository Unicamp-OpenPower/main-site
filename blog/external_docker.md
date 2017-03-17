---
title: Acessing a Docker Container outside Minicloud
layout: page
date: 2017-03-14
author: Guilherme Lucas
---


#Acessing a Docker Container outside Minicloud
Docker containers are widely used nowadays for making software development and delivery easier, since it isolates the container from the rest of the system. This is very useful, cause the developer can install any software, depencies to run the project perfectly, delivering the "whole package" to anyone who wants to run it. 
Some applications are expected to access or be accessed from outside, like a webserver, Jenkins, and so on. To do it, you have to map a container port with a server port. 

## Maping a Container port with a server port
Is very simple and useful to do it. All you have to do is to include a parameter on command line when launching a container with ```docker run```, like this example running a Jenkins container:

```
docker run -i -t -p "physical machine port":"container port" guilhermeslucas/jenkins:2.0 /bin/bash
```

In this example Jenkins container is running through port "container port" and you can access it by reaching the "physical machine port" of the server. 

## Acessing Docker Container from a local browser
Some applications are configured or managed using the browser. In this case, you can run the application on a server, but configure it using a ssh tunnel on your local machine. This is very simple too, just add a parameter on the ssh command line, mapping it correctly, like the example.

```
ssh user@host -L local-port:host:remote-port
```

it can be used like:

```
ssh guilherme@123.456.78.910 -L 8080:localhost:8080
```

In this example, the 8080 remote port will be forward to ```localhost:8080``` and you can access it via browser.

So, you'll have to map a container port with a server port and forward this server port on your localhost, on any port not in use.

This should do the work.

Written by Guilherme Lucas. You can see some of my work at my [Github Page](https://github.com/Guilhermeslucas).
