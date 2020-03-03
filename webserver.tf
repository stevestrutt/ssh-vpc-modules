// module "webserver" {
//     source = "./infrastructure"
//     ibm_region = var.ibm_region
//     resource_group_name = var.resource_group_name
//     az_list = var.az_list  
//     generation = var.generation
//     unique_id = var.unique_id
//     az-prefix = var.az-prefix
//     az1_subnet = var.az1_subnet
//     subnet-cat = var.subnet-cat
//     backend_cidr_blocks =  var.backend_cidr_blocks
//     frontend_cidr_blocks = var.frontend_cidr_blocks
//     vpc_name =  var.vpc_name
// }

# this is the SG applied to the webserver instance
resource "ibm_is_security_group" "webserver" {
  name = "${var.unique_id}-webserver-sg"
  vpc  = module.bastion.vpc_id
}

# users of the bastion. for example from on premises
resource "ibm_is_security_group_rule" "webserver_ingress_ssh_all" {
  group     = ibm_is_security_group.webserver.id
  direction = "inbound"

  #remote    = "${var.remote}"

  tcp {
    port_min = 22
    port_max = 22
  }
}

# resource "ibm_is_security_group_rule" "webserver_egress_ssh_all" {
#   group     = "${ibm_is_security_group.webserver.id}"
#   direction = "outbound"
#   remote    = "${ibm_is_security_group.maintenance.id}"

#   tcp = {
#     port_min = 22
#     port_max = 22
#   }
# }

resource "ibm_is_instance" "webserver" {
  name    = "${var.unique_id}--webserver-vsi"
  image   = data.ibm_is_image.os.id
  profile = var.profile

  primary_network_interface {
    subnet          = module.bastion.az1_subnet_id[0]
    security_groups = [ibm_is_security_group.webserver.id]
  }

  vpc            = module.bastion.vpc_id
  zone           = element(var.az_list, 0)
  resource_group = data.ibm_resource_group.all_rg.id
  keys           = [data.ibm_is_ssh_key.sshkey.id]
}

resource "ibm_is_security_group_rule" "maintenance_egress_443" {
  group     = ibm_is_security_group.webserver.id
  direction = "outbound"
  remote    = "0.0.0.0/0"

  tcp {
    port_min = 443
    port_max = 443
  }
}

# Access to repos
resource "ibm_is_security_group_rule" "http" {
  direction = "outbound"

  tcp {
    port_min = 80
    port_max = 80
  }

  remote = "10.0.0.0/8"
  group  = ibm_is_security_group.webserver.id
}

# Access to repos
resource "ibm_is_security_group_rule" "https" {
  direction = "outbound"

  tcp {
    port_min = 443
    port_max = 443
  }

  remote = "10.0.0.0/8"
  group  = ibm_is_security_group.webserver.id
}

# Allow access to IBM DNS name servers
resource "ibm_is_security_group_rule" "dns" {
  direction = "outbound"

  udp {
    port_min = 53
    port_max = 53
  }

  remote = "161.26.0.0/8"
  group  = ibm_is_security_group.webserver.id
}

resource "ibm_is_security_group_rule" "sg1_app_tcp_rule" {
  group      = ibm_is_security_group.webserver.id
  direction  = "inbound"
  remote     = "0.0.0.0/0"

  tcp {
    port_min = 80
    port_max = 80
  }
}

