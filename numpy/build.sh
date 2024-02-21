#!/bin/bash
PYTHON_VERSION=3.11

set -eou pipefail

ARCH_TRIPLET=_wasi_wasm32-wasi

if [ ! -e venv ]; then
  python${PYTHON_VERSION} -m venv venv
fi

. venv/bin/activate

export CC="${WASI_SDK_PATH}/bin/clang"
export CXX="${WASI_SDK_PATH}/bin/clang++"

export PYTHONPATH=$CROSS_PREFIX/lib/python${PYTHON_VERSION}

export CFLAGS="-I${CROSS_PREFIX}/include/python${PYTHON_VERSION} -D__EMSCRIPTEN__=1 -DNPY_NO_SIGNAL"
export CXXFLAGS="-I${CROSS_PREFIX}/include/python${PYTHON_VERSION}"
export LDSHARED=${CC}
export AR="${WASI_SDK_PATH}/bin/ar"
export RANLIB=true
export LDFLAGS="-shared"
export _PYTHON_SYSCONFIGDATA_NAME=_sysconfigdata_${ARCH_TRIPLET}
export NPY_DISABLE_SVML=1
export NPY_BLAS_ORDER=
export NPY_LAPACK_ORDER=

pip install cython setuptools
(cd src && python3 setup.py build --disable-optimization -j 4)

cp -a src/build/lib.*/numpy build/
