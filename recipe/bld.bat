@echo on

REM cd %SRC_DIR%
REM set CC=cl
REM set FC=flang
REM set CC_LD=link
REM set FFLAGS="-static-libgfortran" "
REM -static-libquadmath -static"
set CFLAGS="-static"
set CXXFLAGS="-static"
set LDFLAGS="-static"


mkdir build
cd build

cmake ^
    -S %SRC_DIR% ^
    -B . ^
    -G "MinGW Makefiles" ^
    -DCMAKE_MAKE_PROGRAM="C:/ProgramData/chocolatey/bin/mingw32-make.exe" ^
    -DCMAKE_BUILD_TYPE=RelWithDebInfo ^
    -DCMAKE_FIND_LIBRARY_SUFFIXES=".a" ^
    -DBUILD_SHARED_LIBS=OFF ^
    -DDOUBLE_PRECISION=OFF ^
    -DCMAKE_PREFIX_PATH="%LIBRARY_PREFIX%" ^
    -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ^
    -DCMAKE_INSTALL_LIBDIR=lib ^
    -DBUILD_FASTFARM=ON ^
    -DCMAKE_C_COMPILER="C:/ProgramData/chocolatey/bin/gcc.exe" ^
    -DCMAKE_CXX_COMPILER="C:/ProgramData/chocolatey/bin/g++.exe" ^
    -DCMAKE_Fortran_COMPILER="C:/ProgramData/chocolatey/bin/gfortran.exe"

REM This config works with mingw through choco (v8 on Azure, v12 locally)
REM    -G "MinGW Makefiles" ^
REM    -DCMAKE_MAKE_PROGRAM=make ^

REM Ninja gives an error, maybe something to clean up?
REM    -GNinja ^
REM [533/590] Generating Fortran dyndep file modules/map/CMakeFiles/maplib.dir/Fortran.dd
REM ninja: build stopped: multiple rules generate ftnmods/map_types.mod.

REM Builds only with shared libs locally, but nothing runs ("jom" added through choco)
REM     -DBUILD_SHARED_LIBS=ON ^
REM         -G "NMake Makefiles JOM"              ^

REM Does not link nicely with MinGW on Azure
REM     -DBUILD_SHARED_LIBS=ON ^


if errorlevel 1 exit /b 1

REM    -DBUILD_OPENFAST_CPP_API=ON
REM         -DCMAKE_C_COMPILER=clang-cl           ^
REM         -DCMAKE_CXX_COMPILER=clang-cl         ^
REM         -DCMAKE_LINKER=lld-link               ^
REM         -DCMAKE_NM=llvm-nm
	
cmake --build . -j 1

REM Runs out of memory
REM make -j %CPU_COUNT% install

REM See ninja error above
REM ninja -j %CPU_COUNT% install
REM make
if errorlevel 1 exit /b 1

REM make install
cmake --install .
if errorlevel 1 exit /b 1
