Instruction:
* Make sure you are connected to a cluster and kubectl is already configured.
* In order to execute the init script write these commands:
    ```
    chmod +x init.sh
    bash init.sh
    ```
* The script will deploy a deployment of jupyter-notebook including replica of 3.
* For each replica the script will deploy a single tsunami pod for a scan.

Steps that has been taken:
1. At first I dockerize the image of tsunami, build and push to docker hub.
2. I generated a yaml file where I deploy replicas of jupyter-notebook image so it will trigger vulnerability for the tsunami's pod.
3. Created an init script so everything will be automated.