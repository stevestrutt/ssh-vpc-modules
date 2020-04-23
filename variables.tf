##############################################################################
# Account Variables
##############################################################################

# target region
variable "ibm_region" {
  description = "IBM Cloud region where all resources will be deployed"
  default     = "us-south"
  # default     = "us-east"
  # default     = "eu-gb"
}

variable "ibmcloud_api_key" {

}



variable "resource_group_name" {
  description = "Name of IBM Cloud Resource Group used for all VPC resources"
  default     = "Default"
}

variable "generation" {
  description = "VPC generation"
  default     = 2
}

# unique name for the VPC in the account 
variable "vpc_name" {
  description = "name of vpc"
  default     = "ssh-vpc-vpc"
}

##############################################################################

##############################################################################
# Network variables
##############################################################################


variable "bastion_ingress_cidr" {
  description = "DANGER: cidr range that can ssh to the bastion"
  default     = ["0.0.0.0/0"]
}


locals {
  pub_repo_egress_cidr = "0.0.0.0/0" # cidr range required to contact public software repositories 
}

# Predefine subnets for all app tiers for use with `ibm_is_address_prefix`. Single tier CIDR used for NACLs  
# Each app tier uses: 
# frontend_cidr_blocks = [cidrsubnet(var.frontend_cidr, 4, 0), cidrsubnet(var.frontend_cidr, 4, 2), cidrsubnet(var.frontend_cidr, 4, 4)]
# to create individual zone subnets for use with `ibm_is_address_prefix`
variable "bastion_cidr" {
  default = "172.22.192.0/20"
}

variable "frontend_cidr" {
  default = "172.16.0.0/20"
}

variable "backend_cidr" {
  default = "172.17.0.0/20"
}


##############################################################################

# VSI profile
variable "profile" {
  default = "cx2-2x4"
}

# image names can be determined with the cli command `ibmcloud is images`
variable "image_name" {
  default = "ibm-centos-7-6-minimal-amd64-1"
  #default = "ibm-ubuntu-18-04-1-minimal-amd64-1"
}

data "ibm_is_image" "os" {
  name = var.image_name
}

data "ibm_is_ssh_key" "sshkey" {
  name = var.ssh_key_name
}

variable "ssh_key_name" {
  default = "ansible"
}

