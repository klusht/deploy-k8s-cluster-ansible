### Ansible project for setting up a kubernetes cluster on manual defined VM's using kubeadm

### Prerequisites

##### Configure kubernetes versions
The current project assumes there are CentOS(7) VM's, as many actions are from the official install guides for this OS.

##### Kubernetes configuration 
- Update details in 0_build_hosts_file.sh , and execute it to create the 

#### Local configuration
- Have all your VM's ready on your local hypervisor
  - I use vmware player on windows and clone them on different HDD's to simulate different IO speeds
  - Use the script others/windoes/windows_vmware_recreate_cluster.cmd to automate the vms on Windows.
    - How the script works. It looks for a folder that has the copy of a base image. It copies the vmware image into multiple folders to reflect a pool config.
    Change the number of instances in the "for" loop to have mmore instances of the same VM. It also creates shortcuts to allow you to start all of them at once.
    Every time you need to crate a new cluster, delete images and run the script. 
    Vmware player will save a static ID for each VM name, hence the MAC address will be updated with the ones from previous run. Really convenient to delete VM and create new ones fast.
  - Make sure you use the same base image with the same root password
  - Get all VMs assigned IP addresses and update the 0_build_hosts_file.sh . Hope the script is readable.


### USAGE
- From your remote machine ( where you have ansible ) run the scripts as described in the header of each file 
- You can create group_vars/mastervms.yaml and workervms.yaml Containing
  ansible_password: "your_root_password"
```
add the IPs to 0_build_hosts_file.sh
./0_build_hosts_file.sh  to create hosts.yaml file   or skip this step if you alreay have them set up
./deploy_k8s.yaml 
```

  #### How were the playbooks build
- They mostly fallow the steps defined in the official guides 
  - https://docs.docker.com/install/linux/docker-ce/centos/
  - https://kubernetes.io/docs/setup/independent/install-kubeadm/
  - https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/
  
#### Comments
I did not used vagrant to initialize VM on any hypervisor ( virtualbox/vmware ) as there is a clear dependency to have first network interface as NAT, 
which affects the kubeadm cluster installation being the primary NIC and the resulting IP not being accessible from outside.

#### PROXMOX 
Recently tested proxmox and I find it to be the best solution for cluster automation. 
It provides a rich automation interface using their qm cli and a very useful UI. There is a separate branch containing this variant. 
Unfortunately there is a bug when using the "nested virtualization" mode, I receive CPU Locked a lot. Work in progress at the moment.

