I just want to build an ACK Cluster (Alibaba Cloud Container Service for Kubernetes) to play with the various Data Management capabilities e.g. Backup/Restore, Disaster Recovery and Application Mobility. 

### <a href="https://twitter.com/yongkanghe?ref_src=twsrc%5Etfw" class="twitter-follow-button" data-size="large" data-show-screen-name="false" data-show-count="false">Follow @yongkanghe</a>

It is challenging to create an ACK cluster from Alibaba Cloud if you are not familiar to it. After the ACK Cluster is up running, we still need to install Kasten, create a sample DB, create policies etc.. The whole process is not that simple.

![image](https://pbs.twimg.com/media/FHLSGL8VEAAUrZQ?format=png&name=900x900)

This script based automation allows you to build a ready-to-use Kasten K10 demo environment running on ACK in about 3 minutes. If you don't have an ACK Cluster, you can watch the Youtube video and follow the guide to build an ACK cluster on Alibaba Cloud. Once the ACK Cluster is up running, you can proceed to the next steps. 

# Option 1: Build an ACK cluster via Web UI
[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/JLdc4D9kAss/0.jpg)](https://www.youtube.com/watch?v=JLdc4D9kAss)

### [Subscribe Youtube Channel](https://www.youtube.com/channel/UCm-sw1b23K-scoVSCDo30YQ?sub_confirmation=1)

# Option 2: Build an ACK cluster via OpenAPI
[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/eXjTSDmgcUE/0.jpg)](https://www.youtube.com/watch?v=eXjTSDmgcUE)

# Here're the prerequisities. 

1. Go to Alibaba Cloud Shell
2. Verify if you can access the cluster via kubectl
````
kubectl get nodes
````
3. Clone the github repo, run below command
````
git clone https://github.com/yongkanghe/ack-k10.git
````
4. Install the tools and set Alibaba Cloud Access Credentials
````
cd ack-k10;./aliprep.sh
````
5. Optionally, you can customize the clustername, instance-type, zone, region, bucketname
````
vi setenv.sh
````
# To build the labs, run 
````
./k10-deploy.sh
````
1. Install Kasten K10
2. Deploy a Postgresql database
3. Create an Alicloud OSS location profile
4. Create a backup policy for Postgresql
5. Backup jobs scheduled automatically

# To delete the labs, run 
````
./destroy.sh
````
1. Remove the relevant VPC, vSwitch
2. Remove all the relevant disks
3. Remove all the relevant snapshots
4. Remove the objects from the storage bucket

# Cick my photo to watch the how-to video.
[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/clGcZbdaQPE/0.jpg)](https://www.youtube.com/watch?v=clGcZbdaQPE)

# For more details about ACK Backup and Restore
### Backup Containers on ACK  
http://backupack.yongkang.cloud

### Automate Build and Protect ACK
http://automateack.yongkang.cloud 

# Kasten - No. 1 Kubernetes Backup
https://kasten.io 

# FREE Kubernetes Learning
https://learning.kasten.io 

# Kasten - DevOps tool of the month July 2021
http://k10.yongkang.cloud

# Contributors

### [Yongkang He](http://yongkang.cloud)
