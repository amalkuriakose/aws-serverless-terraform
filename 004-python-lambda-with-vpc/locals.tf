locals {
  common_tags = {
    created-by  = "Terraform"
    auto-delete = "no"
  }
  azs_set  = toset(data.aws_availability_zones.available.names)
  azs_list = tolist(data.aws_availability_zones.available.names)
}