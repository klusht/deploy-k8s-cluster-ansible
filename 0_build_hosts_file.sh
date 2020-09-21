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

cluster_name=web-cluster
k8s_install_version=1.17.2-0
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



ips=("192.168.0.176" "192.168.0.177")
create_nodes medium $ips


ips=("192.168.0.179" "192.168.0.178")
create_nodes small $ips


echo "done"



















