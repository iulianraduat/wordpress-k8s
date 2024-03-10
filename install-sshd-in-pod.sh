#!/bin/bash
POD=$(kubectl get pods|grep wordpress|grep -v mysql|cut -d ' ' -f1)
kubectl exec $POD -- apt-get update
kubectl exec $POD -- apt-get -y install openssh-server
kubectl exec $POD -- sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
kubectl exec $POD -- service ssh restart
kubectl exec $POD -- systemctl enable ssh
PWD=toor
kubectl exec $POD -- echo -e "$PWD\n$PWD" | passwd root
