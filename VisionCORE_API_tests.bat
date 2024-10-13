@echo off
setlocal enabledelayedexpansion

:: ============================================
:: Batch Script to Run All Test Suites Sequentially
:: ============================================

:: Define the base path where all test scripts are located
set BASE_PATH=C:\Users\SLHan\OneDrive\Desktop\Capstone\Postman\

:: Define the report path
set REPORT_PATH=%BASE_PATH%\newman-report

:: Define all test batch scripts (without quotes)
set TEST1=register_login_tests.bat
set TEST2=profile_access_tests.bat
set TEST3=edit_users_test.bat
set TEST4=properties_tests.bat
set TEST5=images_tests.bat

:: Generate TIMESTAMP in the format YYYYMMDD_HHMMSS
for /f "tokens=1-3 delims=-/ " %%a in ("%date%") do (
    set "YYYY=%%c"
    set "MM=%%a"
    set "DD=%%b"
)
for /f "tokens=1-3 delims=:.," %%a in ("%time%") do (
    set "HH=%%a"
    set "Min=%%b"
    set "Sec=%%c"
)
:: Remove leading spaces in HH
set "HH=!HH: =0!"
set "TIMESTAMP=!YYYY!!MM!!DD!_!HH!!Min!!Sec!"

:: Create report directory if it doesn't exist
if not exist "%REPORT_PATH%" (
    mkdir "%REPORT_PATH%"
)

:: -------------------------------
:: Run each test suite in order
:: -------------------------------

:: 1. Register and Login Tests
call  %TEST1%

:: 2. Profile Access Tests
call  %TEST2%

:: 3. Edit Users Test
call  %TEST3%

:: 4. Properties Tests
call  %TEST4%

:: 5. Images Tests
call  %TEST5%

:: ============================================
:: All Tests Passed
:: ============================================
echo.
echo ============================================
echo All test suites executed successfully!
echo ============================================
echo.

:: Optional: Pause the script to view the final message
:: Remove the following line if you do not want the script to pause
pause

:: End of Script
endlocal
exit /b 0
