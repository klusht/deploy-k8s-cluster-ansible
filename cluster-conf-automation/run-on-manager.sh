#!/bin/bash
set +x

USERNAME=$1
TEAM=$2

# Create new key
export KUBECONFIG="/etc/kubernetes/admin.conf"
mkdir -p ~/user-certificate-request
openssl genrsa -out  ~/user-certificate-request/user.key 2048
openssl req -new -key ~/user-certificate-request/user.key -subj "/CN=${USERNAME}/O=${TEAM}" -out ~/user-certificate-request/user.csr

kubectl delete csr ${USERNAME}
echo "^^ ingnorable if not used present"

# Create Signing Request
cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: ${USERNAME}
spec:
  usages:
    - client auth
  request: $(cat ~/user-certificate-request/user.csr | base64 | tr -d '\n')
  signerName: kubernetes.io/kube-apiserver-client
  groups:
    - system:authenticated
EOF


kubectl certificate approve ${USERNAME}

# RBAC setup
# ClusterRole   we will use the defautl clusterrole admin        kubectl get clusterrole
# ClusterRoleBinding
kubectl delete clusterrolebinding ${USERNAME}
kubectl create clusterrolebinding ${USERNAME} --clusterrole=cluster-admin --user=${USERNAME}

echo "$(cat $KUBECONFIG | grep certificate-authority-data | xargs)" > ~/user-certificate-request/cluster-cfg
echo "client-certificate-data: $(kubectl get csr ${USERNAME} -o=jsonpath='{.status.certificate}')" >> ~/user-certificate-request/cluster-cfg
echo "client-key-data: $(cat ~/user-certificate-request/user.key | base64 | tr -d '\n')" >> ~/user-certificate-request/cluster-cfg
echo "server: https://$(hostname -I | awk '{print $1;}'):6443" >> ~/user-certificate-request/cluster-cfg
# as it is executed as root
chown user:user -R ~/user-certificate-request
mv -f ~/user-certificate-request/* /home/user/


