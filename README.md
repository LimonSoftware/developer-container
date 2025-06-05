# Developer container support

Aims to provide a developer container based on Debian-based containers.

A container build is made mapping a predefined workspace folder
(default $HOME/workspaces) for each developer container, commonly defined
by name company or community commonly used.

The containers provides,

- Installation of minimal developer tools like build-essential, tmux, vim.
- Network isolation using tailscale.
- Web proxy (tinyproxy) to route traffic via the container.
- Access to docker host to start another containers.

## Build container devel image

The image by default is based on debian stable, this can be easily customizable,
look at image-build.sh, env-build.sh and Dockerfile.in (inside image directory).

### Build

The docker output image/tag is set in env-build.sh, and can be overrided with
environment variables DOCKER\_DEVEL\_{IMAGE,TAG}.

```
$ ./image-build.sh
```

### Run

The run script takes 'name' as first argument it starts the container and sets 'name'
to provide access.

By default it sets to autostart and share host user context (map $HOME and ssh auth).
Environment to disabled this are DEVEL\_CONTAINER\_{AUTOSTART, USER\_CONTEXT},

An enviroment variable DEVEL\_CONTAINER\_PRIVILEDGED (by default disabled), is available to enable priviledged containers and map host /dev.


```
$ ./image-run.sh test
```
## Flavours

This set of scripts supports customizations at level of build and run scripts.

Its needs to implement image/flavours/flavour-{build,run}.sh scripts sourced via
common\_load\_flavour (env-common.sh) and called by env-{build, run}.sh at
their respective step.

### Build (example using yocto)

```
$ ./image-build.sh yocto
```

### Run


```
$ ./image-run.sh test yocto
```
