echo '-------Deploying K10 with a sample DB in about 3 mins'
starttime=$(date +%s)
. ./setenv.sh

echo $MY_BUCKET > ack_bucketname

# export KUBECONFIG=~/ack-k10/ack_kubeconfig
export KUBECONFIG=./ack_kubeconfig

echo '-------Install K10'
kubectl create ns kasten-io

kubectl annotate sc alicloud-disk-essd storageclass.kubernetes.io/is-default-class=true

helm repo add kasten https://charts.kasten.io
helm repo update

helm install k10 kasten/k10 -n kasten-io \
  --set externalGateway.create=true \
  --set auth.tokenAuth.enabled=true \
  --set global.persistence.metering.size=20Gi \
  --set prometheus.server.persistentVolume.size=20Gi \
  --set global.persistence.grafana.size=20Gi \
  --set global.persistence.storageClass=alicloud-disk-essd

echo '-------Set the default ns to k10'
kubectl config set-context --current --namespace kasten-io

echo '-------Creating an ali essd vsc'
cat <<EOF | kubectl apply -f -
apiVersion: snapshot.storage.k8s.io/v1
kind: VolumeSnapshotClass
metadata:
  annotations:
    k10.kasten.io/is-snapshot-class: "true"
  name: ali-essd-vsc
driver: diskplugin.csi.alibabacloud.com
deletionPolicy: Delete
EOF

echo '-------Deploying a PostgreSQL database'
kubectl create namespace yong-postgresql
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install --namespace yong-postgresql postgres bitnami/postgresql --set primary.persistence.size=20Gi

echo '-------Output the Cluster ID'
clusterid=$(kubectl get namespace default -ojsonpath="{.metadata.uid}{'\n'}")
echo "" | awk '{print $1}' > ack_token
echo My Cluster ID is $clusterid >> ack_token

echo '-------Wait for 1 or 2 mins for the Web UI IP and token'
kubectl wait --for=condition=ready --timeout=180s -n kasten-io pod -l component=jobs
k10ui=http://$(kubectl get svc gateway-ext -n kasten-io | awk '{print $4}'|grep -v EXTERNAL)/k10/#
echo -e "\nCopy below token before clicking the link to log into K10 Web UI -->> $k10ui" >> ack_token
echo "" | awk '{print $1}' >> ack_token
sa_secret=$(kubectl get serviceaccount k10-k10 -o jsonpath="{.secrets[0].name}" --namespace kasten-io)
echo "Here is the token to login K10 Web UI" >> ack_token
echo "" | awk '{print $1}' >> ack_token
kubectl get secret $sa_secret --namespace kasten-io -ojsonpath="{.data.token}{'\n'}" | base64 --decode | awk '{print $1}' >> ack_token
echo "" | awk '{print $1}' >> ack_token

echo '-------Waiting for K10 services are up running in about 1 or 2 mins'
kubectl wait --for=condition=ready --timeout=300s -n kasten-io pod -l component=catalog

#Create a Alibaba Cloud Object Storage Location Profile
./oss-location.sh

#Create a backup policy for the sample database
./postgresql-policy.sh

echo '-------Accessing K10 UI'
cat ack_token

endtime=$(date +%s)
duration=$(( $endtime - $starttime ))
echo "-------Total time for K10+Postgresql+Policy is $(($duration / 60)) minutes $(($duration % 60)) seconds."
echo "" | awk '{print $1}'
echo "-------Created by Yongkang"
echo "-------Email me if any suggestions or issues he@yongkang.cloud"
echo "" | awk '{print $1}'
