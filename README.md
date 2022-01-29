## Ansible project for setting up a kubernetes cluster predefined VM's using kubeadm
This project fallows the bare metal installation of kubernetes on VMs.
Suitable for home user with windows workstations that wish to spawn up a k8s cluster similar to a cloud provider. 

### Prerequisites

##### Configure virtual machines
Currently, supported OS:
OS-Ubuntu-20.04 (server)

There are scripts available to clone a base image of vmware workstation player hypervisor similar to node-pools cloud definitions. 
The scripts will set the CPU Cores, Memory and NIC MAC address in bridge mode, so you can reserve those IPs in your router.


###How to get your vmware images:
Simply create one image as a base image and provide the name of the folder in 00_vmware-player_win_create_cluster.cmd
The image should have:
python3 installed
a user created in sudoers called "user" ( change it in  ansible.cfg remote_user )


##### Kubernetes configuration 
- Update details in build_hosts_file.sh , and execute it to create the hosts.yaml file.

#### Local configuration
- Have all your VM's ready on your local hypervisor
  - I use vmware player on Windows and clone them on different HDD's to simulate different IO speeds
  - Use the script 00_vmware-player_win_create_cluster.cmd to automate the vms on Windows with VMware Player.
    - How the script works. It looks for a folder that has the copy of a base image. It copies the vmware image into multiple folders to reflect a pool config.
    Change the number of instances in the "for" loop to have more instances of the same VM. It also creates shortcuts to allow you to start all of them at once.
    Every time you need to crate a new cluster, run the script that will recreate the entire folder.
      Use reserved IP addresses on your router.
  - Make sure you use the same base image with the same root password
  - Get all VMs assigned IP addresses and update the 01_build_hosts_file.sh . Hope the script is readable.


### USAGE
- From your remote machine ( where you have ansible ) run the scripts as described in the header of each file
       ansible 2.5.1 has a bug for this script, please use a different version (Ubuntu 18)
          sudo add-apt-repository ppa:ansible/ansible-2.9
          sudo apt update          
          sudo apt-cache policy ansible
          sudo apt-get install ansible=2.9.17-1ppa~bionic

       
- You can create group_vars/mastervms.yaml and workervms.yaml Containing
  ansible_password: "your_root_password"
- ansible_become_password: "your_user_password"
```
add the IPs to build_hosts_file.sh
run build_hosts_file.sh  to create hosts.yaml file   or skip this step if you alreay have them set up
./deploy_k8s.yaml 
```