#!/bin/bash

# GET yq binary -------------------------------
echo "Building hosts.yaml file"
if [ ! -f local_resources/yq ];then
  mkdir -p local_resources; wget -cO - https://github.com/mikefarah/yq/releases/download/3.3.2/yq_linux_amd64 > local_resources/yq && chmod +x local_resources/yq
fi
yq() { local_resources/yq "$@"; }; export -f yq
# end GET yq binary ---------------------------

# Function to build yaml tree -------------------------------
function create_host_common_entries() {
  group=$1; node=$2; node_ip=$3
  yq w -i hosts.yaml $group.hosts.$node.ansible_host $node_ip
  yq w -i hosts.yaml $group.hosts.$node.kubernetes.k8s_install_version "$k8s_install_version"
  if [ $container_runtimes_interface == "containerd" ];
  then
      yq w -i hosts.yaml $group.hosts.$node.kubernetes.container_runtimes_interface "$container_runtimes_interface"
      yq w -i hosts.yaml $group.hosts.$node.kubernetes.cri_install_version "$cri_install_version"
      yq w -i hosts.yaml $group.hosts.$node.kubernetes.cni_plugin_install_version "$cni_plugin_install_version"
      yq w -i hosts.yaml $group.hosts.$node.kubernetes.runc_install_version "$runc_install_version"
      yq w -i hosts.yaml $group.hosts.$node.kubernetes.nerdctl_install_version "$nerdctl_install_version"
  fi
  if [ $container_runtimes_interface == "docker" ];
  then
      yq w -i hosts.yaml $group.hosts.$node.kubernetes.container_runtimes_interface "$container_runtimes_interface"
      yq w -i hosts.yaml $group.hosts.$node.kubernetes.cri_install_version "$cri_install_version"
      yq w -i hosts.yaml $group.hosts.$node.kubernetes.cni_plugin_install_version "$cni_plugin_install_version"
  fi
}
function create_nodes() {
  nodepool=$1;  ips=$2; for i in "${!ips[@]}"; do node_dn="${cluster_name}-worker-${nodepool}-$i";  create_host_common_entries workervms $node_dn ${ips[$i]};  done
}
# END Function to build yaml tree -------------------------------





# Older versions are present in separate branches
k8s_install_version=1.24.3                          # get kubectl > curl -LO https://dl.k8s.io/release/v1.24.3/bin/linux/amd64/kubectl
cni_plugin_install_version=1.1.1


container_runtimes_interface=containerd
# USING package manager "apt"
# CHECK available options on UBUNTU
#     apt-cache madison  containerd
#     apt-cache policy containerd
#cri_install_version=1.5.2-0ubuntu1~20.04.3

# USING git binary
#  Download the containerd-<VERSION>-<OS>-<ARCH>.tar.gz archive from https://github.com/containerd/containerd/releases
# Specify the install version only
cri_install_version=1.6.6
runc_install_version=1.1.3
nerdctl_install_version=0.22.2




#container_runtimes_interface=docker
#cri_install_version=20.10.12  ##  apt-cache madison docker-ce   hirsute (21.04)
#cri_install_version=20.10.12
# docker-ce | 5:20.10.12~3-0~ubuntu-bionic | https://download.docker.com/linux/ubuntu bionic/stable amd64 Packages
# docker-ce | 5:19.03.15~3-0~ubuntu-bionic | https://download.docker.com/linux/ubuntu bionic/stable amd64 Packages



# CLUSTER VARIABLES
cluster_name=web-cluster
service_cidr="10.100.0.0/12"
#    pod_network= flannel
pod_network=calico
pod_network_cidr="10.200.0.0/16"
schedule_pods_on_master=no

#Clean hosts file
echo "" > hosts.yaml

master_dn="${cluster_name}-master-node"
master_ip=192.168.0.100
create_host_common_entries mastervms $master_dn $master_ip
yq w -i hosts.yaml mastervms.hosts.$master_dn.kubernetes.service_cidr "$service_cidr"
yq w -i hosts.yaml mastervms.hosts.$master_dn.kubernetes.pod_network "$pod_network"
yq w -i hosts.yaml mastervms.hosts.$master_dn.kubernetes.pod_network_cidr "$pod_network_cidr"
yq w -i hosts.yaml mastervms.hosts.$master_dn.kubernetes.schedule_pods_on_master "$schedule_pods_on_master"


#ips=("192.168.0.101" "192.168.0.102")
##ips=("192.168.0.101")
#create_nodes large $ips

ips=("192.168.0.102" "192.168.0.103")
create_nodes medium $ips

#ips=("192.168.0.105" "192.168.0.106")
##ips=("192.168.0.103")
#create_nodes small $ips

echo "done"



















