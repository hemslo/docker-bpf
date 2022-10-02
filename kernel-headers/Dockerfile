ARG KERNEL_VERSION
FROM linuxkit/kernel:${KERNEL_VERSION} as kernel
FROM alpine:3.16.2
WORKDIR /
COPY --from=kernel /kernel-dev.tar .
RUN tar xf kernel-dev.tar
