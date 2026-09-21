@echo off
rem Configure + build llama-kvmem-server with the Vulkan backend on Windows.
rem Works for any GPU with a Vulkan 1.2+ driver (AMD Radeon, Intel Arc/Core,
rem NVIDIA). No CUDA toolkit required. No machine-specific paths: everything
rem comes from environment variables that the Vulkan SDK installer sets.
rem
rem Requirements:
rem   - Vulkan SDK (https://vulkan.lunarg.com)  -> sets VULKAN_SDK
rem   - CMake in PATH
rem   - A C++17 compiler: MSVC (vcvarsall) or MinGW-w64 (MinGW Makefiles)
rem
rem Optional overrides:
rem   set BUILD_DIR=...      (default: build-vulkan-win under repo root)
rem   set GENERATOR=...      (default: auto - "MinGW Makefiles" if gcc found)
rem   set NPROC=...          (default: %%NUMBER_OF_PROCESSORS%%)

setlocal
set "ROOT=%~dp0.."
pushd "%ROOT%"

if not defined VULKAN_SDK (
    echo [build-vulkan-windows] VULKAN_SDK is not set. Install the Vulkan SDK first. 1>&2
    exit /b 1
)

if not defined BUILD_DIR set "BUILD_DIR=%ROOT%\build-vulkan-win"
if not defined GENERATOR (
    where gcc >nul 2>nul && set "GENERATOR=MinGW Makefiles"
)
if not defined NPROC set "NPROC=%NUMBER_OF_PROCESSORS%"

set "ARGS=-DCMAKE_BUILD_TYPE=Release -DGGML_CUDA=OFF -DGGML_VULKAN=ON -DLLAMA_CURL=OFF"
set "ARGS=%ARGS% -DVulkan_INCLUDE_DIR=%VULKAN_SDK%/Include"
set "ARGS=%ARGS% -DVulkan_LIBRARY=%VULKAN_SDK%/Lib/vulkan-1.lib"
set "ARGS=%ARGS% -DVulkan_GLSLC_EXECUTABLE=%VULKAN_SDK%/Bin/glslc.exe"
set "ARGS=%ARGS% -DCMAKE_PREFIX_PATH=%VULKAN_SDK%"
if defined GENERATOR set "ARGS=-G "%GENERATOR%" %ARGS%"

cmake -S "%ROOT%" -B "%BUILD_DIR%" %ARGS% %* || exit /b 1
cmake --build "%BUILD_DIR%" -j %NPROC% || exit /b 1

echo.
echo Binaries under %BUILD_DIR%\bin
echo.
echo This machine may have several Vulkan GPUs. Pick the right one explicitly:
echo   vulkaninfo --summary            ^(or: bin\llama-kvmem-server.exe --list-devices^)
echo   set GGML_VULKAN_DEVICE=^<index^> before starting the server.
popd
endlocal
