#!/bin/bash
echo "=== Initializing Kubernetes Control Plane ==="

# Initialize cluster
sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --kubernetes-version=1.29.0

# Setup kubectl for normal user
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Install Calico CNI
echo "Installing Calico Network Plugin..."
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.0/manifests/calico.yaml

echo "=== Control Plane Setup Done ==="
echo "Run the following command on the Worker Node to join:"
echo "-----------------------------------------------------"
kubeadm token create --print-join-command
