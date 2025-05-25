#!/bin/bash

NODE_TYPE=${1:-worker}
K8S_API_SERVER_IP="${2}"
K8S_VERSION=1.33
POD_NETWORK_CIDR=10.244.0.0/16


if [ -z "${NODE_TYPE}" ] || [ -z "${K8S_API_SERVER_IP}" ]; then
  echo "Usage: $0 <node-type> <k8s-api-server-ip>"
  exit 1
fi


mkdir -p /etc/containerd
cp /vagrant/node-init/containerd-config.toml /etc/containerd/config.toml
cp /vagrant/node-init/99-k8s.conf /etc/sysctl.d/99-k8s.conf

modprobe br_netfilter
sysctl --system

apt-get update
apt-get install -y apt-transport-https ca-certificates gpg containerd

mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL "https://pkgs.k8s.io/core:/stable:/v${K8S_VERSION}/deb/Release.key" | gpg --yes --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v${K8S_VERSION}/deb/ /" | tee /etc/apt/sources.list.d/kubernetes.list
apt-get update
apt-get install --allow-change-held-packages -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl


if [ "${NODE_TYPE}" = "control-plane" ]; then
    kubeadm init --apiserver-advertise-address=${K8S_API_SERVER_IP} --pod-network-cidr=${POD_NETWORK_CIDR}

    export KUBECONFIG=/etc/kubernetes/admin.conf

    kubectl apply -f /vagrant/node-init/kube-flannel.yml

    kubeadm token create --print-join-command > /vagrant/node-init/kubeadm-join.sh 2>/dev/null
else
  while [ ! -f /vagrant/node-init/kubeadm-join.sh ]; do
    echo "Waiting for kubeadm join script..."
    sleep 5
  done
  bash /vagrant/node-init/kubeadm-join.sh
fi

