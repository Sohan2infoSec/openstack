#!/bin/bash
apt-get update
apt-get install -y python-openstackclient
apt-get install -y nova-compute sysfsutils
openstack --version
