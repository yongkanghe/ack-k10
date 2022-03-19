echo '-------Creating an ACK Cluster and Protect it with K10 in about 10 mins'
starttime=$(date +%s)

./ack-deploy.sh

./k10-deploy.sh

endtime=$(date +%s)
duration=$(( $endtime - $starttime ))
echo "-------Total time for ACK+K10+DB+Policy is $(($duration / 60)) minutes $(($duration % 60)) seconds."

echo "" | awk '{print $1}'
