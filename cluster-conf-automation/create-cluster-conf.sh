USERNAME=xxxxx
TEAM=devops
CLUSTER_NAME=XXXX
CLUSTER_MASTER=XXXX
# connect to

BIN_DIRECTORY='./'
# get dependencies in context
if [ ! -f "${BIN_DIRECTORY}/yq" ];then
  wget -cO - https://github.com/mikefarah/yq/releases/download/3.3.2/yq_linux_amd64 > ${BIN_DIRECTORY}/yq && chmod +755 ${BIN_DIRECTORY}/yq
fi


# Copy file that generates the key and gets all certificates from master node
scp run_on_master.sh user@${CLUSTER_MASTER}:~/run_on_master.sh

ssh -t user@${CLUSTER_MASTER} "sudo ~/run_on_master.sh ${USERNAME} ${TEAM}"
scp user@${CLUSTER_MASTER}:~/cluster-cfg cluster-cfg

#ssh -t user@${CLUSTER_MASTER} "rm -rf ~/cluster-cfg"

CLUSTER_SERVER=$(./yq r "cluster-cfg" server)
#echo $CLUSTER_SERVER

CLUSTER_CA_DATA=$(./yq r "cluster-cfg" certificate-authority-data)
#echo $CLUSTER_CA_DATA

CLIENT_CERTIFICATE_DATA=$(./yq r "cluster-cfg" client-certificate-data)
#echo $CLIENT_CERTIFICATE_DATA

CLIENT_KEY_DATA=$(./yq r "cluster-cfg" client-key-data)
#echo $CLIENT_KEY_DATA

kubectl config set-cluster ${CLUSTER_NAME} --server=${CLUSTER_SERVER}
kubectl config set clusters.${CLUSTER_NAME}.certificate-authority-data ${CLUSTER_CA_DATA}

kubectl config set-credentials ${USER}
kubectl config set users.${USER}.client-certificate-data ${CLIENT_CERTIFICATE_DATA}
kubectl config set users.${USER}.client-key-data ${CLIENT_KEY_DATA}

kubectl config set-context ${CLUSTER_NAME} --cluster=${CLUSTER_NAME} --namespace=default --user=${USER}
kubectl config use-context ${CLUSTER_NAME}

rm cluster-cfgj