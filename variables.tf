##############################################################################
# Account Variables
##############################################################################

variable "ibm_region" {
  description = "IBM Cloud region where all resources will be deployed"
  default = "us-south"
}

variable "az_list" {
  description = "IBM Cloud availability zones"
  default     = ["us-south-1", "us-south-2", "us-south-3"]
}

variable "resource_group_name" {
  description = "ID for IBM Cloud Resource Group"
  default = "Default"
}

variable "generation" {
  description = "VPC generation"
  default     = 2
}

variable "unique_id" {
  description = "The vpc unique id"
  default     = "ssh1"
}

##############################################################################

##############################################################################
# Network variables
##############################################################################

variable "az-prefix" {
  default = ["172.22.192.0/21", "172.22.208.0/21", "172.22.224.0/21"]
}

variable "az1_subnet" {
  default = ["172.22.192.0/23", "172.22.194.0/23", "172.22.196.0/23", "172.22.198.0/23"]
}

variable "az2_subnet" {
  default = ["172.22.208.0/23", "172.22.210.0/23", "172.22.212.0/23", "172.22.214.0/23"]
}

variable "az3_subnet" {
  default = ["172.22.224.0/23", "172.22.226.0/23", "172.22.228.0/23", "172.22.230.0/23"]
}

variable "subnet-cat" {
  default = ["tr", "ut", "st", "in"]
}

variable "backend_cidr_blocks" {
  default = ["172.16.4.0/25", "172.16.2.0/25", "172.16.0.0/25"]
}

variable "frontend_cidr_blocks" {
  default = ["172.16.1.0/26", "172.16.3.0/26", "172.16.5.0/26"]
}

##############################################################################
variable "vpc_name" {
  description = "name of vpc"
  default     = "ssh-vpc"
}

variable "profile" {
  default = "cx2-2x4"
}

variable "image_name" {
  default = "ibm-ubuntu-18-04-64"
}

# variable "ibm_is_image_id" {
#   default = "${data.ibm_is_image.os.id}"
# }

data "ibm_is_image" "os" {
  name = var.image_name
}

data "ibm_is_ssh_key" "sshkey" {
  name = var.ssh_key_name
}

variable "ssh_key_name" {
  default = "ajreddyssh"
}

