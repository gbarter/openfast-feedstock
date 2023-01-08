@echo on

REM cd %SRC_DIR%
REM set CC=cl
REM set FC=flang
REM set CC_LD=link


mkdir build
cd build

cmake ^
    -S %SRC_DIR% ^
    -B . ^
    -G "MinGW Makefiles" ^
    -DCMAKE_MAKE_PROGRAM=make ^
    -DCMAKE_BUILD_TYPE=RelWithDebInfo ^
    -DDOUBLE_PRECISION=OFF ^
    -DBUILD_SHARED_LIBS=ON ^
    -DCMAKE_PREFIX_PATH="%LIBRARY_PREFIX%" ^
    -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ^
    -DCMAKE_INSTALL_LIBDIR=lib ^
    -DBUILD_FASTFARM=ON ^
    -DCMAKE_C_COMPILER="C:/ProgramData/chocolatey/bin/gcc.exe" ^
    -DCMAKE_CXX_COMPILER="C:/ProgramData/chocolatey/bin/g++.exe" ^
    -DCMAKE_Fortran_COMPILER="C:/ProgramData/chocolatey/bin/gfortran.exe"

REM This config works but runs out of memory during with -j CPU
REM    -G "MinGW Makefiles" ^
REM    -DCMAKE_MAKE_PROGRAM=make ^

REM Ninja setting:
REM    -GNinja ^
REM Ninja gives this error:
REM [533/590] Generating Fortran dyndep file modules/map/CMakeFiles/maplib.dir/Fortran.dd
REM ninja: build stopped: multiple rules generate ftnmods/map_types.mod.

REM Tested locally but not on conda-forge- have to add "jom" to choco list
REM         -G "NMake Makefiles JOM"              ^

if errorlevel 1 exit /b 1

REM    -DBUILD_OPENFAST_CPP_API=ON
REM         -DCMAKE_C_COMPILER=clang-cl           ^
REM         -DCMAKE_CXX_COMPILER=clang-cl         ^
REM         -DCMAKE_LINKER=lld-link               ^
REM         -DCMAKE_NM=llvm-nm
	
REM cmake --build .
REM cmake --install .

REM Runs out of memory
REM make -j %CPU_COUNT% install

REM See ninja error above
REM ninja -j %CPU_COUNT% install
make
if errorlevel 1 exit /b 1

make install
REM cmake --target install
if errorlevel 1 exit /b 1
