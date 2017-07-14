#!/bin/bash

curl -L https://www.opscode.com/chef/install.sh | bash /dev/stdin -v 12.18.31

mkdir -p /opt/chefbootstrap/
mkdir -p /opt/chef/log/
mkdir -p /etc/chef/trusted_certs
mkdir -p /root/.chef/trusted_certs/

aws s3 cp s3://######/chefconfig/chef_client.rb /etc/chef/client.rb
aws s3 cp s3://######/chefconfig/validator.pem /etc/chef/validation.pem
aws s3 cp s3://######/chefconfig/aws-chef-cleanup.conf /opt/chefbootstrap/
aws s3 cp s3://######/chefconfig/aws-chef-cleanup.sh /opt/chefbootstrap/
aws s3 cp s3://######/chefconfig/aws-chef-prc-runlist.json /etc/chef/first-boot.json
aws s3 cp s3://######/chefconfig/itw1pchefserv01.crt /etc/chef/trusted_certs
aws s3 cp s3://######/chefconfig/itw1pchefserv01.crt /root/.chef/trusted_certs

## TODO: Add knife setup and run_list commands
