---
to: <%= h.dir_env({ region, env, stack }) %>/_region/<%= stack %>.hcl
unless_exists: true
---
