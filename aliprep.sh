echo "Install ossutil64"
wget http://gosspublic.alicdn.com/ossutil/1.7.7/ossutil64                           
chmod 755 ossutil64

echo "export PATH=$PATH:~/ack-k10" >> ~/.bashrc
echo "alias k=kubectl" >> ~/.bashrc
. ~/.bashrc

clear

echo -n "Enter your Alicloud Access Key ID and press [ENTER]: "
read AccessKeyId
echo "" | awk '{print $1}'
echo $AccessKeyId > aliaccess
echo -n "Enter your Alicloud Access Key Secret and press [ENTER]: "
read AccessKeySecret
echo $AccessKeySecret >> aliaccess
chmod 600 aliaccess
echo "" | awk '{print $1}'
echo "You are ready to deploy now!"
echo "" | awk '{print $1}'
