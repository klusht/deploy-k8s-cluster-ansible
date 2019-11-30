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
./install-reset-master.yaml --ask-pass -c paramiko
./install-join-node.yaml --ask-pass -c paramiko
./install-after-kubectl-updates.yaml --ask-pass -c paramiko
```

 #### How were the playboks build
- They mostly fallow the steps defined in the official guides 
  - https://docs.docker.com/install/linux/docker-ce/centos/
  - https://kubernetes.io/docs/setup/independent/install-kubeadm/
  - https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/
  
#### Additional optionals playbooks
- Only if you don't have kubectl already installed you can use `./optionals/optional-install-configure-local-kubectl.yaml` to install and configure the kubectl on your local machine to point to the cluster.
