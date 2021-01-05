# white-candle : Pentest Environment for Beginners - My First Git Repository

[![Build Status](https://travis-ci.org/joemccann/dillinger.svg?branch=master)](https://travis-ci.org/joemccann/dillinger)

This Environment was created in order to allow the practice of penetration testing on a web server by the mean of 2 Virtual Machines (which redundancy is insured by a load balancer) running the Damn vulnerable Web App, peered with an ELK Stack environment to log and analyse traffic. 

The files in this repository were used to configure the network depicted below.

![NS Resource Group](https://github.com/afolletet/white-candle/blob/main/3.%20Diagrams/NA-Network.png?raw=true)

These files have been tested and used to generate a live ELK deployment on Azure. They can be used to either recreate the entire deployment pictured above. 
Alternatively, select portions of the playbook file may be used to install only certain pieces of it, such as Filebeat.

![Playbook](https://github.com/afolletet/white-candle/blob/main/2.%20Ansible%20Scripts/Docker4DVWA.yml.ylm)

This document contains the following details:
- Description of the Topology
- Access Policies
- ELK Configuration
  - Beats in Use
  - Machines Being Monitored
- How to Use the Ansible Build

### Description of the Topology

The main purpose of this network is to expose a load-balanced and monitored instance of DVWA, the D*mn Vulnerable Web Application.

Load balancing ensures that the application will be highly redundant, allowing consistant availability through attempted DoS attacks, in addition to restricting access to the network through load balancing rules.
Since the servers VMs will be highly vulnerable, the use of a jump box reduces the attack surface by not exposing every machine directly to the public internet (restricting external connections on the VMs).

Integrating an ELK server allows users to easily monitor the vulnerable VMs for changes to the logs and system performance.
Filebeat will retrieve files (mostly logfiles) while Metricbeat will retrieve statistical data (Disk Usage, Inbound traffic, Memory Usage etc..) from the hosts (as many as they are). Both data streams will be sent to Elastic search for storage.

The configuration details of each machine may be found below.

| Name        | Function          | IP Address     | Operating System |
|-------------|-------------------|----------------|------------------|
| Jump Box    | Gateway           | 10.0.0.1       | Linux            |
| Web-1       | Training Server   | 10.0.0.5       | Linux            |
| Web-2       | Training Server   | 10.0.0.7       | Linux            |  
| Web-3       | Training Server   | 10.0.0.8       | Linux            |
| ELK-Machine | Monitoring Server | 20.191.111.206 | Linux            |

### Access Policies

The machines on the internal network are not exposed to the public Internet. Only the Jump Box machine can accept connections from the Internet. Access to this machine is only allowed from the following IP address range:
- 142.126.0.0/16

As a consequence of the statement above, machines within the network can only be accessed via de Jump box, which means that the Elk-Machine is also only accessible via the container on the Jump Box (JB Public IP : 20.185.68.208)

A summary of the access policies in place can be found in the table below.

| Name          | Publicly Accessible | Allowed IP Addresses      |
|---------------|---------------------|---------------------------|
| Jump Box      | Yes                 | 142.126.0.0/16            |
| Web-1         | No                  | 10.0.1.4 / 52.188.168.137 |
| Web-2         | No                  | 10.0.1.4 / 52.188.168.137 |
| Web-3         | No                  | 10.0.1.4 / 52.188.168.137 |
| Elk-Machine   | No                  | 10.0.1.4                  |

### Elk Configuration

Ansible was used to automate configuration of the ELK machine. No configuration was performed manually, which is advantageous because it's time saving and can be repeated over and over with no (or very few) error. 

The playbook implements the following tasks:
- Install the docker.io deamon on the Elk Machine (Attention! Do not confuse with the other Linux package "docker", specify ".io")
- Install the python package-management system "pip", so the ELK stack (fully written in Python) can run smoothly when installed
- Install the Docker module
- Increase the virtual memory to allow ELK, a very resource consuming suite, to perform without any memory outage risk
- Download the ELK Stack image from the Docker container library and launch it (kibana on port 5601, Elastic Search on port 9200 and Logstach on port 5044)

The following screenshot displays the result of running `docker ps` after successfully configuring the ELK instance.

![Docker ps](https://github.com/afolletet/white-candle/blob/main/DockerPS_output.png?raw=true)

### Target Machines & Beats
This ELK server is configured to monitor the following machines (all three being part of the same backend load balancing pool):
Web-1 : 10.0.0.5
Web-2 : 10.0.0.7
Web-3 : 10.0.0.8
The Elk server can "talk" with the three listed Web servers (1,2 &3) thanks to the bridge created between their two distinct Virtual Networks via peering.  

We have installed the following Beats on these machines:
- Filebeat 
- Metricbeat

These Beats allow us to collect the following information from each machine:
Filebeat takes care of the "what" by providing activity logs that can range from ssh logins and new users and groups creations to commands run by hostname. Meanwhile Metricbeat deals with the "how" by providing relevant information on the impacts all the commands run on DVWA have on the system's information (CPU and Disk usage). This will provide an idea of the scale of each action and give the cybersecurity trainees an opportunity to adapt their attacks and mitigation measures. 

### Using the Playbook
In order to use the playbook, you will need to have an Ansible control node already configured. Assuming you have such a control node provisioned: 

All the following steps should be performed in the container a.k.a Ansible control node:

[x] Copy all the .yml scripts to the etc/ansible/files/ folder

[x] You should have: 
    - One playbook to set the docker for DVWA
    - One playbook to set the Elk server & docker on the Elk Machine 
    - One playbook to set Filebeat
    - One playbook to set Metricbeat

*Note: In order to run the playbook correctly we need to tell the ansible config files to which virtual machine they should manage*

[x] In etc/ansible/, update the following files: 
**ansible.config** : **1**. Uncomment the line 107 **2**. Edit it to --> remote_user = [your_VM_username]
**hosts**:  **1**. Uncomment line 19 --> [webservers] **2**. Add your Virtual Machines' IPs to the list below [webservers] using this syntax, each IP having a new line (like this)👉 --> 255.255.255.255 ansible_python_interpreter=/usr/bin/python3 **3**. 👍 This is the first configured host **4**. Create a new host from scratch with the same nomenclature for the Elk server 👉  [elk] 255.255.255.255 ansible_python_interpreter=/usr/bin/python3

*Note: in each playbook there is a mention about which host the docker will install on, this is why we need to configure these host an attribute IPs to them so ansible know where to deploy what. Example : in the DVWA playbook the host in the first lines is [webserver] and on the Elk playbook it is [elk].*

[x] Run one playbook at a time using the command : ansible-playbook filename.yml

[x] In order to make sure that the ELK server is running, you can visit this URL:   *http://[ElkMachinePublicIP]:5601/app/kibana*

*Note: as some of your environment's public IPs might be dynamic, any time your connections does not work, make sure to check that the IPs haven't changed.* 







