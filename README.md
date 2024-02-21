# WASI Wheels

This repository contains build wheels using the Dynamic Linking support in the WASI SDK

## Building

```bash
# Init Submoduls
git submodule update --init --recursive
```

## Upgrading Python

### CPython

Biggest dependency of this project. To upgrade, we need to pick the correct Tag from the [CPython Repository]() and apply the [patch](https://github.com/dicej/cpython/commit/91d0d482b6dfff5fc8955218575634b0fd05ea77)

```bash
# Checkout to Tag
cd cpython
git fetch --tags
git checkout tags/v3.11.8

# Setup the Patch Repository as a new Remote
git remote add patch-repo https://github.com/dicej/cpython.git
git fetch patch-repo

# Apply Patch from the URL
git cherry-pick 91d0d482b6dfff5fc8955218575634b0fd05ea77
```

## Issues

### You must get working getaddrinfo() function or pass the "--disable-ipv6" option to configure.

WSL 2 does not support IPv6, so we need to disable it.

```bash
PYTHON_CONFIGURE_OPTS="--disable-ipv6" make -j4
```
