
#/bin/bash

aws ec2 describe-instances | grep InstanceId | cut -d ":" -f2 | sed 's/[",]//g' > instances.txt

cat instances.txt | while read line
do
  cat configtemp.tf | sed "s/example/$line/g" >> config.tf
  terraform import aws_instance."${line}" "${line}"
done
