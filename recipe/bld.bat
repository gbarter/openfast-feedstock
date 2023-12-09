@echo on

mkdir build
cd build

:: Not sure what this is
:: set LDFLAGS="-static"


:: set compilers to clang-cl
set "CC=clang-cl"
set "CXX=clang-cl"

:: flang 17 still uses "temporary" name
set "FC=flang-new"

:: need to read clang version for path to compiler-rt
FOR /F "tokens=* USEBACKQ" %%F IN (`clang.exe -dumpversion`) DO (
    SET "CLANG_VER=%%F"
)

:: attempt to match flags for flang as we set them for clang-on-win, see
:: https://github.com/conda-forge/clang-win-activation-feedstock/blob/main/recipe/activate-clang_win-64.sh
:: however, -Xflang --dependent-lib=msvcrt currently fails as an unrecognized option, see also
:: https://github.com/llvm/llvm-project/issues/63741
set "FFLAGS=-D_CRT_SECURE_NO_WARNINGS -D_MT -D_DLL --target=x86_64-pc-windows-msvc -nostdlib"
set "LDFLAGS=--target=x86_64-pc-windows-msvc -nostdlib -Xclang --dependent-lib=msvcrt -fuse-ld=lld"
set "LDFLAGS=%LDFLAGS% -Wl,-defaultlib:%BUILD_PREFIX%/Library/lib/clang/!CLANG_VER:~0,2!/lib/windows/clang_rt.builtins-x86_64.lib"


cmake ^
    %CMAKE_ARGS% ^
    -DCMAKE_BUILD_TYPE="Release" ^
    -DDOUBLE_PRECISION=OFF ^
    -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
    -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
    -DBUILD_FASTFARM=ON ^
    ..

if errorlevel 1 exit /b 1

cmake --build . -j 2
if errorlevel 1 exit /b 1

cmake --install .
if errorlevel 1 exit /b 1
