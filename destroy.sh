starttime=$(date +%s)

. ./setenv.sh

# echo '-------Removing the restorepointcontent of Postgresql'
# kubectl get restorepointcontent -l k10.kasten.io/appNamespace=yong-postgresql | grep -v NAME | awk '{print $1}' | xargs kubectl delete restorepointcontent
# # kubectl delete restorepointcontent -l k10.kasten.io/appNamespace=yong-postgresql
# sleep 60

echo '-------Deleting an ACK Cluster (typically in about 10 mins)'
aliyun cs DeleteCluster --ClusterId $(cat ack_clusterid) --region $MY_REGION

echo '-------Waiting for completion of deleting ACK Cluster'
sleep 200

echo '-------Wtill waiting for completion of deleting ACK Cluster'
sleep 100

aliyun cs DescribeClustersV1 --region $MY_REGION | jq '.clusters[].state' | grep deleting
if [ `echo $?` -eq 0 ]
then
  sleep 20
fi

aliyun cs DescribeClustersV1 --region $MY_REGION | jq '.clusters[].state' | grep deleting
if [ `echo $?` -eq 0 ]
then
  sleep 20
fi

aliyun cs DescribeClustersV1 --region $MY_REGION | jq '.clusters[].state' | grep deleting
if [ `echo $?` -eq 0 ]
then
  sleep 20
fi

aliyun cs DescribeClustersV1 --region $MY_REGION | jq '.clusters[].state' | grep deleting
if [ `echo $?` -eq 0 ]
then
  sleep 10
fi

aliyun cs DescribeClustersV1 --region $MY_REGION | jq '.clusters[].state' | grep deleting
if [ `echo $?` -eq 0 ]
then
  sleep 10
fi

aliyun vpc DeleteVSwitch --VSwitchId $(cat ack_vswitchid) --RegionId $MY_REGION
sleep 3
aliyun vpc DeleteVpc --VpcId $(cat ack_vpcid) --RegionId $MY_REGION

# aliyun ecs DeleteKeyPairs --RegionId $MY_REGION --KeyPairNames $MY_KEYPAIR --region $MY_REGION 

echo '-------Deleting disks'
aliyun ecs DescribeDisks --region $MY_REGION --RegionId $MY_REGION --Tag.1.Key ack.aliyun.com --Tag.1.Value $(cat ack_clusterid) | grep DiskId | awk '{print $2}' | sed -e 's/\"//g' | sed -e 's/\,//g' > ack_diskids
for i in $(cat ack_diskids);do echo $i;aliyun ecs DeleteDisk --DiskId $i --region $MY_REGION;done

echo '-------Deleting snapshots'
aliyun ecs DescribeSnapshots --RegionId $MY_REGION --region $MY_REGION --Tag.1.Key createdby --Tag.1.Value alibabacloud-csi-plugin | grep SnapshotId | awk '{print $2}' | sed -e 's/\"//g' | sed -e 's/\,//g' > ack_snapshotids
for i in $(cat ack_snapshotids);do echo $i;aliyun ecs DeleteSnapshot --SnapshotId $i --region $MY_REGION;done

echo '-------Deleting objects from the bucket'
ossutil64 -i $(cat aliaccess | head -1) -k $(cat aliaccess | tail -1) -e https://oss-$MY_REGION.aliyuncs.com rm oss://$(cat ack_bucketname)/ -r -f
# gsutil rm -r gs://$(cat ack_bucketname)
# unset KUBECONFIG
#kubectl config use-context $(kubectl config get-contexts -o name | grep kubernetes-admin)

endtime=$(date +%s)
duration=$(( $endtime - $starttime ))
echo "-------Total time is $(($duration / 60)) minutes $(($duration % 60)) seconds."
echo "" | awk '{print $1}'
echo "-------Created by Yongkang"
echo "-------Email me if any suggestions or issues he@yongkang.cloud"
echo "" | awk '{print $1}'