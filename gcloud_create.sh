#!/bin/sh

REPO_NAME="github_hugo-test-684_html"
BRANCH_PATTERN="public"
BUILD_CONFIG_FILE="cloudbuilder.yaml"
test -z $VM_NAME && printf "set bash variable \$VM_NAME before running\n" && exit 1
gcloud config set compute/region us-central1
gcloud config set compute/zone us-central1-f
gcloud compute instances create $VM_NAME                \
       --image-project=debian-cloud                     \
       --image-family=debian-12                         \
       --metadata-from-file=startup-script=./startup    \
       --tags http-server,https-server || exit 1
gcloud compute firewall-rules create default-allow-http                     \
       --direction=INGRESS --priority=1000 --network=default --action=ALLOW \
       --rules=tcp:80 --source-ranges=0.0.0.0/0 --target-tags=http-server,https-server
gcloud builds triggers create cloud-source-repositories \
       --repo=$REPO_NAME                                \
       --branch-pattern=$BRANCH_PATTERN                 \
       --build-config=$BUILD_CONFIG_FILE
