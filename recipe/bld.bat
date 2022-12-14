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
    -G "Ninja" ^
    -DDOUBLE_PRECISION=OFF ^
    -DCMAKE_INSTALL_PREFIX="%PREFIX%" ^
    -DCMAKE_INSTALL_LIBDIR=lib ^
    -DBUILD_FASTFARM=ON ^
    -DCMAKE_C_COMPILER=clang-cl           ^
    -DCMAKE_CXX_COMPILER=clang-cl         ^
    -DCMAKE_FC_COMPILER=flang         ^
    -DCMAKE_LINKER=lld-link               ^
    -DCMAKE_NM=llvm-nm
    # -DBUILD_OPENFAST_CPP_API=ON

if errorlevel 1 exit /b 1

REM cmake -S . -B build  ^
REM         -G "Ninja"                            ^
REM OR
REM         -G "NMake Makefiles"                  ^
REM         -DCMAKE_C_COMPILER=clang-cl           ^
REM         -DCMAKE_CXX_COMPILER=clang-cl         ^
REM         -DCMAKE_LINKER=lld-link               ^
REM         -DCMAKE_NM=llvm-nm
	
REM nmake -j %CPU_COUNT% install

cmake --build . --target install
if errorlevel 1 exit /b 1
