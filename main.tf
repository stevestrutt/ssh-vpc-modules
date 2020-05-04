
# provider block required with Schematics to set VPC region
provider "ibm" {
  region           = var.ibm_region
  ibmcloud_api_key = var.ibmcloud_api_key
  generation       = local.generation
  version          = "~> 1.4"
}

data "ibm_resource_group" "all_rg" {
  name = var.resource_group_name
}

locals {
  generation     = 2
  frontend_count = 2
  backend_count  = 1
}


module "vpc" {
  source               = "./vpc"
  ibm_region           = var.ibm_region
  resource_group_name  = var.resource_group_name
  generation           = local.generation
  unique_id            = var.vpc_name
  frontend_count       = local.frontend_count
  frontend_cidr_blocks = local.frontend_cidr_blocks
  backend_count        = local.backend_count
  backend_cidr_blocks  = local.backend_cidr_blocks
}

locals {
  # bastion_cidr_blocks  = [cidrsubnet(var.bastion_cidr, 4, 0), cidrsubnet(var.bastion_cidr, 4, 2), cidrsubnet(var.bastion_cidr, 4, 4)]
  frontend_cidr_blocks = [cidrsubnet(var.frontend_cidr, 4, 0), cidrsubnet(var.frontend_cidr, 4, 2), cidrsubnet(var.frontend_cidr, 4, 4)]
  backend_cidr_blocks  = [cidrsubnet(var.backend_cidr, 4, 0), cidrsubnet(var.backend_cidr, 4, 2), cidrsubnet(var.backend_cidr, 4, 4)]
}


# Create single zone bastion
module "bastion" {
  source                  = "./bastionmodule"
  ibm_region              = var.ibm_region
  bastion_count           = 1
  unique_id               = var.vpc_name
  bastion_cidr            = var.bastion_cidr
  ssh_source_cidr_blocks  = var.bastion_ingress_cidr
  destination_cidr_blocks = [var.frontend_cidr, var.backend_cidr]
  destination_sgs         = [module.frontend.security_group_id, module.backend.security_group_id]
  # destination_sg          = [module.frontend.security_group_id, module.backend.security_group_id]
  # vsi_profile             = "cx2-2x4"
  # image_name              = "ibm-centos-7-6-minimal-amd64-1"
  ssh_key_id = data.ibm_is_ssh_key.sshkey.id

}


module "frontend" {
  source                   = "./frontendmodule"
  ibm_region               = var.ibm_region
  unique_id                = var.vpc_name
  ibm_is_vpc_id            = module.vpc.vpc_id
  ibm_is_resource_group_id = data.ibm_resource_group.all_rg.id
  frontend_count           = local.frontend_count
  profile                  = var.profile
  ibm_is_image_id          = data.ibm_is_image.os.id
  ibm_is_ssh_key_id        = data.ibm_is_ssh_key.sshkey.id
  subnet_ids               = module.vpc.frontend_subnet_ids
  bastion_remote_sg_id     = module.bastion.security_group_id
  bastion_subnet_CIDR      = var.bastion_cidr
  pub_repo_egress_cidr     = local.pub_repo_egress_cidr
  app_backend_sg_id        = module.backend.security_group_id
}

module "backend" {
  source                   = "./backendmodule"
  ibm_region               = var.ibm_region
  unique_id                = var.vpc_name
  ibm_is_vpc_id            = module.vpc.vpc_id
  ibm_is_resource_group_id = data.ibm_resource_group.all_rg.id
  backend_count            = local.backend_count
  profile                  = var.profile
  ibm_is_image_id          = data.ibm_is_image.os.id
  ibm_is_ssh_key_id        = data.ibm_is_ssh_key.sshkey.id
  subnet_ids               = module.vpc.backend_subnet_ids
  bastion_remote_sg_id     = module.bastion.security_group_id
  bastion_subnet_CIDR      = var.bastion_cidr
  app_frontend_sg_id       = module.frontend.security_group_id
  pub_repo_egress_cidr     = local.pub_repo_egress_cidr
}
