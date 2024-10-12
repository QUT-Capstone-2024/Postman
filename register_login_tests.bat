@echo off
set COLLECTION_PATH=C:\Users\SLHan\OneDrive\Desktop\Capstone\Postman\Collections\Register_Login.postman_collection.json
set REGISTER_DATA_PATH=C:\Users\SLHan\OneDrive\Desktop\Capstone\Postman\Data\register.json
set LOGIN_DATA_PATH=C:\Users\SLHan\OneDrive\Desktop\Capstone\Postman\Data\login.json
set ENV_PATH=C:\Users\SLHan\OneDrive\Desktop\Capstone\Postman\Environments\env.postman_environment.json
set REPORT_PATH=C:\Users\SLHan\OneDrive\Desktop\Capstone\Postman\newman-report
set TIMESTAMP=%DATE:~10,4%%DATE:~4,2%%DATE:~7,2%_%TIME:~0,2%%TIME:~3,2%%TIME:~6,2%

:: Create report directory if it doesn't exist
if not exist "%REPORT_PATH%" (
    mkdir "%REPORT_PATH%"
)

:: Run Newman command for registration
newman run "%COLLECTION_PATH%" ^
--iteration-data "%REGISTER_DATA_PATH%" ^
--environment "%ENV_PATH%" ^
--reporters cli,junit ^
--reporter-junit-export "%REPORT_PATH%\register_results_%TIMESTAMP%.xml"

if %ERRORLEVEL% equ 0 (
    echo Register tests passed successfully.
) else (
    echo Register tests failed. Check the report at %REPORT_PATH%\register_results_%TIMESTAMP%.xml
    exit /b 1
)

:: Run Newman command for login
newman run "%COLLECTION_PATH%" ^
--iteration-data "%LOGIN_DATA_PATH%" ^
--environment "%ENV_PATH%" ^
--reporters cli,junit ^
--reporter-junit-export "%REPORT_PATH%\login_results_%TIMESTAMP%.xml"

if %ERRORLEVEL% equ 0 (
    echo Login tests passed successfully.
) else (
    echo Login tests failed. Check the report at %REPORT_PATH%\login_results_%TIMESTAMP%.xml
    exit /b 1
)
