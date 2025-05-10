#!/bin/bash
set -euo pipefail

# === Versions ===
CONTAINERD_VERSION="1.7.11"
RUNC_VERSION="1.1.12"
CNI_PLUGINS_VERSION="1.3.0"

ARCH="amd64"
OS="linux"

# === URLs ===
CONTAINERD_URL="https://github.com/containerd/containerd/releases/download/v${CONTAINERD_VERSION}/containerd-${CONTAINERD_VERSION}-${OS}-${ARCH}.tar.gz"
RUNC_URL="https://github.com/opencontainers/runc/releases/download/v${RUNC_VERSION}/runc.${ARCH}"
# CNI_PLUGINS_URL="https://github.com/containernetworking/plugins/releases/download/v1.3.0/cni-plugins-linux-amd64-v1.3.0.tgz"
CNI_PLUGINS_URL="https://github.com/containernetworking/plugins/releases/download/v${CNI_PLUGINS_VERSION}/cni-plugins-${OS}-${ARCH}-v${CNI_PLUGINS_VERSION}.tgz"
CONTAINERD_SERVICE_URL="https://raw.githubusercontent.com/containerd/containerd/main/containerd.service"

# === Directories ===
mkdir -p /usr/local/bin
mkdir -p /usr/local/sbin
mkdir -p /opt/cni/bin
mkdir -p /usr/local/lib/systemd/system

# === Install containerd ===
echo "Installing containerd..."
curl -L "${CONTAINERD_URL}" -o containerd.tar.gz
tar -C /usr/local -xzf containerd.tar.gz
rm containerd.tar.gz

# === Install containerd systemd service ===
echo "Setting up containerd systemd service..."
curl -L "${CONTAINERD_SERVICE_URL}" -o /usr/local/lib/systemd/system/containerd.service
systemctl daemon-reload
systemctl enable --now containerd

# === Install runc ===
echo "Installing runc..."
curl -L "${RUNC_URL}" -o /usr/local/sbin/runc
chmod +x /usr/local/sbin/runc

# === Install CNI plugins ===
echo "Installing CNI plugins..."
curl -L "${CNI_PLUGINS_URL}" -o cni-plugins.tgz
tar -C /opt/cni/bin -xzf cni-plugins.tgz
rm cni-plugins.tgz

echo "✅ containerd, runc, and CNI plugins installed successfully."

