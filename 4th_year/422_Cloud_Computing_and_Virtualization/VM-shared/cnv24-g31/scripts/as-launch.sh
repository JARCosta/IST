#!/bin/sh

source $PWD/.config

echo "Creating Auto Scaling Group...\n"
aws autoscaling create-auto-scaling-group --auto-scaling-group-name CNV-AS \
  --launch-template LaunchTemplateName=CNV-templ,Version=1 \
  --min-size 1 --max-size 3 \
  --availability-zones eu-west-3a \
  --load-balancer-names CNV-LB
echo "DONE!"

