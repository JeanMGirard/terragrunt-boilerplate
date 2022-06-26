---
sh: |
  IFS=',';
  REGIONS='<%= regions %>'
  for REG in $REGIONS; do hygen update region --region "$REG" --env '<%= env %>'; done
---

locals {
  env = "<%= env %>"
}
sh2: |
  echo '<%= regions %>'
  IFS=','
  for region in $(echo '<%= regions %>')'; do
    hygen stage region --env '<%= env %>' --region $region ;
  done
