#!/bin/bash

#------------------Create new GCP instance from .vmdk image---------------------

#Convert .vmdk image in .raw
VBoxManage clonehd /home/dimsan/VirtualBox\ VMs/VMBitrix7.2.0-x86_64/16.05.2018\ vm-disk001.vmdk disk.raw --format RAW

#Compress RAW image in .tar.gz
tar -Sczf compressed-image.tar.gz disk.raw

#Create new Google Cloud Bucket
#gsutil mb gs://[BUCKET_NAME]

#Copy compressed image in Bucket
gsutil cp compressed-image.tar.gz gs://infra-seg

#Set project name
gcloud config set project infra-218515

#Create new GCP image from .tar.gz in bucket
gcloud compute images create new2cimage --source-uri gs://infra-seg/compressed-image.tar.gz

#Output GCP images list
gcloud compute images list --no-standard-images

#Create new instance from new image
gcloud compute --project=infra-218515 instances create instance-3 --zone=europe-west1-d --tags=http-server --image=new2cimage --image-project=infra-218515 --boot-disk-size=20GB --boot-disk-type=pd-standard --boot-disk-device-name=instance-3

