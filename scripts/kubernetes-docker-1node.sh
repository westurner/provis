#!/bin/bash -e

# Derived from:
# - https://github.com/GoogleCloudPlatform/kubernetes/blob/master/docs/getting-started-guides/docker.md

kd1_kubectl_wget() {
_BIN=${_BIN:-'.'}
KUBECTL_BIN_URL='https://storage.googleapis.com/kubernetes-release/release/v0.14.2/bin/linux/amd64/kubectl'

(cd $_BIN; (test -x kubectl) || wget --continue "${KUBECTL_BIN_URL}")
}

kd1_docker() {
docker run --net=host -d kubernetes/etcd:2.0.5.1 /usr/local/bin/etcd --addr=127.0.0.1:4001 --bind-addr=0.0.0.0:4001 --data-dir=/var/etcd/data
docker run --net=host -d -v /var/run/docker.sock:/var/run/docker.sock  gcr.io/google_containers/hyperkube:v0.14.2 /hyperkube kubelet --api_servers=http://localhost:8080 --v=2 --address=0.0.0.0 --enable_server --hostname_override=127.0.0.1 --config=/etc/kubernetes/manifests
docker run -d --net=host --privileged gcr.io/google_containers/hyperkube:v0.14.2 /hyperkube proxy --master=http://127.0.0.1:8080 --v=2
}

kd1_kubectl() {
kubectl get nodes
kubectl -s http://localhost:8080 run-container nginx --image=nginx --port=80
kubectl expose rc nginx --port=80
}

kd1_main() {
    kd1_kubectl_wget
    # kd1_docker
    kd1_kubectl
}

if [[ "$BASH_SOURCE" == "$0" ]]; then
    kd1_main
fi
