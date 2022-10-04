#!/usr/bin/env sh

set -eu

cd "$(dirname "$0")"

BPF_IMAGE="${BPF_IMAGE:-"docker-bpf-env:latest"}"
DATA_MOUNT="${DATA_MOUNT:-"/tmp/docker-bpf-env:/tmp/docker-bpf-env"}"

KERNEL_HEADERS="/usr/src"
OS_RELEASE=$(docker run --rm -it alpine:3.16.2 uname -r)

build_linuxkit_headers() {
  KERNEL_VERSION=$(echo "$OS_RELEASE" | cut -d - -f 1)

  docker build \
    --build-arg KERNEL_VERSION="${KERNEL_VERSION}" \
    -t linuxkit-kernel-headers:"$KERNEL_VERSION" \
    ./kernel-headers

  docker run --rm \
    -v linuxkit-kernel-headers:/usr/src \
    linuxkit-kernel-headers:"$KERNEL_VERSION"

  KERNEL_HEADERS="linuxkit-kernel-headers"
}

docker volume create --driver local --opt type=debugfs --opt device=debugfs debugfs

if [ "$BPF_IMAGE" = "docker-bpf-env:latest" ]; then
  docker build -t docker-bpf-env:latest ./docker-bpf-env
fi

case $OS_RELEASE in
*linuxkit*) build_linuxkit_headers ;;
esac

docker run -ti --rm \
  -v $KERNEL_HEADERS:/usr/src:ro \
  -v /lib/modules/:/lib/modules:ro \
  -v /sys/kernel:/sys/kernel:ro \
  -v debugfs:/sys/kernel/debug:ro \
  -v "$DATA_MOUNT" \
  --net=host \
  --pid=host \
  --privileged \
  "$BPF_IMAGE" "$@"
