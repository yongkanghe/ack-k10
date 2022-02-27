echo '------Deploy Redis'
kubectl create ns yong-redis
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install redis bitnami/redis -n yong-redis --set master.persistence.size=20Gi --set replica.persistence.size=20Gi