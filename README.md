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

You also need to do some changes in the configuration file of the wordpress otherwise the wordpress website is not displayed correctly. 
In `/var/www/html/wp-config.php` add

* `define('WP_HOME', 'https://' . $_SERVER['SERVER_NAME']);`
* `define('WP_SITEURL', 'https://' . $_SERVER['SERVER_NAME']);`
* `define('FORCE_SSL_ADMIN', true);`

Unfortunatelly, the changes in `General Settings` for `WordPress Address (URL)` and `Site Address (URL)` are not an equivalent of the defines in wp-config.php.

These changes assume that you will access the wordpress website using HTTPS.

## Enable ssh in wordpress server

Connect inside of the wordpress pod (not the wordpress-mysql pod).
For that you need first to find its name with `kubectl get pods | grep wordpress`.
Execute the following command: `kubectl exec --stdin --tty wordpress-<RANDOM> -- /bin/bash` where RANDOM is the key for your wordpress pod.

Once inside, execute `apt-get update` to update the package repository.
Then install sshd with `apt-get install openssh-server`.

Now instruct sshd to accept root by editing `/etc/ssh/sshd_config` and adding/changing PermitRootLogin to `PermitRootLogin yes`.

To be able to connect you need to know the root's password so reset it with `passwd root`.

Restart the sshd service with `service ssh restart` and exit the shell.

Enable the service for the port 22 in `wordpress-deployment.yaml` file and re-apply the deployment with `kubectl apply -k .`.
Afterwards run `kubectl get svc | grep wordpress` to find the port mapped to internal port 22.

Now you can connect via ssh using `root@IP_NODE:MAPPE_PORT_22:/` and the password you set above.
