#!/bin/bash

set -e -o pipefail

echo "Building e2e test suite"
make build-e2e-test

echo "Starting kubevirtci cluster"
./kubevirtci up

echo "Building and installing capk manager container"
./kubevirtci sync

echo "Running e2e test suite"
export KUBECONFIG=$(./kubevirtci kubeconfig)
export TENANT_CLUSTER_KUBERNETES_VERSION="v1.32.1"
export NODE_VM_IMAGE_TEMPLATE=quay.io/capk/ubuntu-2404-container-disk:${TENANT_CLUSTER_KUBERNETES_VERSION}
export CRI_PATH=/var/run/containerd/containerd.sock
export ROOT_VOLUME_SIZE=13Gi
export STORAGE_CLASS_NAME=local
make e2e-test
