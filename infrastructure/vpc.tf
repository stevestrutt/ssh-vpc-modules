##############################################################################
# This file creates the VPC, Zones, subnets and public gateway for the VPC
# a separate file sets up the load balancers, listeners, pools and members
##############################################################################

##############################################################################
# Create a VPC
##############################################################################
data "ibm_resource_group" "all_rg" {
  name = var.resource_group_name
}

resource "ibm_is_vpc" "vpc" {
  name           = var.vpc_name
  resource_group = data.ibm_resource_group.all_rg.id
}

##############################################################################

##############################################################################
# Prefixes and subnets for zone 1
##############################################################################

resource "ibm_is_vpc_address_prefix" "subnet_prefix" {
  count = "1"

  name = "${var.unique_id}-az-${count.index + 1}"
  zone = element(var.az_list, count.index)
  vpc  = ibm_is_vpc.vpc.id
  cidr = element(var.az-prefix, count.index)
}

resource "ibm_is_vpc_address_prefix" "backend_subnet_prefix" {
  count = "1"

  name = "${var.unique_id}-backend-prefix-zone-${count.index + 1}"
  zone = "${var.ibm_region}-${count.index % 3 + 1}"
  vpc  = ibm_is_vpc.vpc.id
  cidr = element(var.backend_cidr_blocks, count.index)
}

resource "ibm_is_vpc_address_prefix" "frontend_subnet_prefix" {
  count = "1"

  name = "${var.unique_id}-frontend-prefix-zone-${count.index + 1}"
  zone = "${var.ibm_region}-${count.index % 3 + 1}"
  vpc  = ibm_is_vpc.vpc.id
  cidr = element(var.frontend_cidr_blocks, count.index)
}

##############################################################################

##############################################################################
# Create Subnets
##############################################################################

resource "ibm_is_subnet" "az1_subnet" {
  count           = "1"
  name            = "${var.unique_id}-az1-${element(var.subnet-cat, count.index)}"
  vpc             = ibm_is_vpc.vpc.id
  zone            = element(var.az_list, 0)
  ipv4_cidr_block = element(var.az1_subnet, count.index)

  #network_acl     = "${ibm_is_network_acl.multizone_acl.id}"
  public_gateway = element(ibm_is_public_gateway.test_gateway.*.id, 0)
}

# resource "ibm_is_subnet" "az2_subnet" {
#   count           = "1"
#   name            = "${var.unique_id}-az2-${element(var.subnet-cat, count.index)}"
#   vpc             = "${ibm_is_vpc.vpc.id}"
#   zone            = "${element(var.az_list, 1)}"
#   ipv4_cidr_block = "${element(var.az2_subnet, count.index)}"

#   #network_acl     = "${ibm_is_network_acl.multizone_acl.id}"
#   public_gateway = "${element(ibm_is_public_gateway.test_gateway.*.id, 1)}"
# }

# resource "ibm_is_subnet" "az3_subnet" {
#   count           = "1"
#   name            = "${var.unique_id}-az3-${element(var.subnet-cat, count.index)}"
#   vpc             = "${ibm_is_vpc.vpc.id}"
#   zone            = "${element(var.az_list, 2)}"
#   ipv4_cidr_block = "${element(var.az3_subnet, count.index)}"

#   #network_acl     = "${ibm_is_network_acl.multizone_acl.id}"
#   public_gateway = "${element(ibm_is_public_gateway.test_gateway.*.id, 2)}"
# }

resource "ibm_is_subnet" "backend-subnet" {
  count = "1"
  name  = "${var.unique_id}-backend-subnet-${count.index + 1}"
  vpc   = ibm_is_vpc.vpc.id
  zone  = element(var.az_list, count.index)
  ipv4_cidr_block = element(
    ibm_is_vpc_address_prefix.backend_subnet_prefix.*.cidr,
    count.index,
  )
  #network_acl     = "${ibm_is_network_acl.multizone_acl.id}"
}

resource "ibm_is_subnet" "frontend-subnet" {
  count = "1"
  name  = "${var.unique_id}-frontend-subnet-${count.index + 1}"
  vpc   = ibm_is_vpc.vpc.id
  zone  = element(var.az_list, count.index)
  ipv4_cidr_block = element(
    ibm_is_vpc_address_prefix.frontend_subnet_prefix.*.cidr,
    count.index,
  )
  #   #network_acl     = "${ibm_is_network_acl.multizone_acl.id}"
}

resource "ibm_is_public_gateway" "test_gateway" {
  count = "1"
  name  = "${var.unique_id}-public-gtw-${count.index}"
  vpc   = ibm_is_vpc.vpc.id
  zone  = "us-south-${count.index + 1}"

  //User can configure timeouts
  timeouts {
    create = "90m"
  }
}

##############################################################################
