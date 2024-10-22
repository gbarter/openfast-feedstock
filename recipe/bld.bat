@echo on

mkdir build

:: set compilers to gcc
set "CC=gcc"
set "CXX=g++"
set "FC=gfortran"


cmake ^
    -S %SRC_DIR% ^
    -B build ^
    -G "Ninja" ^
    -DCMAKE_BUILD_TYPE="Release" ^
    -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
    -DCMAKE_Fortran_COMPILER=%FC% ^
    -DCMAKE_C_COMPILER=%CC% ^
    -DCMAKE_CXX_COMPILER=%CXX% ^
    -DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreaded ^
    -DBLA_STATIC=ON ^
    -DDOUBLE_PRECISION=OFF ^
    -DBUILD_FASTFARM=ON
if errorlevel 1 exit /b 1
	
cmake --build build  --target install -j %CPU_COUNT%
if errorlevel 1 exit /b 1
