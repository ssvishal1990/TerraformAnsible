variable "cidr_block" {
  type        = list(string)
  default     = ["172.20.0.0/16", "172.20.10.0/24", "0.0.0.0/0"]
  description = "description"
}

variable "ports"{
    type = list(number)
    default = [22,80,443,8080,8081]
}

variable "ami"{
    type = list(string)
    default = ["ami-0bcf5425cdc1d8a85"]
}

variable "instanceType"{
    type = list(string)
    default = ["t2.micro", "t2.medium"]
}


