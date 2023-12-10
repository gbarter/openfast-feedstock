@echo on

curl.exe --output webimage.exe --url https://registrationcenter-download.intel.com/akdlm/IRC_NAS/62641e01-1e8d-4ace-91d6-ae03f7f8a71f/w_BaseKit_p_2024.0.0.49563_offline.exe
start /b /wait webimage.exe -s -x -f webimage_extracted --log extract.log
del webimage.exe
webimage_extracted\bootstrapper.exe -s --action install --components=intel.oneapi.win.mkl.devel --eula=accept -p=NEED_VS2017_INTEGRATION=0 -p=NEED_VS2019_INTEGRATION=0 -p=NEED_VS2022_INTEGRATION=0 --log-dir=.

curl.exe --output webimage2.exe --url https://registrationcenter-download.intel.com/akdlm/IRC_NAS/5b36181e-4974-4733-91c7-0c10c54900a5/w_HPCKit_p_2024.0.0.49588_offline.exe
start /b /wait webimage2.exe -s -x -f webimage2_extracted --log extract.log
del webimage2.exe
webimage2_extracted\bootstrapper.exe -s --action install --components=intel.oneapi.win.ifort-compiler --eula=accept -p=NEED_VS2017_INTEGRATION=0 -p=NEED_VS2019_INTEGRATION=0 -p=NEED_VS2022_INTEGRATION=0 --log-dir=.

@call "C:\Program Files (x86)\Intel\oneAPI\setvars.bat"

mkdir build

cmake ^
    -S %SRC_DIR% ^
    -B build ^
    -G "Ninja" ^
    -DCMAKE_BUILD_TYPE="Release" ^
    -DDOUBLE_PRECISION=OFF ^
    -DBLA_STATIC=ON ^
    -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
    -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
    -DBUILD_FASTFARM=ON ^
    -DCMAKE_Fortran_COMPILER=ifort ^
    -DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreaded
if errorlevel 1 exit /b 1
	
cmake --build build  --target install
if errorlevel 1 exit /b 1

