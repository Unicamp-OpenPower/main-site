---
title: Setting up an OpenStack-based cloud with Power8 | Part 01 – Introduction 
layout: page 
date: 2015-08-20
author: Maurício Bezerra
---
#Introduction

In this series we are going to detail all the necessary steps to setup an OpenStack-based cloud with IBM POWER8 machines from the scratch, but first of all, let's take a look at some basic questions like what is OpenStack and why one would want to install and use it?

#What is OpenStack?

OpenStack is a free and open-source set of connected components aiming to serve as an cloud computing operating system capable of managing large pools of compute, storage and networking resources, all managed through a administrator dashboard. It's robustness and reliability as one of the most active open-source project today makes it an really good choice for offering cloud computing services ([IaaS](https://en.wikipedia.org/wiki/Cloud_computing#Infrastructure_as_a_service_.28IaaS.29)) on standarized hardware, and due to its simplicity and massive scalability it can be used as an solution for a large amout of users, from a small home environments with few machines to large datacenters with hundreds of machines.

The OpenStack project began first in 2010 as an joint project of Rackspace Hosting and NASA, today, the project itself is managed by the OpenStack Foundation and have more than 500 supporters among companies and research centers.

![OpenStack Services](http://i.imgur.com/PNQ4Dro.png)

#Components

The main project is implemented in a modular architecture with many components, each one performing its own responsibility in the system. The diagram below can be found at the OpenStack official documentation:

![OpenStack components connections](http://i.imgur.com/QiQGJHe.png)

##Horizon (Dashboard)

This component responsibility consists in providing a web-based interface to easily access the OpenStack services.

##Compute (Nova)

The main part of any IaaS system, the Nova project performs the controller role, managing and automating pools of computer resources. It supports many virtualization technologies and is it responsibility to manage the virtual machines on the system.

##Networking (Neutron)

Manages the networks and IP adresses, providing users total control over network configurations. Standard network models works with separate VLANs for each user to distribute the network access, the Neutron component treats the question differently, managing the IP adressess, allowing a more flexible and maintainable network usage.

##Object Storage (Swift)

The Swift component stores and retrieves unstructured data object through the HTTP based APIs.

##Block Storage (Cinder)

Provides persistent storage to running services, its implemented in such a way that makes creating and managing block storage very easy.

##Identity Service (Keystone)

This provides a central directory of users mapped to the OpenStack services. It is used to provide an authentication and authorization service for other OpenStack services.

##Image Service (Glance)

This provides the discovery, registration and delivery services for the disk and server images. It stores and retrieves the virtual machine disk image.

##Telemetry (Ceilometer)

It monitors the usage of the Cloud services and decides the billing accordingly. This component is also used to decide the scalability and obtain the statistics regarding the usage.

##Orchestration (Heat)

This component manages multiple Cloud applications through an OpenStack-native REST API and a CloudFormation-compatible Query API.

#Why would I use OpenStack?

In sight of all the features listed above and all the benefits that OpenStack can offer to its users and administrators we choose it to serve as infrastructure to our POWER8-based cloud, the steps to setup and manage the system will be discussed throughout the next series posts, keep in touch!

#Sources:

[Wikipedia OpenStack article](https://en.wikipedia.org/wiki/OpenStack)

[Official OpenStack documentation](http://docs.openstack.org)
