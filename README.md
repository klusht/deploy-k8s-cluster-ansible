### Project for setting up a kubernetes cluster on manual defined VM's using kubeadm

### Prerequisites

##### VM's 
The current project assumes there are CentOS7 VM's with the following prerequisites
 - Have an ansible user that requires a password.
 - ansible user is part of the wheel group with NOPASSWD (privilege elevation for sudo)
```
adduser ansible
passwd ansible
usermod -aG wheel ansible
visudo + /wheel + update with NOPASSWD
```

#### Local project configuration
- ansible access key path is defined the first task. Please update this with your relevant path
- I recommended to use python scripts in a virtualized environment where we install specific version of dependencies
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

alias venv='. venv/bin/activate'      >> recomended alias to easy activate the virtual environment
```
- Install dependencies using `pip install -r venv_dependencies.txt`
### USAGE
- The scripts are configured to always run from the virtual environment 
```
./k8s_setup_reset.yml      >> as it is executable and has shebang pointing to the venv #!/usr/bin/env ansible-playbook 


/usr/bin/env: ansible-playbook: No such file or directory  
         => activate the virtual environment first or remove ansible_python_interpreter: "./venv/bin/python"
```
##### Kubernetes configuration 
- update group_vars/all.yml with the required service_cidr and the pod network of choice
 

#### Script assumption
- it mostly fallows the steps defined in the official guides 
  - https://docs.docker.com/install/linux/docker-ce/centos/
  - https://kubernetes.io/docs/setup/independent/install-kubeadm/
  - https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/
- it will always install the latest docker version on all nodes. This might be an issue and you will see some warnings from kubeadm
- it uses /etc/hosts for DNS resolution. The nodes DN contains the last IP segment as present in the hosts.ini. 
-- To avoid collisions please make sure the last IP segments on nodes are unique

