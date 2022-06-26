---
sh: |
  IFS=',';
  REGIONS='<%= regions %>'
  for REG in $REGIONS; do hygen update stack --region "$REG" --env '<%= env %>' --stack '<%= stack %>'; done
---
