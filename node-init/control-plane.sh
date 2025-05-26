#!/bin/bash


K8S_API_SERVER_IP="${1}"
POD_NETWORK_CIDR=10.244.0.0/16


kubeadm init --apiserver-advertise-address=${K8S_API_SERVER_IP} --pod-network-cidr=${POD_NETWORK_CIDR}

export KUBECONFIG=/etc/kubernetes/admin.conf

kubectl apply -f /vagrant/node-init/kube-flannel.yml

kubeadm token create --print-join-command > /vagrant/node-init/kubeadm-join.sh 2>/dev/null

