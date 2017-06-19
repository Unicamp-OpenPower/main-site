---
title: Introduction to PowerGraph
layout: page 
date: 2017-05-30
author: Guilherme Lucas, Rafael Pimenta and Rafael Sene
---

# Introduction to PowerGraph  
As computers evolve, people are trying new methods do analyse how good some machine
is when compared to another one. The amount of energy that some machine is 
consuming, seems to be a nice measure, once we are willing to produce faster and
cheaper. 
IPMI(Intelligent Platform Management Interface), on the other side,
is a set of computer interface specifications for an autonomous computer 
subsystem that provides management and monitoring capabilities independently 
of the host system. One of the measures that IPMI allow us to do is:   
```
dcmi power reading
```
This command shows the instant power consumption. With this tools, my team decided
to create a software that gets informations about the consumption of a machine
and exports it on a readable way. Thats how we did it:

## Infrastructure
The infrastructure was not so complicated to configure. We have to download some
packages and set some configurations (process we are automating with Ansible). All
the system is deployed on Minicloud. The packages (all via apt) we are using are:   

- ipmitool
- apache2
- python2.7
- python-pip
- git 
- htop
- tmux

Besides, we are using ```crontab``` to be sure our service is still runing, and if 
it is not, restart it. We are doing this verification every ten minutes with the
```killer.sh``` script. 
To solve all ```Python``` dependencies you can run:   

```
pip install -r requirements.txt
```
### Apache configurations
Here you will install two modules in your apache server and change the virtual
host configuration file. Doing this you will be able to control your browser's cache.

In your server terminal run:
```
sudo a2enmod headers
sudo a2enmod expires
sudo service apache2 restart
```
After that, find your virtual host configuration file
(*/etc/apache2/sites-available/default/000-default.conf* if you are using ubuntu OS)
and insert the following lines, adjusting the parameters according to your needs:

```
<Directory /var/www/html>
   ExpiresActive On
   ExpiresDefault "access plus 10 minutes"
   ExpiresByType text/html "access plus 1 day"
   ExpiresByType text/javascript "access plus 1 day"

   # if it is your interest, you can set a specific expiration time for your csv file
   # ExpiresByType text/csv "access plus 30 seconds"

   <FilesMatch "file.csv">
         Header set Cache-control "no-cache"
   </FilesMatch>
</Directory>
```
## Back-end code
PowerGraph was totally developed using ```Python```. There are three main codes:   

- powergraph.py
- graph_csv.py
- csvcreator.py

Below, I will explain each code and its function.

### powergraph.py   
This is the code that keeps getting power info about a machine and save it to 
```tinyDB``` or prompt the result to user. You can run it using the command:

```
python2.7 powergraph.py --host="server address" --port="server port" 
--user="allowed user" --passwd="password for this user"
```
You can use the optional parameter ```--store``` in order to save the infos 
as json on tinydb. Without this parameter, the script will print on the terminal. 
Besides, you can use ```--feedback``` with store in order to see the measures 
status. 
If you want to set the time interval that a new csv file is generated, you can 
use the flag ```--csv_interval```. The ```--tail_length``` is used to set the 
number of lines the csv file will have.

### csvcreator.py   
This is the code that converts the JSON stored on ```tinyDB``` for a ```csv```
file. This code is really important, cause our front end is expecting a ```csv``` 
with two columns: timestamp and consumption.
In order to run this code, you have to store the data of ```powergraph.py``` on the
database, as we explained before. To run this use:

```
python2.7 csvcreator.py --jsonfile="generated_json_name"
```

There are two optional arguments: ```--date```, to create the csv only with 
the data from a specific day and ```--name```, with the name you want your 
```csv``` file.

### graph_csv.py
This is the code that orchestrates the other ones. It is a multithread code that 
creates one thread always running with the ```powergraph.py``` code and another 
one generating a new thread with ```csvcreator``` running from time to time
updating the measures. To run this code use:

```
python2.7 graph_csv.py --host="server address" --port="server port" 
--user="allowed user" --passwd="password for this user" 
--jsonfile="path to bd jsonfile"
```

Besides, you can use the following optional arguments:   

- interval: interval between each ipmi measure (default=10)
- nread: number of ipmi measures to be done (default=infinity)
- csv_interval: interval that a new csv file is made (deafult=300s)
- tail_length: size of the csv files (default=300)

## Front-end code
In order to create an interactive website that plot a graph from the csv file,
you first need to deal with the following dependencies:

- apache configurations
- javascript libraries

After that, we have developed the code in **javascript/graph.js** where
you can read and present in real time the data provided by the back-end.

### Javascript libraries
Here we have three libraries included in our html file (index.html).

The first one is the **D3.js** library, a worldwide known tool to create
dynamic and interactive data visualizations, in other words, this is the engine
of the website. Insert in your html body the `<script src="http://d3js.org/d3.v4.min.js"></script>`
to get the most recent code from D3.js.

The next library, **Moment.js**, is used to manipulate date objects and in our
case, for example, it allows us to show the time adjusted to the user's location.
You can download the code from the following address https://momentjs.com/downloads/moment.min.js.

Finally, the **D3-tip** library just inserts tooltips in the graph for a better experience of use. This library was donwloaded from https://github.com/Caged/d3-tip/blob/master/index.js. It is also interesting that you take a look our style implementation for the tooltips from the file **style/style.css**.

## Conclusion  
If you want to see the project working, acces this 
[link](http://177.220.10.134/powergraph). If you want to contribute, acces the 
[github link](https://github.com/Unicamp-OpenPower/powergraph). Hope you all enjoy 
it. Thanks a lot!
