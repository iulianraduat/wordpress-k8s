# wordpress-k8s

Wordpress as k8s deployment

## Install

Change the password for mysql in `kustomization.yaml`.

In the folder were you have all .yaml files run the following command:

```
kubectl apply -k .
```

If it does not work for minikube then try:

```
minikube kubectl apply -k .
```

If it does not work for microk8s then try:

```
microk8s kubectl apply -k .
```

You should see in the `default` namespace defined for kubernetes all the new objects.
The corresponding service is called `wordpress`. 

If you want to use it in a different namespace then just add "-n &lt;namespace&gt;" as argument to kubectl call.

You need to use a proxy in front of it (like nginx) to redirect to the exposed port on k8s node.
To find the mapped port for port 80 just check the "Internal Endpoints" of the service "wordpress"
or run `kubectl get svc` from the shell of the server running the cluster.
