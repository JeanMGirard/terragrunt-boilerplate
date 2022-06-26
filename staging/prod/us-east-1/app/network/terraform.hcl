# app/network

include {
  path = find_in_parent_folders("root.hcl")
}

include "env" {
  path   = "${get_terragrunt_dir()}/../../_env/app/network.hcl"
  expose = true
}

include "region" {
  path   = "${get_terragrunt_dir()}/../_region/app/network.hcl"
  expose = true
}


terraform {
  source = "${include.env.locals.source_base_url}?ref=v0.2.0"
}
