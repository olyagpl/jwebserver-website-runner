# Jwebserver Running GraalVM Documentation Website 

GraalVM’s documentation website served with `jwebserver` in a Docker container on Oracle Cloud Infrastructure.

This example demonstrates **how to optimize a Java application for file size taking advantage of different Native Image containerisation and linking options**. 
The various Dockerfiles copy a native executable or `jlink` generated custom runtime image folder along with static website pages into a container image, and set the entrypoint.

> The `jwebserver` tool is a minimal HTTP server for serving static files from a single directory hierarchy, added in Java 18.

### Prerequisites

* x86 Linux 
* Docker (or Podman)
* [GraalVM for JDK 23 Early Access build](https://github.com/graalvm/oracle-graalvm-ea-builds/releases)
* The `musl` toolchain

## Setup

1. Clone this repository with Git:
    ```bash
    git clone https://github.com/olyagpl/jwebserver-website-runner.git 
    ```

2. To complete all steps in this demo, you need the following `zlib` packages installed: zlib.x86_64, zlib-devel.x86_64;zlib-static.x86_64. Enter the example directory and run the following script to download and configure the `musl` toolchain, and install `zlib` into the toolchain:
    ```bash
    cd jwebserver-website-runner
    ```
    ```bash
    ./setup-musl.sh
    ```

3. Download [UPX](https://upx.github.io/), an advanced executable file compressor:
    ```bash
    ./setup-upx.sh
    ```

## Create Container Images

1. Using `jlink`, create a custom runtime for the application, package it into a container image that contains a JDK.
    ```bash
    ./build-jlink-runner.sh
    ```

2. Build a fully dynamically linked executable and package it in a distroless container image with just enough to run the application.
    ```bash
    ./build-dynamic-runner.sh
    ```

3. Build a mostly statically linked executable, by passing `--static-nolibc` to the `native-image` tool, and package it into a container image that provides `glibc`.
    ```bash
    ./build-mostly-static-runner.sh
    ```

    _What can you do next to reduce the size even more?_

4. Build a fully static executable, by passing `--static --libc=musl` to the `native-image` tool, and package it into a _scratch_ container. (It requires the `musl` toolchain.)
    ```bash
    ./build-static-runner.sh
    ```

5. Compress the fully static executable, created at the previous step, with UPX, package it into a _scratch_ container.
    ```bash
    ./build-static-compressed-runner.sh
    ```
    Note that UPX loads the native executable into the memory, unpackages it, and then compresses.

## Serve the Website

Run any of the container images to serve the website, mapping the ports, for example: 
```bash
docker run --rm -p8000:8000 website-runner:scratch.static
```

Finally, open the website in a browser at _http://<SERVER_IP>:8080/_, where the `<SERVER_IP>` is the public API address of the remote host.
If you are running the example locally, not on a remote host, just open [http://localhost:8000](http://localhost:8000). 

To stop a running container, find out the container image ID and stop it:
```bash
docker ps
```
```bash
docker stop <image id>
```

To clean up all images, run the `./clean.sh` script provided for that purpose. 

## Container Images and Native Executables File Sizes Comparison

Compare the sizes of the various Docker container images and native executables:
```bash
ls -lh runner*
```

```bash
docker images website-runner
```

> Note that the website static pages added 44M to the container images size!

### Learn More

- [Static and Mostly Static Images](https://www.graalvm.org/latest/reference-manual/native-image/guides/build-static-executables/)
- [Tiny Java Containers by Shaun Smith at DevoxxUK 2022](https://youtu.be/6wYrAtngIVo)