Steps that has been taken:
1. At first I dockerize the image of tsunami, build and push to docker hub.
2. I decided using Kubernetes cluster of minikube where I deploy all the relevant components.
3. Generated a yaml file where I deploy replicas of jupyter-notebook image on so it will trigger vulnerability for the tsunami's pod.
4. Created an init script so everything will be automated.

Instruction:
* Make sure you are connected to a cluster and kubectl is already configured.
* In case you already have what to scan you can skip this step, otherwise you can test it by running this command:
    ```
    kubectl create -f jupyter.yaml
    ```
    (Make sure to wait for all the pods to be in a running state.)
* In order to execute the init script write the following commands:
    ```
    chmod +x init.sh
    bash init.sh
    ```
* For each existing pod on the cluster the script will deploy a single tsunami pod for a scan.
* In the end of the scan, the tsunami's pod will be destroyed, and you will be able to see the last relevant logs where you see the summary of the scan.
