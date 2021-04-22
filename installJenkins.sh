#! /bin/bash

#install Java
sudo yum install java-1.8.0-openjdk.x86_64 -y

#download ans Install Jekins
sudo yum update -y
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum install jenkins -y

#start Jenkins
systemctl start jenkins 

#Enable jenkins with systemctl
systemctl enable jenkins 

#install Git SCM
sudo yum install git -y 

#Enable service for jenkins
sudo chkconfig jenkins on


