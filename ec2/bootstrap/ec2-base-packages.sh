#!/bin/bash
sudo yum update -y
sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum install -y python-pip
sudo yum install -y jq
sudo yum erase -y epel-release
pip install awscli --upgrade --user
sudo pip install boto3
sudo pip install boto
cat << EOF > ~/.boto
[Boto]
debug = 0
num_retries = 10
EOF
sudo subscription-manager register --org=11953481 --activationkey=ocp-key 
sudo subscription-manager repos \
    --disable="*" \
    --enable=rhel-7-server-rpms \
    --enable=rhel-7-server-extras-rpms \
    --enable=rhel-7-server-ansible-2.4-rpms \
    --enable=rhel-7-server-ose-3.9-rpms \
    --enable=rhel-7-fast-datapath-rpms
sudo yum install -y wget git net-tools bind-utils yum-utils iptables-services bridge-utils bash-completion kexec-tools sos psacct
sudo yum update -y
# sudo systemctl reboot
# sudo yum install -y atomic-openshift-utils
# Some bug with dnsmasq. Workaround is to restart these services prior to running prereq/deploy playbooks