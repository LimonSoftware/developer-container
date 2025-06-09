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

## Host setup

Steps to setup Host to use developer containers.

Clone the repository,


```
$ git clone https://github.com/LimonSoftware/developer-container.git
```

Modify your PATH variable commonly at $HOME/.profile, adding the developer-container
repository path, assuming the clone is on current working directory.

```
$ echo "export PATH=\"$(pwd)/developer-container:\$PATH\"" >> .profile
```

Relogin or source the new $HOME/.profile to enable it (only in current shell).

```
$ source .profile
```

## Build

The image by default is based on debian stable, this can be easily customizable,
look at dc-build.sh, env-build.sh and Dockerfile.in (inside image directory).


The docker output image/tag is set in env-build.sh, and can be overrided with
environment variables DOCKER\_DEVEL\_{IMAGE,TAG}.

```
$ dc-build.sh
```

## Run

The run script takes 'name' as first argument it starts the container and sets 'name'
to provide access.

By default it sets to autostart and share host user context (map $HOME and ssh auth).
Environment to disabled this are DEVEL\_CONTAINER\_{AUTOSTART, USER\_CONTEXT},

An enviroment variable DEVEL\_CONTAINER\_PRIVILEDGED (by default disabled), is available to enable priviledged containers and map host /dev.


```
$ dc-run.sh test
```

## Execute

A simple wrapper is provided to execute actions inside the container by default spawns
a shell via `su -l` with provided $USER\_NAME (env-host.sh.in).

Shell example:


```
$ dc-exec.sh test
```

If more than one argument (container\_name) is provided it calls directly the command in the container using root.

Apt example (root):


```
$ dc-exec.sh test apt-get update
```

## Flavours

This set of scripts supports customizations at level of build and run scripts.

Its needs to implement image/flavours/flavour-{build,run}.sh scripts sourced via
common\_load\_flavour (env-common.sh) and called by env-{build, run}.sh at
their respective step.

### Build (example using yocto)

```
$ dc-build.sh yocto
```

### Run


```
$ dc-run.sh test yocto
```
