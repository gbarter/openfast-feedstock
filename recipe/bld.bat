@echo on

mkdir build
cd build

set LDFLAGS="-static"

cmake ^
    %CMAKE_ARGS% ^
    -DCMAKE_BUILD_TYPE="Release" ^
    -DDOUBLE_PRECISION=OFF ^
    -DBLA_VENDOR=OpenBLAS ^
    -DBLA_STATIC=ON ^
    -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
    -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
    -DBUILD_FASTFARM=ON ^
    ..

if errorlevel 1 exit /b 1

cmake --build . -j 2
if errorlevel 1 exit /b 1

cmake --install .
if errorlevel 1 exit /b 1
