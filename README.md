# docker-bpf

`docker-bpf` is a tool to help you run your BPF programs in Docker containers.

It will automatically mount linuxkit kernel headers, BTF and debugfs into the container.
So you can run BPF programs in Docker Desktop for Mac/Windows(WSL), and Linux of course.

Details can be found in [this blog post](https://hemslo.io/run-ebpf-programs-in-docker-using-docker-bpf/).

## Usage

### Default

```shell
docker run --rm -ti -v /var/run/docker.sock:/var/run/docker.sock ghcr.io/hemslo/docker-bpf:latest
```

By default, it will launch a container with bcc and bpftrace installed.

### With your own BPF image

If you already packaged your program in docker image, you can set the `BPF_IMAGE` environment variable to use that image instead.

```shell
docker run --rm -ti -e BPF_IMAGE=quay.io/iovisor/bpftrace:latest -v /var/run/docker.sock:/var/run/docker.sock ghcr.io/hemslo/docker-bpf:latest
```

Note you need to make sure the image matches the architecture of the host.
For example, if you are running on a M1/M2 Mac, you need to use `arm64` image.

### With additional arguments

Additional commands can be passed to the container.

```shell
docker run --rm -ti -v /var/run/docker.sock:/var/run/docker.sock ghcr.io/hemslo/docker-bpf:latest bpftrace --info
```

### With data volume mount

Additional data can be mounted into the container by setting `DATA_MOUNT` environment variable.

```shell
docker run --rm -ti -e DATA_MOUNT=$PWD:/data -v /var/run/docker.sock:/var/run/docker.sock ghcr.io/hemslo/docker-bpf:latest
```
