output "vpc_id" {
  value = ibm_is_vpc.vpc.id
}

output "az1_subnet_id" {
  value = ibm_is_subnet.az1_subnet.*.id
}