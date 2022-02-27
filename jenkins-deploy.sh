echo '------Deploy Jenkins'
kubectl create ns yong-jenkins
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install jenkins bitnami/jenkins -n yong-jenkins --set persistence.size=20Gi