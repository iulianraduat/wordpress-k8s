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
* `/* Turn HTTPS 'on' if HTTP_X_FORWARDED_PROTO contains 'https' */`
* `if (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && strpos($_SERVER['HTTP_X_FORWARDED_PROTO'], 'https') !== false) { $_SERVER['HTTPS'] = 'on'; }`

Unfortunatelly, the changes in `General Settings` for `WordPress Address (URL)` and `Site Address (URL)` are not an equivalent of the defines in wp-config.php.

These changes assume that you will access the wordpress website using HTTPS.

## Enable ssh in wordpress server

Change the root password in `install-sshd-in-pod.sh` and then run it.

Afterwards run `kubectl get svc | grep wordpress` to find the port mapped to internal port 22.

Now you can connect via ssh using `root@IP_NODE:MAPPED_PORT_22:/` and the password you set above.
