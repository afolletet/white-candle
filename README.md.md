# white-candle : Pentest Environment for Beginners - My First Git Repository

[![Build Status](https://travis-ci.org/joemccann/dillinger.svg?branch=master)](https://travis-ci.org/joemccann/dillinger)

This Environment was created in order to allow the practice of penetration testing on a web server by the mean of 2 Virtual Machines (which redundancy is insured by a load balancer) running the Damn vulnerable Web App, peered with an ELK Stack environment to log and analyse traffic. 

The files in this repository were used to configure the network depicted below.

![NS Resource Group](https://github.com/afolletet/white-candle/blob/main/3.%20Diagrams/NA-Network.drawio)

These files have been tested and used to generate a live ELK deployment on Azure. They can be used to either recreate the entire deployment pictured above. 
Alternatively, select portions of the playbook file may be used to install only certain pieces of it, such as Filebeat.

![Playbook](https://github.com/afolletet/white-candle/blob/main/2.%20Ansible%20Scripts/Docker4DVWA.yml)

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

The machines on the internal network are not exposed to the public Internet. Only the Jump Box machine can accept connections from the Internet. Access to this machine is only allowed from the following IP address:
- 142.126.0.0/16

As a consequence of the statement above, machines within the network can only be accessed via de Jump box, which means that the Elk-Machine is also only accessible via the container on the Jump Box (JB Public IP : 20.185.68.208)

A summary of the access policies in place can be found in the table below.

| Name     | Publicly Accessible | Allowed IP Addresses |
|----------|---------------------|----------------------|
| Jump Box | Yes                 | 20.185.68.208        |
|          |                     |                      |
|          |                     |                      |

### Elk Configuration

Ansible was used to automate configuration of the ELK machine. No configuration was performed manually, which is advantageous because it's time saving and can be repeated over and over with no (or very few) error. 

The playbook implements the following tasks:
- Install the docker.io deamon on the Elk Machine (Attention! Do not confuse with the other Linux package "docker", specify ".io")
- Install the python package-management system "pip", so the ELK stack (fully written in Python) can run smoothly when installed
- Install the Docker module
- Increase the virtual memory to allow ELK, a very resource consuming suite, to perform without any memory outage risk
- Download the ELK Stack image from the Docker container library and launch it (kibana on port 5601, Elastic Search on port 9200 and Logstach on port 5044)

The following screenshot displays the result of running `docker ps` after successfully configuring the ELK instance.

![Dpcker ps](Images/docker_ps_output.png)

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

SSH into the control node and follow the steps below:
- For tidiness purposes, I suggest that you copy all the .yml scripts (among which the ElkAnsible.yml file) into the etc/ansible/files/ folder in your Ansible controle node (container located in your JumpBox). You will be able to refer to them in a unique location. In any way you should copy those files into a folder inside the container/Ansible controle node. 
- Under etc/ansible/, update the following files: 
    * ansible.config : uncomment the line 107 and edit to: remote_user = [your_VM_username]
    * hosts: uncomment line 19 so 'webservers' appear in square brackets in white + add your VMs IPs to the list below (you should have XX.XX.XX.XX ansible_python_interpreter=/usr/bin/python3 for each IP and this should nt be commented)
- Run the playbook by using ansible-playbook filename.yml
- vigate to --- to check that the installation worked as expected.

Follow this spot check when setting the environement:
Which file is the playbook? Where do you copy it?_
Which file do you update to make Ansible run the playbook on a specific machine? How do I specify which machine to install the ELK server on versus which to install Filebeat on?_
In order to make sure that the ELK server is running, you can visit this URL: http://*[ElkMachinePublicIP]*:5601/app/kibana

commands to download the playbook, update the files, etc._







