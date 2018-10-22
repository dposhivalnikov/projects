#!/bin/bash

#------------------Create new GCP instance from .vmdk image---------------------

#Convert .vmdk image in .raw
VBoxManage clonehd <name_vmdk_image>.vmdk <name_raw_image>.raw --format RAW

#Compress RAW image in .tar.gz
tar -Sczf <name_compressed_raw_image>.tar.gz <name_raw_image>.raw

#Create new Google Cloud Bucket
#gsutil mb gs://[BUCKET_NAME]

#Copy compressed image in Bucket
gsutil cp <name_compressed_raw_image>.tar.gz gs://[BUCKET_NAME]

#Set project name
gcloud config set project <GCP_project_name>

#Create new GCP image from .tar.gz in bucket
gcloud compute images create <GCP_image_name> --source-uri gs://infra-seg/<name_compressed_raw_image>.tar.gz

#Create new instance from new image
gcloud compute --project=<project_name> instances create <GCP_instance_name> --zone=europe-west1-d --tags=http-server --image=<GCP_image_name> --image-project=<GCP_project_name> --boot-disk-size=20GB --boot-disk-type=pd-standard --boot-disk-device-name=<GCP_instance_name>>

