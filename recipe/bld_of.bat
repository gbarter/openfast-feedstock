@echo on

REM curl.exe --output webimage.exe --url https://registrationcenter-download.intel.com/akdlm/IRC_NAS/62641e01-1e8d-4ace-91d6-ae03f7f8a71f/w_BaseKit_p_2024.0.0.49563_offline.exe
REM start /b /wait webimage.exe -s -x -f webimage_extracted --log extract.log
REM del webimage.exe
REM webimage_extracted\bootstrapper.exe -s --action install --components=intel.oneapi.win.mkl.devel --eula=accept -p=NEED_VS2017_INTEGRATION=0 -p=NEED_VS2019_INTEGRATION=0 -p=NEED_VS2022_INTEGRATION=0 --log-dir=.

REM curl.exe --output webimage2.exe --url https://registrationcenter-download.intel.com/akdlm/IRC_NAS/5b36181e-4974-4733-91c7-0c10c54900a5/w_HPCKit_p_2024.0.0.49588_offline.exe
REM start /b /wait webimage2.exe -s -x -f webimage2_extracted --log extract.log
REM del webimage2.exe
REM webimage2_extracted\bootstrapper.exe -s --action install --components=intel.oneapi.win.ifort-compiler --eula=accept -p=NEED_VS2017_INTEGRATION=0 -p=NEED_VS2019_INTEGRATION=0 -p=NEED_VS2022_INTEGRATION=0 --log-dir=.

REM @call "C:\Program Files (x86)\Intel\oneAPI\setvars.bat"
REM    -DCMAKE_Fortran_COMPILER=ifort ^

set "CC=%BUILD_PREFIX%\Library\bin\x86_64-w64-mingw32-gcc.exe"
set "CXX=%BUILD_PREFIX%\Library\bin\x86_64-w64-mingw32-g++.exe"
set "FC=%BUILD_PREFIX%\Library\bin\x86_64-w64-mingw32-gfortran.exe"

mkdir build

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
    -DGIT_DESCRIBE=v%PKG_VERSION% ^
    -DBLA_STATIC=ON ^
    -DDOUBLE_PRECISION=OFF ^
    -DBUILD_FASTFARM=ON
if errorlevel 1 exit /b 1
	
cmake --build build  --target install -j %CPU_COUNT%
if errorlevel 1 exit /b 1

