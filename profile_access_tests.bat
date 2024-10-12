@echo off
setlocal enabledelayedexpansion

:: Define base paths
set BASE_PATH=C:\Users\SLHan\OneDrive\Desktop\Capstone\Postman
set COLLECTION_PATH=%BASE_PATH%\Collections\Profile_Access.postman_collection.json
set ENV_PATH=%BASE_PATH%\Environments\id_token_store.postman_environment.json
set TEMP_USER_ENV_PATH=%BASE_PATH%\Environments\temp_user_env.json
set TEMP_ADMIN_ENV_PATH=%BASE_PATH%\Environments\temp_admin_env.json
set LOGIN_USER_DATA_PATH=%BASE_PATH%\Data\Profile\login_user.json
set LOGIN_ADMIN_DATA_PATH=%BASE_PATH%\Data\Profile\login_admin.json
set REPORT_PATH=%BASE_PATH%\newman-report

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

:: Copy the original environment file to temporary user and admin environment files
copy "%ENV_PATH%" "%TEMP_USER_ENV_PATH%" /Y >nul
copy "%ENV_PATH%" "%TEMP_ADMIN_ENV_PATH%" /Y >nul

:: Running Login User Test...
echo Running Login User Test...
call newman run "%COLLECTION_PATH%" ^
    --iteration-data "%LOGIN_USER_DATA_PATH%" ^
    --environment "%TEMP_USER_ENV_PATH%" ^
    --folder "Login" ^
    --reporters cli,junit ^
    --reporter-junit-export "%REPORT_PATH%\login_user_results_%TIMESTAMP%.xml" ^
    --export-environment "%TEMP_USER_ENV_PATH%"
if %ERRORLEVEL% neq 0 (
    echo User login failed.
    del "%TEMP_USER_ENV_PATH%"
    exit /b 1
)
echo User login passed.

:: Running Own Profile Test...
echo Running Own Profile Test...
call newman run "%COLLECTION_PATH%" ^
    --environment "%TEMP_USER_ENV_PATH%" ^
    --folder "Own profile" ^
    --reporters cli,junit ^
    --reporter-junit-export "%REPORT_PATH%\own_profile_results_%TIMESTAMP%.xml" ^
    --export-environment "%TEMP_USER_ENV_PATH%"
if %ERRORLEVEL% neq 0 (
    echo Own profile test failed.
    del "%TEMP_USER_ENV_PATH%"
    exit /b 1
)
echo Own profile test passed.

:: Running Different User Profile Test...
echo Running Different User Profile Test...
call newman run "%COLLECTION_PATH%" ^
    --environment "%TEMP_USER_ENV_PATH%" ^
    --folder "Another users profile" ^
    --reporters cli,junit ^
    --reporter-junit-export "%REPORT_PATH%\different_profile_results_%TIMESTAMP%.xml" ^
    --export-environment "%TEMP_USER_ENV_PATH%"
if %ERRORLEVEL% neq 0 (
    echo Different profile test failed.
    del "%TEMP_USER_ENV_PATH%"
    exit /b 1
)
echo Different profile test passed.

:: Running Admin Login Test...
echo Running Admin Login Test...
call newman run "%COLLECTION_PATH%" ^
    --iteration-data "%LOGIN_ADMIN_DATA_PATH%" ^
    --environment "%TEMP_ADMIN_ENV_PATH%" ^
    --folder "Login(Admin)" ^
    --reporters cli,junit ^
    --reporter-junit-export "%REPORT_PATH%\login_admin_results_%TIMESTAMP%.xml" ^
    --export-environment "%TEMP_ADMIN_ENV_PATH%"
if %ERRORLEVEL% neq 0 (
    echo Admin login failed.
    del "%TEMP_ADMIN_ENV_PATH%"
    exit /b 1
)
echo Admin login passed.

:: Running Admin Profile Test...
echo Running Admin Profile Test...
call newman run "%COLLECTION_PATH%" ^
    --environment "%TEMP_ADMIN_ENV_PATH%" ^
    --folder "Another users profile (admin)" ^
    --reporters cli,junit ^
    --reporter-junit-export "%REPORT_PATH%\admin_profile_results_%TIMESTAMP%.xml" ^
    --export-environment "%TEMP_ADMIN_ENV_PATH%"
if %ERRORLEVEL% neq 0 (
    echo Admin profile test failed.
    del "%TEMP_ADMIN_ENV_PATH%"
    exit /b 1
)
echo Admin profile test passed.

:: Clean up temporary environment files
del "%TEMP_USER_ENV_PATH%"
del "%TEMP_ADMIN_ENV_PATH%"

echo All tests completed successfully.

endlocal
