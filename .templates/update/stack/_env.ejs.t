---
to: <%= h.src() %>/_env/<%= stack %>.hcl
unless_exists: true
---


locals {
  source_base_url = "github.com/<org>/modules.git//app"
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
}
locals {
  env    = local.env_vars.locals.env
  region = local.region_vars.locals.region
}


# dependency "vpc" {
#  config_path = "../vpc"
# }


inputs = {
  env            = local.env
  region         = local.region
}
