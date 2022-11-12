#!/bin/bash

kubectl create -f jupyter.yaml
echo "awaits the deployment to be up..."
# A logic to check when the deploy is ready
flag=0
while [ $flag -eq 0 ]; do
  kubectl get pod -o wide | grep jupyter-notebook | tr -s " " | cut -d " " -f6 > list.txt
  flag=1
  while read line; do
    if [ $line == "<none>" ]; then
      flag=0
      break
    fi
  done < list.txt
done

# deploy for each pod of jupyter a pod of tsunami
pod_num=0
while read ip; do
  echo "Running scanner for ip:$ip"
  kubectl run tsunami-$pod_num --restart='Never' --image dizex98/tsunami:2 -- --ip-v4-target=$ip \
  --scan-results-local-output-format=JSON 
  #--scan-results-local-output-filename=logs/tsunami-output.json  
  pod_num=`expr $pod_num + 1`
done < list.txt


# A logic to check if all the tsunami pods are completed.
echo "awaits the tsunami pods to be completed..."
flag=0
while [ $flag -eq 0 ]; do
  kubectl get pods | grep tsunami | tr -s " " | cut -d " " -f3 > list.txt
  flag=1
  while read line; do
    if [ $line != "Completed" ]; then
      flag=0
      break
    fi
  done < list.txt
done

# removing tsunami pods
for (( i=0; i<$pod_num; i++ ))
do
  kubectl delete pod tsunami-$i
done