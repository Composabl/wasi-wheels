#!/bin/bash
PYTHON_VERSION=3.11

set -eou pipefail

if [ ! -e venv ]; then
  python${PYTHON_VERSION} -m venv venv
fi

. venv/bin/activate
pip install setuptools build wheel 'cython<3.0.0'

ARCH_TRIPLET=_wasi_wasm32-wasi

export CC="${WASI_SDK_PATH}/bin/clang"
export CXX="${WASI_SDK_PATH}/bin/clang++"

export PYTHONPATH=$CROSS_PREFIX/lib/python${PYTHON_VERSION}

export CFLAGS="-I${CROSS_PREFIX}/include/python${PYTHON_VERSION} -I$(pwd)/include/include -D__EMSCRIPTEN__=1"
export CXXFLAGS="-I${CROSS_PREFIX}/include/python${PYTHON_VERSION}"
export LDSHARED=${CC}
export AR="${WASI_SDK_PATH}/bin/ar"
export RANLIB=true
export LDFLAGS="-shared"
export _PYTHON_SYSCONFIGDATA_NAME=_sysconfigdata_${ARCH_TRIPLET}

# pushd include
# ./bootstrap
# ./configure --host $(gcc -dumpmachine) --target wasm32-wasi 
# make
# popd

cd src
PYYAML_FORCE_CYTHON=1 python3 -m build -n -w
wheel unpack --dest build dist/*.whl
