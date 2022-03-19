starttime=$(date +%s)
. ./setenv.sh
# export KUBECONFIG=~/ack-k10/ack_kubeconfig
export KUBECONFIG=./ack_kubeconfig

# echo '-------Removing the restorepointcontent of Postgresql'
# kubectl get restorepointcontent -l k10.kasten.io/appNamespace=yong-postgresql | grep -v NAME | awk '{print $1}' | xargs kubectl delete restorepointcontent

# sleep 60

echo '-------Removing Kasten K10 and Postgresql'
helm uninstall postgres -n yong-postgresql
helm uninstall k10 -n kasten-io
kubectl delete ns kasten-io
kubectl delete ns yong-postgresql

echo '-------Deleting objects from the bucket'
ossutil64 -i $(cat aliaccess | head -1) -k $(cat aliaccess | tail -1) -e https://oss-$MY_REGION.aliyuncs.com rm oss://$(cat ack_bucketname)/ -r -f

endtime=$(date +%s)
duration=$(( $endtime - $starttime ))
echo "-------Total time to destroy is $(($duration / 60)) minutes $(($duration % 60)) seconds."
echo "" | awk '{print $1}'
echo "-------Created by Yongkang"
echo "-------Email me if any suggestions or issues he@yongkang.cloud"
echo "" | awk '{print $1}'
