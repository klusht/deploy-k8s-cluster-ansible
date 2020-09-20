### Ansible project for setting up a kubernetes cluster on manual defined VM's using kubeadm

### Prerequisites

##### VM's 
The current project assumes there are CentOS(7) VM's, as many actions are taken from the official install guides for this OS.

##### Kubernetes configuration 
- update group_vars/all.yml with the required service_cidr and the pod network of choice

#### Local configuration
- Have all your VM's ready on your local hypervisor
  - I usually have a centOS7 minimal installation and copy this image on different hard drives so 
    I have different local disc performance
  - They all have the same root password

- Get all VM bridged IP addresses and update the hosts ini
  - name = recommed adding some extra information to be available using -owide on pods
  - ansible_host = the DHCP assigned IP
  - kubectl_labels = labels that you can use in your deployments as nodeSelectors
- Don't forget to reserve the IP's in your router

### USAGE
- From your remote machine ( where you have ansible ) run the scripts as described in the header of each file 
- Install-reset-master can work as standalone cluster as it can start pods on same VM
```
./install-master.yaml --ask-pass -c paramiko
./install-nodes-and-join.yaml  --ask-pass -c paramiko
./install-k8s-labels.yaml --ask-pass -c paramiko
```
- You can create group_vars/clustervms.yaml file and add ansible_password: "root_password" to install everything in one go
```
./install-master.yaml && ./install-nodes-and-join.yaml  && ./install-k8s-labels.yaml && ./optionals/override-kubectl-config.yaml
```

 #### How were the playbooks build
- They mostly fallow the steps defined in the official guides 
  - https://docs.docker.com/install/linux/docker-ce/centos/
  - https://kubernetes.io/docs/setup/independent/install-kubeadm/
  - https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/
  
#### Additional optionals playbooks
- Only if you don't have kubectl already installed you can use `./optionals/optional-install-configure-local-kubectl.yaml` to install and configure the kubectl on your local machine to point to the cluster.

#### Comments
I did not used vagrant to initialize VM on any hypervisor ( virtualbox/vmware ) as there is a clear dependency to have first network interface as NAT, 
which affects the kubeadm cluster installation being the primary NIC and the resulting IP not being accessible from outside.

#### PROXMOX 
Recently tested proxmox and I find it to be the best solution for cluster automation.

It provides a rich automation interface using their qm cli and a very useful UI. 

The hosts.ini files holds now the additional variables that are used to recreate the VM in proxmox

##### PROXMOX setup 
Simply create a VM ( recommend vmware workstation) and make sure that nested virtualization is enabled and allocate sufficient cores, memory and disk size
Make a record of the IP and update the hosts ini 
I use clones of a CentOS image personally configured. hence the proxmox playbook has this value hardcoded as 100
To make my cluster accessible in my private network I reserved the IPs on my router, please remove flag in proxmos main if not used.
kubeadm reset does not remove the network configs and redeploying the cluster on the same VMs will crate a lot of issues,
   so I recommend recreating the VMs every time you wish to bootstrap a k8s cluster
   
```
./recreate-cluster-proxmox.yaml && \
sleep 20 && \
./install-master.yaml && \
./optionals/override-kubectl-config.yaml


./install-nodes-and-join.yaml && \
./install-k8s-labels.yaml
```
VM creations requires Special configuration to be able to extract the automatic IP asignment 
TBD
It is recommended to add the master IP address as reserved IP's in your router 
    - when initialized the master VM, make sure you update the mac Address so it will use the reserved IP
    




NEW DOCS
Create the following files with the passwords required for authentication 
group_vars/mastervms.yaml
    ansible_password: the_password_for_cloned_vm_image
group_vars/proxmox.yaml
    ansible_password: the_proxmox_vm_password
    group_vars_proxmox_vm_password: the_vm_password
group_vars/workervms.yaml
    ansible_password: the_password_for_cloned_vm_image



