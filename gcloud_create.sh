#!/bin/sh

test -z $VM_NAME && printf "set bash variable \$VM_NAME before running\n" && exit 1
gcloud compute instances create $VM_NAME                \
       --image-project=debian-cloud                     \
       --image-family=debian-12                         \
       --metadata-from-file=startup-script=./startup    \
       --tags http-server,https-server
gcloud compute firewall-rules create default-allow-http \
       --direction=INGRESS --priority=1000 --network=default --action=ALLOW \
       --rules=tcp:80 --source-ranges=0.0.0.0/0 --target-tags=http-server,https-server
