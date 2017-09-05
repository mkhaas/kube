#!/bin/bash


# start etcd

docker run -d --name=k8s -p 8080:8080 gcr.io/google_containers/etcd:2.2.1 etcd --data-dir /var/lib/data

# start the api server in the same network namespace

docker run -d --net=container:k8s gcr.io/google_containers/hyperkube:v1.5.1 /apiserver --etcd-servers=http://127.0.0.1:4001 \
--service-cluster-ip-range=10.0.0.1/24 \
--insecure-bind-address=0.0.0.0 \
--insecure-port=8080 \
--admission-control=AlwaysAdmit

# start the controller manager in the same network namespace

docker run -d --net=container:k8s gcr.io/google_containers/hyperkube:v1.5.1 /controller-manager --master=127.0.0.1:8080
