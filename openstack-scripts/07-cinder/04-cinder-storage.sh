#!/bin/bash
apt-get update
apt-get install -y lvm2

pvcreate /dev/vdb
vgcreate cinder-volumes /dev/vdb

apt-get install -y cinder-volume

cat > /etc/cinder/cinder.conf << END
[DEFAULT]
my_ip = 192.168.56.8
glance_api_servers = http://controller:9292
enabled_backends = lvm
rpc_backend = rabbit
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
[lvm]
volume_driver = cinder.volume.drivers.lvm.LVMVolumeDriver
volume_group = cinder-volumes
iscsi_protocol = iscsi
iscsi_helper = tgtadm
[oslo_concurrency]
lock_path = /var/lib/cinder/tmp
END
service tgt restart
service cinder-volume restart
echo "Now edit /etc/lvm/lvm.conf on storage and compute"
