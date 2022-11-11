#!/bin/bash

kubectl create -f jupyter.yaml
echo "awaits the deployment to be up..."
sleep 5
kubectl get pod -o wide | grep jupyter-notebook | tr -s " " | cut -d " " -f6 > list.txt
counter=0
while read ip; do
  echo "Running scanner for ip:$ip"
  kubectl run tsunami-$counter --restart='Never' --image dizex98/tsunami:2 -- --ip-v4-target=$ip
#   --scan-results-local-output-format=JSON \ 
#   --scan-results-local-output-filename=logs/tsunami-output.json  
  counter=`expr $counter + 1`
done < list.txt