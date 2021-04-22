terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~>3.0"
    }
  }
}

# Configure what we need from aws
provider "aws"{
    region = "ap-south-1"
}

#Creating a VPC
resource "aws_vpc" "Lab-vpc"{
    cidr_block = var.cidr_block[0]
    tags = {
        Name = "MyFirstTerraVPC"
    }
}


#create a public subnet
resource "aws_subnet" "Lab-public-subnet"{
    vpc_id = aws_vpc.Lab-vpc.id
    cidr_block = var.cidr_block[1]

    tags = {
        Name = "terra-public-subet"
    }
}


#Create internet Gateway
resource "aws_internet_gateway" "Lab-internet-gateway"{
    vpc_id = aws_vpc.Lab-vpc.id

    tags = {
        Name = "Terra-internet-Gateway"
    }
}

#Create security Group
resource "aws_security_group" "Lab-security-group"{
    name = "Lab-security-group"
    description = "To manage inbound , outbound traffic"
    vpc_id = aws_vpc.Lab-vpc.id

    dynamic ingress {

        iterator = port
        for_each = var.ports
        content {
            from_port = port.value
            to_port = port.value
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        }
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "allow_traffic"
    }

}


#Create Route Table and association

resource "aws_route_table" "Lab_Route_table"{
    vpc_id = aws_vpc.Lab-vpc.id

    route {
        cidr_block = var.cidr_block[2]
        gateway_id = aws_internet_gateway.Lab-internet-gateway.id
    }

    tags = {
        Name = "myRouteTable"
    }
}

#create Route Table association

resource "aws_route_table_association" "Lab_Associate"{
    subnet_id = aws_subnet.Lab-public-subnet.id
    route_table_id = aws_route_table.Lab_Route_table.id   
}

#Configure EC2 instance 
/**/
resource "aws_instance" "EC2__instance" {
    ami           = var.ami[0]
    instance_type = var.instanceType[0]
    key_name = "Terraform"
    vpc_security_group_ids = [aws_security_group.Lab-security-group.id]
    subnet_id =  aws_subnet.Lab-public-subnet.id
    associate_public_ip_address = true
    user_data = file("./installJenkins.sh")

    tags = {
        Name = "Jenkins_Server"
    }
}


resource "aws_instance" "EC2__AnsibleControlNode" {
    ami           = var.ami[0]
    instance_type = var.instanceType[0]
    key_name = "Terraform"
    vpc_security_group_ids = [aws_security_group.Lab-security-group.id]
    subnet_id =  aws_subnet.Lab-public-subnet.id
    associate_public_ip_address = true
    user_data = file("./InstallAnsibleCN.sh")

    tags = {
        Name = "AnsibleContrlnode"
    }
}


#Configuring Ansible managed node to host tomcat
resource "aws_instance" "EC2__AnsibleManagedNode" {
    ami           = var.ami[0]
    instance_type = var.instanceType[0]
    key_name = "Terraform"
    vpc_security_group_ids = [aws_security_group.Lab-security-group.id]
    subnet_id =  aws_subnet.Lab-public-subnet.id
    associate_public_ip_address = true
    user_data = file("./AnsibleManagedNode.sh")

    tags = {
        Name = "AnsibleManagedNode-Tomcat"
    }
}


#Configuring Ansible managed node to host docker
resource "aws_instance" "EC2__AnsibleManagedNodeDocker" {
    ami           = var.ami[0]
    instance_type = var.instanceType[0]
    key_name = "Terraform"
    vpc_security_group_ids = [aws_security_group.Lab-security-group.id]
    subnet_id =  aws_subnet.Lab-public-subnet.id
    associate_public_ip_address = true
    user_data = file("./Docker.sh")

    tags = {
        Name = "AnsibleManagedNode-Docker"
    }
}


#Configuring one EC2 instance for SonaType :: Sonatype Nexus is a repository manager will be used to store all the build artifacts

resource "aws_instance" "EC2__Sonatype" {
    ami           = var.ami[0]
    instance_type = var.instanceType[1]
    key_name = "Terraform"
    vpc_security_group_ids = [aws_security_group.Lab-security-group.id]
    subnet_id =  aws_subnet.Lab-public-subnet.id
    associate_public_ip_address = true
    user_data = file("./InstallNexus.sh")

    tags = {
        Name = "SonatypeServer"
    }
}