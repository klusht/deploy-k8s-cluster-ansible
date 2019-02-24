### Ansible project for setting up a kubernetes cluster on manual defined VM's using kubeadm

### Prerequisites

##### VM's 
The current project assumes there are CentOS(7) VM's, as many actions are taken from the official install guides for this OS.

#### Local project configuration
- If you have the VM's user and access key, please update the group_vars/all to point to the correct ssh key. Also if the user on guest VM is not ansible, please update ansible.cfg remote_user 
- If you only have root user for the VM with password, you can run `./optional-configure-ansible-remote.yaml  --ask-pass -c paramiko` to create ssh key and create ansible user access to all machines present in hosts.ini
- To protect against pyhton modules versions issues I recommend using python scripts in a virtualized environment where we install specific versions of dependencies. This way each project can have its own module version and it will not create conflicts.
- Install on your machine ( assuming CentOS ) the following:
```
sudo yum install python-pip -y
sudo pip install --upgrade pip
sudo pip install virtualenv
```
- initiate the virtual environment in each python project using
```
virtualenv venv --no-site-packages    >> this will createa a "venv" folder inside your project
. venv/bin/activate                   >> will activate the virtual environemnt for the session
deactivate                            >> to exit the environment / or just close the session
```
`alias venv='. venv/bin/activate'`      >> recommended alias to easeally activate the virtual environment
- Install ansible and its dependencies using `pip install -r venv_dependencies.txt`
##### Kubernetes configuration 
- update group_vars/all.yml with the required service_cidr and the pod network of choice
- don't forget the remote access key for ansible playbooks.

### USAGE
- The scripts are configured to always run from the virtual environment

`venv`  >> first activate virtual environment inside the project using the alias

`./k8s-master-reset-install.yaml` >> this is idempotent in the sense that will always result in a fresh new k8s master, running this on the master node will reset the cluster. This is useful if you wish to start over with the cluster and install/update dokcer and kubernetes tools. I believe this is the expected behaviour as resources on the cluster and worker nodes themselves should be stateless.

`k8s-node-join.yaml`  >> after successfully mater initialisation you can add

/usr/bin/env: ansible-playbook: No such file or directory  
         => activate the virtual environment first or remove ansible_python_interpreter: "./venv/bin/python"


 #### How were the playboks build
- They mostly fallow the steps defined in the official guides 
  - https://docs.docker.com/install/linux/docker-ce/centos/
  - https://kubernetes.io/docs/setup/independent/install-kubeadm/
  - https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/
  
#### Additional optional utils
- The scripts will always install the latest docker-ce stable version. This might be an issue and you will see some warnings from kubead. It is defined like this as I wish to constantly update the tools. 
- There are two options in regards of Domain Names resolutions. 
  - You can uses /etc/hosts for DNS resolution. The nodes will receive a domain name ( k8s-master , k8s-node-NR) where NR is the last IP segment as present in the hosts.ini. This assumes that hosts.ini contains the IP's and not domain names. 
  Please uncomment the `name: common/hosts_entries` .To avoid collisions please make sure the last IP segments on nodes are unique
- If you don't have a DNS server on your cluster network, there is the `./optional-install-dns-bind.yaml` that will create a BIND DNS server on a separate VM(it can't be one of the cluster nodes as they have kubelet using port 53). The VM must be part of the same network. As I am using vmware workstation as the hypervisor, after you run and install the DNS server you can attach the additional DNS server's IP in the network device on your host. I am a windows user, hence after I created the service, on a VM, that is connected to the "VMware Network Adapter VMnet8" I modified the "Internet Protocol Version 4(TCP/IPv4)" properties inside widows and updated "Use the following DNS server addresses" with the VM's IP... and as an alternative I use google's one "8.8.8.8". 
  - This implies that your hosts.ini will contain (sub)domain names part of a main domain such as vmsnat.local .
  - The script expects you to place the VM IP's in the list in the same order as they are in hosts.ini. TODO make each node do nsupdate of it's own IP.
- After installing the cluster you can use `./optional-install-configure-local-kubectl.yaml` to install and configure the kubectl on your local machine to point to the cluster.
