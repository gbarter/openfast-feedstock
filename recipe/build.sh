#!/bin/bash

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
