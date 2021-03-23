### Ansible project for setting up a kubernetes cluster on manual defined VM's using kubeadm

### Prerequisites

##### Configure kubernetes versions
The current project assumes there are CentOS(7) VM's, as many actions are from the official installation guides for this OS.

##### Kubernetes configuration 
- Update details in build_hosts_file.sh , and execute it to create the hosts.yaml file.

#### Local configuration
- Have all your VM's ready on your local hypervisor
  - I use vmware player on windows and clone them on different HDD's to simulate different IO speeds
  - Use the script 00_vmware-player_win_create_cluster.cmd to automate the vms on Windows with VMware Player.
    - How the script works. It looks for a folder that has the copy of a base image. It copies the vmware image into multiple folders to reflect a pool config.
    Change the number of instances in the "for" loop to have more instances of the same VM. It also creates shortcuts to allow you to start all of them at once.
    Every time you need to crate a new cluster, run the script that will recreate the entire folder.
      Use reserved IP addresses on your router.
  - Make sure you use the same base image with the same root password
  - Get all VMs assigned IP addresses and update the 0_build_hosts_file.sh . Hope the script is readable.


### USAGE
- From your remote machine ( where you have ansible ) run the scripts as described in the header of each file
       ansible 2.5.1 has a bug for this script, please use a different version (Ubuntu 18)
          sudo add-apt-repository ppa:ansible/ansible-2.9
          sudo apt update          
          sudo apt-cache policy ansible
          sudo apt-get install ansible=2.9.17-1ppa~bionic

       
- You can create group_vars/mastervms.yaml and workervms.yaml Containing
  ansible_password: "your_root_password"
```
add the IPs to build_hosts_file.sh
run build_hosts_file.sh  to create hosts.yaml file   or skip this step if you alreay have them set up
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
Recently tested proxmox on winOS. I find it to be the best solution for cluster automation. 
It provides a rich automation interface using their qm cli and a very useful UI. There is a separate branch containing this variant.
if you receive CPU Locked on the nested VM, lower the SHARED CPU cores on the proxmox guest VM.

