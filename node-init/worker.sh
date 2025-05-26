#!/bin/bash


while [ ! -f /vagrant/node-init/kubeadm-join.sh ]; do
  echo "Waiting for kubeadm join script..."
  sleep 5
done
bash /vagrant/node-init/kubeadm-join.sh

