provider "ibm" {
  region = var.ibm_region

  #ibmcloud_api_key = "${var.ibmcloud_api_key}"
  generation = var.generation
}

data "ibm_resource_group" "all_rg" {
  name = var.resource_group_name
}

locals {
  bastion_ingress_cidr = "0.0.0.0/0" # DANGER: cidr range that can ssh to the bastion when maintenance is enabled
  backend_egress_cidr  = "0.0.0.0/0" # cidr range required to contact software repositories when maintenance is enabled
  frontend_egress_cidr = "0.0.0.0/0" # DANGER: cidr range that can access the front end service
}

