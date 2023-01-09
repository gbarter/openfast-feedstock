@echo on

REM cd %SRC_DIR%
REM set CC=cl
REM set FC=flang
REM set CC_LD=link
set LDFLAGS="-static"


mkdir build
cd build

cmake ^
    -S %SRC_DIR% ^
    -B . ^
    -G "Unix Makefiles" ^
    -DCMAKE_MAKE_PROGRAM="C:/ProgramData/chocolatey/bin/make.exe" ^
    -DCMAKE_FIND_LIBRARY_SUFFIXES=".a" ^
    -DCMAKE_BUILD_TYPE="RelWithDebInfo" ^
    -DCMAKE_C_FLAGS="-static" ^
    -DCMAKE_CXX_FLAGS="-static" ^
    -DCMAKE_Fortran_FLAGS="-static" ^
    -DBUILD_SHARED_LIBS=OFF ^
    -DDOUBLE_PRECISION=OFF ^
    -DCMAKE_PREFIX_PATH="%LIBRARY_PREFIX%" ^
    -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ^
    -DCMAKE_INSTALL_LIBDIR=lib ^
    -DBUILD_FASTFARM=ON ^
    -DCMAKE_C_COMPILER="C:/ProgramData/chocolatey/bin/gcc.exe" ^
    -DCMAKE_CXX_COMPILER="C:/ProgramData/chocolatey/bin/g++.exe" ^
    -DCMAKE_Fortran_COMPILER="C:/ProgramData/chocolatey/bin/gfortran.exe"

REM This config almost works with mingw through choco (v8 on Azure, v12 locally)
REM Has linking problems in that the executables don't run after the fact (choco bin-dir not in PATH)
REM    -G "MinGW Makefiles" ^
REM    -DCMAKE_MAKE_PROGRAM=make ^ REM (conda's make)

REM Use config RelWithDebInfo instead of Releease, otherwise 4hr build 
REM     -DCMAKE_BUILD_TYPE=RelWithDebInfo ^

REM Ninja gives an error, maybe something to clean up?
REM    -GNinja ^
REM [533/590] Generating Fortran dyndep file modules/map/CMakeFiles/maplib.dir/Fortran.dd
REM ninja: build stopped: multiple rules generate ftnmods/map_types.mod.

REM Builds only with shared libs locally, but nothing runs ("jom" added through choco)
REM     -DBUILD_SHARED_LIBS=ON ^
REM         -G "NMake Makefiles JOM"              ^

REM Haven't tried this yet
REM    -DBUILD_OPENFAST_CPP_API=ON

if errorlevel 1 exit /b 1
	
cmake --build . -j 1
if errorlevel 1 exit /b 1

cmake --install .
if errorlevel 1 exit /b 1
