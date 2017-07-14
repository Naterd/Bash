#!/bin/bash

CHEF_NAME=$(hostname)
CHEF_SERVER_URL='##########'
CHEF_CONF_DIR="/etc/chef/"

/usr/bin/knife node delete "$CHEF_NAME" -y -u "$CHEF_NAME" -s "$CHEF_SERVER_URL"
/usr/bin/knife client delete "$CHEF_NAME" -y -u "$CHEF_NAME" -s "$CHEF_SERVER_URL"
/bin/rm "$CHEF_CONF_DIR/client.pem"
