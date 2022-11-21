#!/bin/bash

kubectl create -f jupyter.yaml
echo "awaits the deployment to be up..."
# A logic to check when the deploy is ready
flag=0
while [ $flag -eq 0 ]; do
  kubectl get pod -o wide | grep jupyter-notebook | tr -s " " | cut -d " " -f6 > list.ip
  flag=1
  while read line; do
    if [ $line == "<none>" ]; then
      flag=0
      break
    fi
  done < list.ip
done


# Deploy for each pod of jupyter a pod of tsunami
pod_num=0
while read ip; do
  echo "Running scanner for ip:$ip"
  kubectl run tsunami-$pod_num --restart='OnFailure' --image dizex98/tsunami:2 -- --ip-v4-target=$ip
  pod_num=`expr $pod_num + 1`
done < list.ip


# A logic to check if all the tsunami pods are completed.
echo "awaits the tsunami pods to be completed..."
flag=0
while [ $flag -eq 0 ]; do
  kubectl get pods | grep tsunami | tr -s " " | cut -d " " -f3 > list.status
  flag=1
  while read line; do
    if [ $line != "Completed" ]; then
      flag=0
      break
    fi
  done < list.status
done

# removing tsunami pods, showing and saving logs.
mkdir -p logs
for (( i=0; i<$pod_num; i++ ))
do
  # Saving logs
  kubectl logs tsunami-$i > logs/tsunami-$i.logs
  echo "Last logs from tsunami-$i:"
  # Show number of vulnerabilities and amount of scan's time
  kubectl logs tsunami-$i | tail -n 7
  kubectl delete pod tsunami-$i
done