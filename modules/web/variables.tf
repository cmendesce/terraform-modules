
variable "instance_type" {
  default = "t2.micro"
}

# Ubuntu Server 16.04 LTS (HVM), SSD Volume Type
variable "aws_amis" {
  default = {
    us-east-1 = "ami-80861296"
    sa-east-1 = ""
    us-west-1 = ""
    us-west-2 = ""
  }
}

variable "access_key" {
}

variable "secret_key" {
}

variable "aws_region" {
}

variable "private_key_name" {
}

variable "private_key_path" {
}