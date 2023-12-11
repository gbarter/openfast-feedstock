#!/bin/bash

if [[ "$CONDA_BUILD_CROSS_COMPILATION" == 1 && $target_platform == "osx-arm64" ]]; then
    export LDFLAGS="${LDFLAGS:-} -lquadmath"
fi

mkdir build

cmake \
    -S ${SRC_DIR} \
    -B build \
    -G "Ninja" \
    -DCMAKE_BUILD_TYPE="Release" \
    -DCMAKE_INSTALL_PREFIX=${PREFIX} \
    -DDOUBLE_PRECISION=OFF \
    -DBLA_VENDOR=OpenBLAS \
    -DBLA_STATIC=ON \
    -DBUILD_FASTFARM=ON

cmake --build build --target install -j ${CPU_COUNT}
