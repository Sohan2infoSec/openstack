#!/bin/bash

cat > /etc/cinder/cinder.conf << END
[DEFAULT]
my_ip = 192.168.56.6
rootwrap_config = /etc/cinder/rootwrap.conf
api_paste_confg = /etc/cinder/api-paste.ini
iscsi_helper = tgtadm
volume_name_template = volume-%s
volume_group = cinder-volumes
verbose = True
auth_strategy = keystone
state_path = /var/lib/cinder
lock_path = /var/lock/cinder
volumes_dir = /var/lib/cinder/volumes
rpc_backend = rabbit

[database]
connection = mysql://cinder:Password1@controller/cinder

[oslo_messaging_rabbit]
rabbit_host = controller
rabbit_userid = openstack
rabbit_password = Password1

[keystone_authtoken]
auth_uri = http://controller:5000
auth_url = http://controller:35357
memcached_servers = controller:11211
auth_plugin = password
project_domain_name = default
user_domain_name = default
project_name = service
username = cinder
password = Password1

[oslo_concurrency]
lock_path = /var/lib/cinder/tmp
END

su -s /bin/sh -c "cinder-manage db sync" cinder

echo -e "[cinder]\nos_region_name = RegionOne" >> /etc/nova/nova.conf

service nova-api restart
service cinder-scheduler restart
service cinder-api restart
