include {
  path = find_in_parent_folders("root.hcl")
}

include "env" {
  path   = "${get_terragrunt_dir()}/../../_env/network.hcl"
  expose = true
}

include "region" {
  path   = "${get_terragrunt_dir()}/../_region/network.hcl"
  expose = true
}

# Construct the terraform.source attribute using the source_base_url and custom version v0.2.0
terraform {
  source = "${include.env.locals.source_base_url}?ref=v0.2.0"
}
