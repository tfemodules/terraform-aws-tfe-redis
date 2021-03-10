name_prefix = "kitchen-test-tfe-redis-"
common_tags = {
  project = "kitchen-test-tfe-redis"
}
vpc_cidr_block = "172.25.1.0/24"
public_subnet_cidrs = [{
  cidr     = "172.25.1.0/28"
  az_index = 0
}]
private_subnet_cidrs = [{
  cidr     = "172.25.1.32/28"
  az_index = 0
  },
  {
    cidr     = "172.25.1.48/28"
    az_index = 1
}]
