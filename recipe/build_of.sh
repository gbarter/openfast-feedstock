#!/bin/bash

mkdir build

cmake \
    -S ${SRC_DIR} \
    -B build \
    -G "Unix Makefiles" \
    -DCMAKE_BUILD_TYPE="Release" \
    -DCMAKE_INSTALL_PREFIX=${PREFIX} \
    -DGIT_DESCRIBE=v${PKG_VERSION} \
    -DDOUBLE_PRECISION=OFF \
    -DBLA_VENDOR=OpenBLAS \
    -DBLA_STATIC=ON \
    -DBUILD_FASTFARM=ON

cmake --build build --target install -j ${CPU_COUNT}
