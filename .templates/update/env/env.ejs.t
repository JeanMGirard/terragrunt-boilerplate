---
to: <%= h.dir_env({ env }) %>/env.hcl
unless_exists: true
---
locals {
  env = "<%= env %>"
}
