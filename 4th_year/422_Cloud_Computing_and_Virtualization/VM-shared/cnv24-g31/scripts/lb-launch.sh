#!/bin/sh

source $PWD/.config

echo "Launching Load Balancer..."
aws elb create-load-balancer --load-balancer-name CNV-LB \
--listeners "Protocol=HTTP,LoadBalancerPort=80,InstancePort=8000" \
--availability-zones eu-west-3a \
--security-groups sg-032662b29b8ed571a
 echo "DONE!"
