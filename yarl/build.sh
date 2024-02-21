#!/bin/bash
PYTHON_VERSION=3.11

set -eou pipefail

if [ ! -e venv ]; then
  python${PYTHON_VERSION} -m venv venv
fi

. venv/bin/activate
pip install build wheel expandvars setuptools
pip install -r src/requirements/cython.txt

ARCH_TRIPLET=_wasi_wasm32-wasi

export CC="${WASI_SDK_PATH}/bin/clang"
export CXX="${WASI_SDK_PATH}/bin/clang++"

export PYTHONPATH=$CROSS_PREFIX/lib/python${PYTHON_VERSION}

export CFLAGS="-I${CROSS_PREFIX}/include/python${PYTHON_VERSION} -D__EMSCRIPTEN__=1"
export CXXFLAGS="-I${CROSS_PREFIX}/include/python${PYTHON_VERSION}"
export LDSHARED=${CC}
export AR="${WASI_SDK_PATH}/bin/ar"
export RANLIB=true
export LDFLAGS="-shared"
export _PYTHON_SYSCONFIGDATA_NAME=_sysconfigdata_${ARCH_TRIPLET}

cd src
python3 -m build -n -w
wheel unpack --dest build dist/*.whl 
