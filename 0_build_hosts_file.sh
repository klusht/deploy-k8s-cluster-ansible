#!/bin/bash

echo "Building hosts.yaml file"
if [ ! -f local_resources/yq ];then
  wget -cO - https://github.com/mikefarah/yq/releases/download/3.3.2/yq_linux_amd64 > local_resources/yq && chmod +x local_resources/yq
fi
yq() { local_resources/yq "$@"; }; export -f yq

function create_host_entries() {
  group=$1
  node=$2
  node_ip=$3
  yq w -i hosts.yaml $group.hosts.$node.ansible_host $node_ip
  yq w -i hosts.yaml $group.hosts.$node.kubernetes.k8s_install_version "$k8s_install_version"
  yq w -i hosts.yaml $group.hosts.$node.kubernetes.docker_install_version "$docker_install_version"
}

function create_nodes() {
  nodepool=$1
  ips=$2
  for i in "${!ips[@]}"; do
    node_dn="${cluster_name}-worker-${nodepool}-$i"
    create_host_entries workervms $node_dn ${ips[$i]}
  done
}

###################################

#k8s_install_version=1.5.4-0
#k8s_install_version=1.5.4-1
#k8s_install_version=1.6.0-0
#k8s_install_version=1.6.0-1
#k8s_install_version=1.6.1-0
#k8s_install_version=1.6.1-1
#k8s_install_version=1.6.2-0
#k8s_install_version=1.6.2-1
#k8s_install_version=1.6.3-0
#k8s_install_version=1.6.3-1
#k8s_install_version=1.6.4-0
#k8s_install_version=1.6.4-1
#k8s_install_version=1.6.5-0
#k8s_install_version=1.6.5-1
#k8s_install_version=1.6.6-0
#k8s_install_version=1.6.6-1
#k8s_install_version=1.6.7-0
#k8s_install_version=1.6.7-1
#k8s_install_version=1.6.8-0
#k8s_install_version=1.6.8-1
#k8s_install_version=1.6.9-0
#k8s_install_version=1.6.9-1
#k8s_install_version=1.6.10-0
#k8s_install_version=1.6.10-1
#k8s_install_version=1.6.11-0
#k8s_install_version=1.6.11-1
#k8s_install_version=1.6.12-0
#k8s_install_version=1.6.12-1
#k8s_install_version=1.6.13-0
#k8s_install_version=1.6.13-1
#k8s_install_version=1.7.0-0
#k8s_install_version=1.7.0-1
#k8s_install_version=1.7.1-0
#k8s_install_version=1.7.1-1
#k8s_install_version=1.7.2-0
#k8s_install_version=1.7.2-1
#k8s_install_version=1.7.3-1
#k8s_install_version=1.7.3-2
#k8s_install_version=1.7.4-0
#k8s_install_version=1.7.4-1
#k8s_install_version=1.7.5-0
#k8s_install_version=1.7.5-1
#k8s_install_version=1.7.6-1
#k8s_install_version=1.7.6-2
#k8s_install_version=1.7.7-1
#k8s_install_version=1.7.7-2
#k8s_install_version=1.7.8-1
#k8s_install_version=1.7.8-2
#k8s_install_version=1.7.9-0
#k8s_install_version=1.7.9-1
#k8s_install_version=1.7.10-0
#k8s_install_version=1.7.10-1
#k8s_install_version=1.7.11-0
#k8s_install_version=1.7.11-1
#k8s_install_version=1.7.14-0
#k8s_install_version=1.7.15-0
#k8s_install_version=1.7.16-0
#k8s_install_version=1.8.0-0
#k8s_install_version=1.8.0-1
#k8s_install_version=1.8.1-0
#k8s_install_version=1.8.1-1
#k8s_install_version=1.8.2-0
#k8s_install_version=1.8.2-1
#k8s_install_version=1.8.3-0
#k8s_install_version=1.8.3-1
#k8s_install_version=1.8.4-0
#k8s_install_version=1.8.4-1
#k8s_install_version=1.8.5-0
#k8s_install_version=1.8.5-1
#k8s_install_version=1.8.6-0
#k8s_install_version=1.8.7-0
#k8s_install_version=1.8.8-0
#k8s_install_version=1.8.9-0
#k8s_install_version=1.8.10-0
#k8s_install_version=1.8.11-0
#k8s_install_version=1.8.12-0
#k8s_install_version=1.8.13-0
#k8s_install_version=1.8.14-0
#k8s_install_version=1.8.15-0
#k8s_install_version=1.9.0-0
#k8s_install_version=1.9.1-0
#k8s_install_version=1.9.2-0
#k8s_install_version=1.9.3-0
#k8s_install_version=1.9.4-0
#k8s_install_version=1.9.5-0
#k8s_install_version=1.9.6-0
#k8s_install_version=1.9.7-0
#k8s_install_version=1.9.8-0
#k8s_install_version=1.9.9-0
#k8s_install_version=1.9.10-0
#k8s_install_version=1.9.11-0
#k8s_install_version=1.10.0-0
#k8s_install_version=1.10.1-0
#k8s_install_version=1.10.2-0
#k8s_install_version=1.10.3-0
#k8s_install_version=1.10.4-0
#k8s_install_version=1.10.5-0
#k8s_install_version=1.10.6-0
#k8s_install_version=1.10.7-0
#k8s_install_version=1.10.8-0
#k8s_install_version=1.10.9-0
#k8s_install_version=1.10.10-0
#k8s_install_version=1.10.11-0
#k8s_install_version=1.10.12-0
#k8s_install_version=1.10.13-0
#k8s_install_version=1.11.0-0
#k8s_install_version=1.11.1-0
#k8s_install_version=1.11.2-0
#k8s_install_version=1.11.3-0
#k8s_install_version=1.11.4-0
#k8s_install_version=1.11.5-0
#k8s_install_version=1.11.6-0
#k8s_install_version=1.11.7-0
#k8s_install_version=1.11.8-0
#k8s_install_version=1.11.9-0
#k8s_install_version=1.11.10-0
#k8s_install_version=1.12.0-0
#k8s_install_version=1.12.1-0
#k8s_install_version=1.12.2-0
#k8s_install_version=1.12.3-0
#k8s_install_version=1.12.4-0
#k8s_install_version=1.12.5-0
#k8s_install_version=1.12.6-0
#k8s_install_version=1.12.7-0
#k8s_install_version=1.12.8-0
#k8s_install_version=1.12.9-0
#k8s_install_version=1.12.10-0
#k8s_install_version=1.13.0-0
#k8s_install_version=1.13.1-0
#k8s_install_version=1.13.2-0
#k8s_install_version=1.13.3-0
#k8s_install_version=1.13.4-0
#k8s_install_version=1.13.5-0
#k8s_install_version=1.13.6-0
#k8s_install_version=1.13.7-0
#k8s_install_version=1.13.8-0
#k8s_install_version=1.13.9-0
#k8s_install_version=1.13.10-0
#k8s_install_version=1.13.11-0
#k8s_install_version=1.13.12-0
#k8s_install_version=1.14.0-0
#k8s_install_version=1.14.1-0
#k8s_install_version=1.14.2-0
#k8s_install_version=1.14.3-0
#k8s_install_version=1.14.4-0
#k8s_install_version=1.14.5-0
#k8s_install_version=1.14.6-0
#k8s_install_version=1.14.7-0
#k8s_install_version=1.14.8-0
#k8s_install_version=1.14.9-0
#k8s_install_version=1.14.10-0
#k8s_install_version=1.15.0-0
#k8s_install_version=1.15.1-0
#k8s_install_version=1.15.2-0
#k8s_install_version=1.15.3-0
#k8s_install_version=1.15.4-0
#k8s_install_version=1.15.5-0
#k8s_install_version=1.15.6-0
#k8s_install_version=1.15.7-0
#k8s_install_version=1.15.8-0
#k8s_install_version=1.15.9-0
#k8s_install_version=1.15.10-0
#k8s_install_version=1.15.11-0
#k8s_install_version=1.15.12-0
#k8s_install_version=1.16.0-0
#k8s_install_version=1.16.1-0
#k8s_install_version=1.16.2-0
#k8s_install_version=1.16.3-0
#k8s_install_version=1.16.4-0
#k8s_install_version=1.16.5-0
#k8s_install_version=1.16.6-0
#k8s_install_version=1.16.7-0
#k8s_install_version=1.16.8-0
#k8s_install_version=1.16.9-0
#k8s_install_version=1.16.10-0
#k8s_install_version=1.16.11-0
#k8s_install_version=1.16.11-1
#k8s_install_version=1.16.12-0
#k8s_install_version=1.16.13-0
#k8s_install_version=1.16.14-0
#k8s_install_version=1.16.15-0
#k8s_install_version=1.17.0-0
#k8s_install_version=1.17.1-0
#k8s_install_version=1.17.2-0
#k8s_install_version=1.17.3-0
#k8s_install_version=1.17.4-0
#k8s_install_version=1.17.5-0
#k8s_install_version=1.17.6-0
#k8s_install_version=1.17.7-0
#k8s_install_version=1.17.7-1
#k8s_install_version=1.17.8-0
#k8s_install_version=1.17.9-0
#k8s_install_version=1.17.11-0
#k8s_install_version=1.17.12-0
#k8s_install_version=1.18.0-0
#k8s_install_version=1.18.1-0
#k8s_install_version=1.18.2-0
#k8s_install_version=1.18.3-0
#k8s_install_version=1.18.4-0
#k8s_install_version=1.18.4-1
#k8s_install_version=1.18.5-0
#k8s_install_version=1.18.6-0
#k8s_install_version=1.18.8-0
#k8s_install_version=1.18.9-0
#k8s_install_version=1.19.0-0
#k8s_install_version=1.19.1-0
k8s_install_version=1.19.2-0

cluster_name=web-cluster
docker_install_version=19.03.5
service_cidr="10.100.0.0/12"
#    pod_network= flannel
pod_network=calico
pod_network_cidr="10.200.0.0/16"
schedule_pods_on_master=no

# TODO automate exclusion
kubernetes_components=[metrics-server,coreos-kube-prometheus]


master_dn="${cluster_name}-master-node"
master_ip=192.168.0.100
create_host_entries mastervms $master_dn $master_ip
yq w -i hosts.yaml mastervms.hosts.$master_dn.kubernetes.service_cidr "$service_cidr"
yq w -i hosts.yaml mastervms.hosts.$master_dn.kubernetes.pod_network "$pod_network"
yq w -i hosts.yaml mastervms.hosts.$master_dn.kubernetes.pod_network_cidr "$pod_network_cidr"
yq w -i hosts.yaml mastervms.hosts.$master_dn.kubernetes.schedule_pods_on_master "$schedule_pods_on_master"



ips=("192.168.0.159" "192.168.0.174")
create_nodes large $ips

ips=("192.168.0.163" "192.168.0.176")
create_nodes medium $ips


ips=("192.168.0.162" "192.168.0.179")
create_nodes small $ips


echo "done"



















