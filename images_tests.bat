@echo off
setlocal enabledelayedexpansion

:: Define base paths
set BASE_PATH=C:\Users\SLHan\OneDrive\Desktop\Capstone\Postman
set COLLECTION_PATH=%BASE_PATH%\Collections\Images.postman_collection.json
set ENV_PATH=%BASE_PATH%\Environments\images.postman_environment.json
set TEMP_ENV_PATH=%BASE_PATH%\Environments\temp_env.json
set REPORT_PATH=%BASE_PATH%\newman-report

:: Data files
set LOGIN_USER_DATA_PATH=%BASE_PATH%\Data\Images\login_user.json
set LOGIN_ADMIN_DATA_PATH=%BASE_PATH%\Data\Images\login_admin.json
set LOGIN_HARBINGER_DATA_PATH=%BASE_PATH%\Data\Images\login_harbinger.json

:: Display the paths for debugging
echo BASE_PATH is "%BASE_PATH%"
echo COLLECTION_PATH is "%COLLECTION_PATH%"
echo ENV_PATH is "%ENV_PATH%"
echo TEMP_ENV_PATH is "%TEMP_ENV_PATH%"
echo LOGIN_USER_DATA_PATH is "%LOGIN_USER_DATA_PATH%"
echo LOGIN_ADMIN_DATA_PATH is "%LOGIN_ADMIN_DATA_PATH%"
echo LOGIN_HARBINGER_DATA_PATH is "%LOGIN_HARBINGER_DATA_PATH%"
echo REPORT_PATH is "%REPORT_PATH%"

:: Generate TIMESTAMP
for /f "tokens=1-3 delims=-/ " %%a in ("%date%") do (
    set YYYY=%%c
    set MM=%%a
    set DD=%%b
)
for /f "tokens=1-3 delims=:.," %%a in ("%time%") do (
    set HH=%%a
    set Min=%%b
    set Sec=%%c
)
set HH=%HH: =0%
set TIMESTAMP=%YYYY%%MM%%DD%_%HH%%Min%%Sec%

:: Create report directory if it doesn't exist
if not exist "%REPORT_PATH%" (
    mkdir "%REPORT_PATH%"
)

:: Copy the original environment file to temporary environment file
echo Copying environment file to temporary environment...
copy /Y "%ENV_PATH%" "%TEMP_ENV_PATH%"

:: Verify that the temporary environment file exists
if not exist "%TEMP_ENV_PATH%" (
    echo TEMP_ENV_PATH does not exist after copy.
    exit /b 1
)

:: -------------------------------
:: Running User Login Test...
:: -------------------------------
echo Running User Login Test...
call newman run "%COLLECTION_PATH%" ^
    --iteration-data "%LOGIN_USER_DATA_PATH%" ^
    --environment "%TEMP_ENV_PATH%" ^
    --folder "Login" ^
    --reporters cli,htmlextra ^
    --reporter-htmlextra-export "%REPORT_PATH%\login_user_results_%TIMESTAMP%.html" ^
    --export-environment "%TEMP_ENV_PATH%"
if %ERRORLEVEL% neq 0 (
    echo User login failed.
    del "%TEMP_ENV_PATH%"
    exit /b 1
)
echo User login passed.

:: -------------------------------
:: Running Create Collection Test...
:: -------------------------------
echo Running Create Collection Test...
call newman run "%COLLECTION_PATH%" ^
    --environment "%TEMP_ENV_PATH%" ^
    --folder "Create Collection" ^
    --reporters cli,htmlextra ^
    --reporter-htmlextra-export "%REPORT_PATH%\create_collection_results_%TIMESTAMP%.html" ^
    --export-environment "%TEMP_ENV_PATH%"
if %ERRORLEVEL% neq 0 (
    echo Create collection test failed.
    del "%TEMP_ENV_PATH%"
    exit /b 1
)
echo Create collection test passed.

:: -------------------------------
:: Running Upload Image Test...
:: -------------------------------
echo Running Upload Image Test...
call newman run "%COLLECTION_PATH%" ^
    --environment "%TEMP_ENV_PATH%" ^
    --folder "upload image" ^
    --reporters cli,htmlextra ^
    --reporter-htmlextra-export "%REPORT_PATH%\upload_image_results_%TIMESTAMP%.html" ^
    --export-environment "%TEMP_ENV_PATH%"
if %ERRORLEVEL% neq 0 (
    echo Upload image test failed.
    del "%TEMP_ENV_PATH%"
    exit /b 1
)
echo Upload image passed.

:: Display environment variables after Upload Image Test
echo Displaying environment variables after Upload Image Test:
type "%TEMP_ENV_PATH%"

:: -------------------------------
:: Running 'all images in a collection' Test...
:: -------------------------------
echo Running 'all images in a collection' Test...
call newman run "%COLLECTION_PATH%" ^
    --environment "%TEMP_ENV_PATH%" ^
    --folder "all images in a collection" ^
    --reporters cli,htmlextra ^
    --reporter-htmlextra-export "%REPORT_PATH%\all_images_in_collection_results_%TIMESTAMP%.html" ^
    --export-environment "%TEMP_ENV_PATH%"
if %ERRORLEVEL% neq 0 (
    echo 'all images in a collection' test failed.
    del "%TEMP_ENV_PATH%"
    exit /b 1
)
echo 'all images in a collection' test passed.

:: -------------------------------
:: Running 'update image metadata' Test...
:: -------------------------------
echo Running 'update image metadata' Test...
call newman run "%COLLECTION_PATH%" ^
    --environment "%TEMP_ENV_PATH%" ^
    --folder "update image metadata" ^
    --reporters cli,htmlextra ^
    --reporter-htmlextra-export "%REPORT_PATH%\update_image_metadata_results_%TIMESTAMP%.html" ^
    --export-environment "%TEMP_ENV_PATH%"
if %ERRORLEVEL% neq 0 (
    echo 'update image metadata' test failed.
    del "%TEMP_ENV_PATH%"
    exit /b 1
)
echo 'update image metadata' test passed.

:: -------------------------------
:: Running Harbinger Login Test...
:: -------------------------------
echo Running Harbinger Login Test...
call newman run "%COLLECTION_PATH%" ^
    --iteration-data "%LOGIN_HARBINGER_DATA_PATH%" ^
    --environment "%TEMP_ENV_PATH%" ^
    --folder "Login" ^
    --reporters cli,htmlextra ^
    --reporter-htmlextra-export "%REPORT_PATH%\login_harbinger_results_%TIMESTAMP%.html" ^
    --export-environment "%TEMP_ENV_PATH%"
if %ERRORLEVEL% neq 0 (
    echo Harbinger login failed.
    del "%TEMP_ENV_PATH%"
    exit /b 1
)
echo Harbinger login passed.

:: -------------------------------
:: Running 'archive image' Test...
:: -------------------------------
echo Running 'archive image' Test...
call newman run "%COLLECTION_PATH%" ^
    --environment "%TEMP_ENV_PATH%" ^
    --folder "archive image" ^
    --reporters cli,htmlextra ^
    --reporter-htmlextra-export "%REPORT_PATH%\archive_image_results_%TIMESTAMP%.html" ^
    --export-environment "%TEMP_ENV_PATH%"
if %ERRORLEVEL% neq 0 (
    echo 'archive image' test failed.
    del "%TEMP_ENV_path%"
    exit /b 1
)
echo 'archive image' test passed.

:: -------------------------------
:: Running 'restore image' Test...
:: -------------------------------
echo Running 'restore image' Test...
call newman run "%COLLECTION_PATH%" ^
    --environment "%TEMP_ENV_PATH%" ^
    --folder "restore image" ^
    --reporters cli,htmlextra ^
    --reporter-htmlextra-export "%REPORT_PATH%\restore_image_results_%TIMESTAMP%.html" ^
    --export-environment "%TEMP_ENV_PATH%"
if %ERRORLEVEL% neq 0 (
    echo 'restore image' test failed.
    del "%TEMP_ENV_PATH%"
    exit /b 1
)
echo 'restore image' test passed.

:: -------------------------------
:: Running 'Delete Image' Test...
:: -------------------------------
echo Running 'Delete Image' Test...
call newman run "%COLLECTION_PATH%" ^
    --environment "%TEMP_ENV_PATH%" ^
    --folder "Delete Image" ^
    --reporters cli,htmlextra ^
    --reporter-htmlextra-export "%REPORT_PATH%\delete_image_results_%TIMESTAMP%.html" ^
    --export-environment "%TEMP_ENV_PATH%"
if %ERRORLEVEL% neq 0 (
    echo 'Delete Image' test failed.
    del "%TEMP_ENV_PATH%"
    exit /b 1
)
echo 'Delete Image' test passed.

:: Clean up temporary environment file
del "%TEMP_ENV_PATH%"

echo All tests completed successfully.

endlocal
