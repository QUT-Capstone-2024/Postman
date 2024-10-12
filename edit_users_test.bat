@echo off
setlocal enabledelayedexpansion

:: Define base paths
set BASE_PATH=C:\Users\SLHan\OneDrive\Desktop\Capstone\Postman
set COLLECTION_PATH=%BASE_PATH%\Collections\Edit_Users.postman_collection.json
set ENV_PATH=%BASE_PATH%\Environments\edit_users.postman_environment.json
set TEMP_ENV_PATH=%BASE_PATH%\Environments\temp_env.json
set LOGIN_USER_DATA_PATH=%BASE_PATH%\Data\Edit_Users\login_user.json
set LOGIN_ADMIN_DATA_PATH=%BASE_PATH%\Data\Edit_Users\login_admin.json
set LOGIN_HARBINGER_DATA_PATH=%BASE_PATH%\Data\Edit_Users\login_harbinger.json
set REPORT_PATH=%BASE_PATH%\newman-report

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

:: Running Login User Test...
echo Running Login User Test...
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

:: Running Update User Test...
echo Running Update User Test...
call newman run "%COLLECTION_PATH%" ^
    --environment "%TEMP_ENV_PATH%" ^
    --folder "update user {id}" ^
    --reporters cli,junit ^
    --reporter-junit-export "%REPORT_PATH%\update_user_results_%TIMESTAMP%.xml" ^
    --export-environment "%TEMP_ENV_PATH%"
if %ERRORLEVEL% neq 0 (
    echo Update user test failed.
    del "%TEMP_ENV_PATH%"
    exit /b 1
)
echo Update user test passed.

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

:: Running All Users Test...
echo Running All Users Test...
call newman run "%COLLECTION_PATH%" ^
    --environment "%TEMP_ENV_PATH%" ^
    --folder "All users (CL_ADMIN only)" ^
    --reporters cli,junit ^
    --reporter-junit-export "%REPORT_PATH%\all_users_results_%TIMESTAMP%.xml" ^
    --export-environment "%TEMP_ENV_PATH%"
if %ERRORLEVEL% neq 0 (
    echo All users test failed.
    del "%TEMP_ENV_PATH%"
    exit /b 1
)
echo All users test passed.

:: Running All Active Users Test...
echo Running All Active Users Test...
call newman run "%COLLECTION_PATH%" ^
    --environment "%TEMP_ENV_PATH%" ^
    --folder "All active users (CL_ADMIN only)" ^
    --reporters cli,junit ^
    --reporter-junit-export "%REPORT_PATH%\active_users_results_%TIMESTAMP%.xml" ^
    --export-environment "%TEMP_ENV_PATH%"
if %ERRORLEVEL% neq 0 (
    echo All active users test failed.
    del "%TEMP_ENV_PATH%"
    exit /b 1
)
echo All active users test passed.

:: Running All Archived Users Test...
echo Running All Archived Users Test...
call newman run "%COLLECTION_PATH%" ^
    --environment "%TEMP_ENV_PATH%" ^
    --folder "All archived users (CL_ADMIN only)" ^
    --reporters cli,junit ^
    --reporter-junit-export "%REPORT_PATH%\archived_users_results_%TIMESTAMP%.xml" ^
    --export-environment "%TEMP_ENV_PATH%"
if %ERRORLEVEL% neq 0 (
    echo All archived users test failed.
    del "%TEMP_ENV_PATH%"
    exit /b 1
)
echo All archived users test passed.

:: Running Archive User Test...
echo Running Archive User Test...
call newman run "%COLLECTION_PATH%" ^
    --environment "%TEMP_ENV_PATH%" ^
    --folder "Archive user {id} (CL_ADMIN only)" ^
    --reporters cli,junit ^
    --reporter-junit-export "%REPORT_PATH%\archive_user_results_%TIMESTAMP%.xml" ^
    --export-environment "%TEMP_ENV_PATH%"
if %ERRORLEVEL% neq 0 (
    echo Archive user test failed.
    del "%TEMP_ENV_PATH%"
    exit /b 1
)
echo Archive user test passed.

:: Running Restore User Test...
echo Running Restore User Test...
call newman run "%COLLECTION_PATH%" ^
    --environment "%TEMP_ENV_PATH%" ^
    --folder "Restore user {id} (CL_ADMIN only)" ^
    --reporters cli,junit ^
    --reporter-junit-export "%REPORT_PATH%\restore_user_results_%TIMESTAMP%.xml" ^
    --export-environment "%TEMP_ENV_PATH%"
if %ERRORLEVEL% neq 0 (
    echo Restore user test failed.
    del "%TEMP_ENV_PATH%"
    exit /b 1
)
echo Restore user test passed.

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

:: Running Delete User Test...
echo Running Delete User Test...
call newman run "%COLLECTION_PATH%" ^
    --environment "%TEMP_ENV_PATH%" ^
    --folder "User {id} (HARBINGER only)" ^
    --reporters cli,junit ^
    --reporter-junit-export "%REPORT_PATH%\delete_user_results_%TIMESTAMP%.xml" ^
    --export-environment "%TEMP_ENV_PATH%"
if %ERRORLEVEL% neq 0 (
    echo Delete user test failed.
    del "%TEMP_ENV_PATH%"
    exit /b 1
)
echo Delete user test passed.

:: Clean up temporary environment file
del "%TEMP_ENV_PATH%"

echo All tests completed successfully.

endlocal
