##############################################################################
# Account Variables
##############################################################################

variable "ibm_region" {
  description = "IBM Cloud region where all resources will be deployed"
}

variable "resource_group_name" {
  description = "ID for IBM Cloud Resource Group"
}

variable "az_list" {
  description = "IBM Cloud availability zones"
}


variable "generation" {
  description = "VPC generation"
}

variable "unique_id" {
  description = "The vpc unique id"
}

##############################################################################

##############################################################################
# Network variables
##############################################################################

variable "az-prefix" {
}

variable "az1_subnet" {
}

variable "subnet-cat" {
}

variable "backend_cidr_blocks" {
}

variable "frontend_cidr_blocks" {
}

##############################################################################
variable "vpc_name" {
  description = "name of vpc"
}







