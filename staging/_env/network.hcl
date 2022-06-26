
locals {
  source_base_url = "github.com/<org>/modules.git//app"
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
}
locals {
  env    = local.env_vars.locals.env
  region = local.region_vars.locals.region
}


dependency "vpc" {
  config_path = "../vpc"
}

dependency "mysql" {
  config_path = "../mysql"
}


inputs = {
  env            = local.env
  region         = local.region
  basename       = "example-app-${local.env_name}"
  vpc_id         = dependency.vpc.outputs.vpc_id
  subnet_ids     = dependency.vpc.outputs.subnet_ids
  mysql_endpoint = dependency.mysql.outputs.endpoint
}
