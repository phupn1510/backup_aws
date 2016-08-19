#!/bin/bash

####################define variable create temporary file to store data
Name=$1
touch /tmp/volume.$Name

TMP_FILE='/tmp/volume.'$Name

#####################List volumes from INSTANCE NAME then store to TMP FILE
/usr/local/bin/aws ec2 describe-instances --filters 'Name=tag:Name,Values='$Name'' --output text --query 'Reservations[*].Instances[*].BlockDeviceMappings[*].Ebs.VolumeId'> $TMP_FILE
####################List snapshot and time to create snapshot from each Volume_ID from Volume file
for volume in $(cat $TMP_FILE); do
############ Create snapshot list from that volume then store to temporary file
	touch /tmp/snapshot.$Name.json
	TMP_FILE2='/tmp/snapshot.'$Name.'json'
############# Export to temporary file  
       /usr/local/bin/aws ec2 describe-snapshots --filter Name=volume-id,Values=$volume > $TMP_FILE2
#Read json data from temporary file
/usr/bin/jq -r '.Snapshots|keys[]' /tmp/snapshot.DEV_VPN_SSH.json | while read key ; do
    Date=$(/usr/bin/jq ".Snapshots[$key].StartTime" $TMP_FILE2)
    SnapID=$(/usr/bin/jq ".Snapshots[$key].SnapshotId" $TMP_FILE2)
   Datenew=${Date:1:10}
   Snapnew=${SnapID:1:13}
echo $Datenew
#Date7ago=$(date --date='7 day ago' '+%Y-%m-%d')
Date7agoinSeconds=$(date +%s --date="7 days ago")
echo $Date7agoinSeconds
DatenewinSecond=$(date --date=$Datenew +%s)
echo $DatenewinSecond
CurrentDate=$(date '+%Y-%m-%d')
Date1monthago=$(date -d "-$(date +%d) days -0 month" '+%Y-%m-%d')
Date2monthago=$(date -d "-$(date +%d) days -1 month" '+%Y-%m-%d')
Date3monthago=$(date -d "-$(date +%d) days -2 month" '+%Y-%m-%d')
Date4monthago=$(date -d "-$(date +%d) days -3 month" '+%Y-%m-%d')
Date5monthago=$(date -d "-$(date +%d) days -4 month" '+%Y-%m-%d')
Date6monthago=$(date -d "-$(date +%d) days -5 month" '+%Y-%m-%d')
# If time to create snapshot is same with 7 days ago and different last day of 6 month, we delete that snapshot
   if [ "$DatenewinSecond" -le "$Date7agoinSeconds" ] && [ "$Datenew" != "$Date1monthago" ] && [ "$Datenew" != "$Date2monthago" ] && [ "$Datenew" != "$Date3monthago" ] && [ "$Datenew" != "$Date4monthago" ] && [ "$Datenew" != "$Date5monthago" ]  && [ "$Datenew" != "$Date6monthago" ] ; then
#         echo $Snapnew
         /usr/local/bin/aws ec2 delete-snapshot --snapshot-id $Snapnew
#else
#echo "khong trung nhung ngay kia"
 fi
################################ Delete duplicate snapshot on today
   if [ "$Datenew" == "$CurrentDate" ]; then
        /usr/local/bin/aws ec2 delete-snapshot --snapshot-id $Snapnew
#      echo $Snapnew
  fi
 #   if [ "$DatenewinSecond" -ge "$Date7agoinSeconds" ]; then
#        /usr/local/bin/aws ec2 delete-snapshot --snapshot-id $Snapnew
#      echo "Test giay ngay moi lon 7 ngay"
 # fi

done


/usr/local/bin/aws ec2 create-snapshot --volume-id $volume --description "Daily Backup of $volume "
rm -rf $TMP_FILE2
done
#remove temporary file
rm -rf $TMP_FILE

