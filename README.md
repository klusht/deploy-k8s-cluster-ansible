### Ansible project for setting up a kubernetes cluster on manual defined VM's using kubeadm

### Prerequisites

##### VM's 
The current project assumes there are CentOS(7) VM's, as many actions are taken from the official install guides for this OS.

##### Kubernetes configuration 
- update group_vars/all.yml with the required service_cidr and the pod network of choice

#### Local configuration
- Have all your VM's ready on your hypervisor
  - They all have the same root password
  - Get all VM bridged IP addresses and update the hosts.ini, ansible_host = the DHCP assigned IP
  - name = recommend adding some extra information to be available using -owide on pods
  - kubectl_labels = labels that you can use in your deployments as nodeSelectors
  - Don't forget to reserve the IP's in your router

### USAGE
- From your remote machine ( where you have ansible ) run the scripts as described in the header of each file 
```
./install-master.yaml --ask-pass -c paramiko
./install-nodes-and-join.yaml  --ask-pass -c paramiko
./install-k8s-labels.yaml --ask-pass -c paramiko
```
- You can create group_vars/clustervms.yaml file and add ansible_password: "root_password" to skip typing the password

 #### How were the playbooks build
- They mostly fallow the steps defined in the official guides 
  - https://docs.docker.com/install/linux/docker-ce/centos/
  - https://kubernetes.io/docs/setup/independent/install-kubeadm/
  - https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/
  
#### Additional optionals playbooks
- Only if you don't have kubectl already installed you can use `./optionals/optional-install-configure-local-kubectl.yaml` to install and configure the kubectl on your local machine to point to the cluster.

#### Comments
- I did not use vagrant to initialize VM on any hypervisor ( virtualbox/vmware ) as there is a clear dependency to have first "network interface" as NAT, 
which affects the kubeadm cluster installation being the primary NIC and the resulting IP not being accessible from outside.
- There is an automated way to create VMs on demand in nested virtualization using proxmox. Have a look pn the branch variant/deploy-kubernetes-cluster-proxmox