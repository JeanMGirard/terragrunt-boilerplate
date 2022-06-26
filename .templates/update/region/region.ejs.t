---
to: <%= h.dir_region({ region, env }) %>/region.hcl
unless_exists: true
---
locals {
  region = "<%= region %>"
}
