---
to: <%= h.dir_stack({ region, env, stack }) %>/terraform.hcl
force: true
---
# <%= stack %>

include {
  path = find_in_parent_folders("root.hcl")
}

include "env" {
  path   = "${get_terragrunt_dir()}/../../_env/<%= stack %>.hcl"
  expose = true
}

include "region" {
  path   = "${get_terragrunt_dir()}/../_region/<%= stack %>.hcl"
  expose = true
}


terraform {
  source = "${include.env.locals.source_base_url}?ref=v0.2.0"
}
