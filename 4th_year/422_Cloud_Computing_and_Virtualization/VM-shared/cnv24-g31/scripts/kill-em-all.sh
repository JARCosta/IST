#!/bin/bash

source .config

LB_NAME="CNV-LB"
AS_NAME="CNV-AS"

aws elb delete-load-balancer --load-balancer-name $LB_NAME
echo "Deleted Classic Load Balancer: $LB_NAME"

aws autoscaling update-auto-scaling-group --auto-scaling-group-name $AS_NAME --min-size 0
aws autoscaling update-auto-scaling-group --auto-scaling-group-name $AS_NAME --desired-capacity 0

aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names $AS_NAME --query "AutoScalingGroups[0].Instances" --output text
while [ "$(aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names $AS_NAME --query "AutoScalingGroups[0].Instances" --output text)" != "" ]; do
  sleep 10
  echo -n "."
done
echo ""
echo "All AS instances terminated."

aws autoscaling delete-auto-scaling-group --auto-scaling-group-name $AS_NAME --force-delete
echo "Deleted AS: $AS_NAME"

echo "DONE!"
