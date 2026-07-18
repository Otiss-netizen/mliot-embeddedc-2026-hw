@echo off

echo STEP 1: CLEANING BUILD DIRECTORY
if exist build (
    echo Deleting existing build folder...
    rmdir /s /q build
)
echo.

echo STEP 2: CONFIGURING PROJECT WITH CMAKE
cmake -B build -G Ninja
if %ERRORLEVEL% neq 0 (
    echo [ERROR] Configuration failed!
    exit /b 1
)
echo.

echo STEP 3: COMPILING FIRMWARE WITH NINJA
ninja -C build
if %ERRORLEVEL% neq 0 (
    echo [ERROR] Build failed!
    exit /b 1
)
echo.

echo STEP 4: FLASHING FIRMWARE TO TARGET MCU
STM32_Programmer_CLI -c port=SWD sn=37FF71064E573436D2631043 -w build/app_firmware.bin 0x08000000 -v -rst
if %ERRORLEVEL% neq 0 (
    echo [ERROR] Flash failed! Please check your ST-Link connection.
    exit /b 1
)
echo.
echo [SUCCESS] Build and Flash completed successfully!