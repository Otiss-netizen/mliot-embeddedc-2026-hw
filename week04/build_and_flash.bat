@echo off
setlocal

echo ===============================================
echo Building HW04_GPIO Project
echo ===============================================


REM Clean build directory (using batch commands, not PowerShell)
if exist build (
    echo Cleaning build directory...
    rmdir /s /q build
)

REM Create build directory
mkdir build

REM Configure with CMake
echo.
echo [1/4] Configuring...
cmake -B build -G Ninja
if %ERRORLEVEL% neq 0 (
    echo Configuration failed!
    pause
    exit /b 1
)

REM Build
echo.
echo [2/4] Building...
ninja -C build
if %ERRORLEVEL% neq 0 (
    echo Build failed!
    pause
    exit /b 1
)

REM Generate Binary
echo.
echo [3/4] Generating binary...
arm-none-eabi-objcopy -O binary build/HW04_GPIO.elf build/HW04_GPIO.bin
if %ERRORLEVEL% neq 0 (
    echo Binary generation failed!
    pause
    exit /b 1
)

REM Summary
echo.
echo [4/4] Build Summary
echo ===============================================
if exist build\*.hex (
    dir build\*.hex | find ".hex"
) else (
    echo No .hex file generated!
)

if exist build\*.bin (
    dir build\*.bin | find ".bin"
) else (
    echo No .bin file generated!
)

echo ===============================================
echo Build completed successfully!
echo.

STM32_Programmer_CLI -c port=SWD sn=37FF71064E573436D2631043 -w build/HW04_GPIO.bin 0x08000000 -v -rst

pause
endlocal