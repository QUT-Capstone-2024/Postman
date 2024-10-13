@echo off
setlocal enabledelayedexpansion

:: Define base paths
set BASE_PATH=C:\Users\SLHan\OneDrive\Desktop\Capstone\Postman
set COLLECTION_PATH=%BASE_PATH%\Collections\Properties.postman_collection.json
set ENV_PATH=%BASE_PATH%\Environments\properties.postman_environment.json
set TEMP_ENV_PATH=%BASE_PATH%\Environments\temp_env.json
set REPORT_PATH=%BASE_PATH%\newman-report

:: Data files
set LOGIN_USER_DATA_PATH=%BASE_PATH%\Data\Properties\login_user.json
set LOGIN_ADMIN_DATA_PATH=%BASE_PATH%\Data\Properties\login_admin.json
set LOGIN_HARBINGER_DATA_PATH=%BASE_PATH%\Data\Properties\login_harbinger.json

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

:: Running User Login Test...
echo Running User Login Test...
call newman run "%COLLECTION_PATH%" ^
    --iteration-data "%LOGIN_USER_DATA_PATH%" ^
    --environment "%TEMP_ENV_PATH%" ^
    --folder "Login" ^
    --reporters cli,junit ^
    --reporter-junit-export "%REPORT_PATH%\login_user_results_%TIMESTAMP%.xml" ^
    --export-environment "%TEMP_ENV_PATH%"
if %ERRORLEVEL% neq 0 (
    echo User login failed.
    del "%TEMP_ENV_PATH%"
    exit /b 1
)
echo User login passed.

:: Running Create Collection Test...
echo Running Create Collection Test...
call newman run "%COLLECTION_PATH%" ^
    --environment "%TEMP_ENV_PATH%" ^
    --folder "create a collection" ^
    --reporters cli,junit ^
    --reporter-junit-export "%REPORT_PATH%\create_collection_results_%TIMESTAMP%.xml" ^
    --export-environment "%TEMP_ENV_PATH%"
if %ERRORLEVEL% neq 0 (
    echo Create collection test failed.
    del "%TEMP_ENV_PATH%"
    exit /b 1
)
echo Create collection test passed.

:: Running Get Collections Test...
echo Running Get Collections Test...
call newman run "%COLLECTION_PATH%" ^
    --environment "%TEMP_ENV_PATH%" ^
    --folder "all collections <id>" ^
    --reporters cli,junit ^
    --reporter-junit-export "%REPORT_PATH%\get_collections_results_%TIMESTAMP%.xml" ^
    --export-environment "%TEMP_ENV_PATH%"
if %ERRORLEVEL% neq 0 (
    echo Get collections test failed.
    del "%TEMP_ENV_PATH%"
    exit /b 1
)
echo Get collections test passed.

:: Running Update Collection Test...
echo Running Update Collection Test...
call newman run "%COLLECTION_PATH%" ^
    --environment "%TEMP_ENV_PATH%" ^
    --folder "update a collection" ^
    --reporters cli,junit ^
    --reporter-junit-export "%REPORT_PATH%\update_collection_results_%TIMESTAMP%.xml" ^
    --export-environment "%TEMP_ENV_PATH%"
if %ERRORLEVEL% neq 0 (
    echo Update collection test failed.
    del "%TEMP_ENV_PATH%"
    exit /b 1
)
echo Update collection test passed.

:: Running Admin Login Test...
echo Running Admin Login Test...
call newman run "%COLLECTION_PATH%" ^
    --iteration-data "%LOGIN_ADMIN_DATA_PATH%" ^
    --environment "%TEMP_ENV_PATH%" ^
    --folder "Login(Admin)" ^
    --reporters cli,junit ^
    --reporter-junit-export "%REPORT_PATH%\login_admin_results_%TIMESTAMP%.xml" ^
    --export-environment "%TEMP_ENV_PATH%"
if %ERRORLEVEL% neq 0 (
    echo Admin login failed.
    del "%TEMP_ENV_PATH%"
    exit /b 1
)
echo Admin login passed.

:: Running Archive Collection Test...
echo Running Archive Collection Test...
call newman run "%COLLECTION_PATH%" ^
    --environment "%TEMP_ENV_PATH%" ^
    --folder "archive collection <id>(Admin)" ^
    --reporters cli,junit ^
    --reporter-junit-export "%REPORT_PATH%\archive_collection_results_%TIMESTAMP%.xml" ^
    --export-environment "%TEMP_ENV_PATH%"
if %ERRORLEVEL% neq 0 (
    echo Archive collection test failed.
    del "%TEMP_ENV_PATH%"
    exit /b 1
)
echo Archive collection test passed.

:: Running Restore Collection Test...
echo Running Restore Collection Test...
call newman run "%COLLECTION_PATH%" ^
    --environment "%TEMP_ENV_PATH%" ^
    --folder "restore a collection <id>(Admin)" ^
    --reporters cli,junit ^
    --reporter-junit-export "%REPORT_PATH%\restore_collection_results_%TIMESTAMP%.xml" ^
    --export-environment "%TEMP_ENV_PATH%"
if %ERRORLEVEL% neq 0 (
    echo Restore collection test failed.
    del "%TEMP_ENV_PATH%"
    exit /b 1
)
echo Restore collection test passed.

:: Running Harbinger Login Test...
echo Running Harbinger Login Test...
call newman run "%COLLECTION_PATH%" ^
    --iteration-data "%LOGIN_HARBINGER_DATA_PATH%" ^
    --environment "%TEMP_ENV_PATH%" ^
    --folder "Login(Harbinger)" ^
    --reporters cli,junit ^
    --reporter-junit-export "%REPORT_PATH%\login_harbinger_results_%TIMESTAMP%.xml" ^
    --export-environment "%TEMP_ENV_PATH%"
if %ERRORLEVEL% neq 0 (
    echo Harbinger login failed.
    del "%TEMP_ENV_PATH%"
    exit /b 1
)
echo Harbinger login passed.

:: Running Delete Collection Test...
echo Running Delete Collection Test...
call newman run "%COLLECTION_PATH%" ^
    --environment "%TEMP_ENV_PATH%" ^
    --folder "collection <id>(Harbinger)" ^
    --reporters cli,junit ^
    --reporter-junit-export "%REPORT_PATH%\delete_collection_results_%TIMESTAMP%.xml" ^
    --export-environment "%TEMP_ENV_PATH%"
if %ERRORLEVEL% neq 0 (
    echo Delete collection test failed.
    del "%TEMP_ENV_PATH%"
    exit /b 1
)
echo Delete collection test passed.

:: Clean up temporary environment file
del "%TEMP_ENV_PATH%"

echo All tests completed successfully.

endlocal
