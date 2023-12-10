@echo on

curl.exe --output webimage.exe --url https://registrationcenter-download.intel.com/akdlm/IRC_NAS/5b36181e-4974-4733-91c7-0c10c54900a5/w_HPCKit_p_2024.0.0.49588_offline.exe
start /b /wait webimage.exe -s -x -f webimage_extracted --log extract.log
del webimage.exe
webimage_extracted\bootstrapper.exe -s --action install --components=intel.oneapi.win.ifort-compiler --eula=accept -p=NEED_VS2017_INTEGRATION=0 -p=NEED_VS2019_INTEGRATION=0 -p=NEED_VS2022_INTEGRATION=0 --log-dir=.
echo ONEAPI_ROOT=C:\Program Files (x86)\Intel\oneAPI >> %GITHUB_ENV%

@call "C:\Program Files (x86)\Intel\oneAPI\setvars-vcvarsall.bat"

mkdir build
cd build

set LDFLAGS="-static"

cmake ^
    -S %SRC_DIR% ^
    -B . ^
    -G "Ninja" ^
    -DCMAKE_BUILD_TYPE="Release" ^
    -DDOUBLE_PRECISION=OFF ^
    -DBLA_STATIC=ON ^
    -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
    -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
    -DBUILD_FASTFARM=ON ^
    -DCMAKE_C_COMPILER=cl.exe ^
    -DCMAKE_CXX_COMPILER=cl.exe ^
    -DCMAKE_Fortran_COMPILER=ifort
if errorlevel 1 exit /b 1
	
cmake --build . -j 2
if errorlevel 1 exit /b 1

cmake --install .
if errorlevel 1 exit /b 1
