#!/bin/sh

source $PWD/.config

$PWD/lb-launch.sh

$PWD/as-launch.sh

aws elb describe-load-balancers --load-balancer-names CNV-LB | jq ".LoadBalancerDescriptions[0].DNSName" | sed -e 's/"\(.\+\)"/http:\/\/\1/' > ../lb-dns-addr.txt

echo "All AWS stuff is set up!"

cd ..

DNS=`cat lb-dns-addr.txt`

echo "Load Balancer's DNS HTTP address is: $DNS"

