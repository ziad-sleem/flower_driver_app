@echo off
set FEATURE_NAME=%1

if "%FEATURE_NAME%"=="" (
    echo Please provide a feature name.
    echo Usage: create_feature.bat ^<feature_name^>
    exit /b 1
)

set BASE_DIR=lib\features\%FEATURE_NAME%

echo Creating feature architecture for: %FEATURE_NAME%

mkdir "%BASE_DIR%\api\api_client" 2>nul
mkdir "%BASE_DIR%\api\datasources" 2>nul

mkdir "%BASE_DIR%\data\datasources" 2>nul
mkdir "%BASE_DIR%\data\models" 2>nul
mkdir "%BASE_DIR%\data\repositories" 2>nul

mkdir "%BASE_DIR%\domain\entities" 2>nul
mkdir "%BASE_DIR%\domain\repositories" 2>nul
mkdir "%BASE_DIR%\domain\use_cases" 2>nul

mkdir "%BASE_DIR%\presentation\cubit" 2>nul
mkdir "%BASE_DIR%\presentation\pages" 2>nul
mkdir "%BASE_DIR%\presentation\widgets" 2>nul

echo Feature architecture created at %BASE_DIR%
