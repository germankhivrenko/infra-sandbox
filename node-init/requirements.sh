#!/bin/bash


K8S_VERSION=1.33


mkdir -p /etc/containerd
cp /vagrant/node-init/containerd-config.toml /etc/containerd/config.toml
cp /vagrant/node-init/99-k8s.conf /etc/sysctl.d/99-k8s.conf

modprobe br_netfilter
echo br_netfilter | tee /etc/modules-load.d/br_netfilter.conf

sysctl --system

apt-get update
apt-get install -y apt-transport-https ca-certificates gpg containerd

mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL "https://pkgs.k8s.io/core:/stable:/v${K8S_VERSION}/deb/Release.key" | gpg --yes --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v${K8S_VERSION}/deb/ /" | tee /etc/apt/sources.list.d/kubernetes.list

apt-get update
apt-get install --allow-change-held-packages -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl

