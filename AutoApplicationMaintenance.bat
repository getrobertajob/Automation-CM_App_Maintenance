REM Restart Script for Custom Server Side App
REM By Robert Lute 20181006
REM Stops App Services, Kills hung processes, archives logs to oldlogs directory, and starts App Services
REM Place restart.bat and 7za.exe in the APP bin directory


REM ****Format Date/Time Stamp****
  SET DATESTAMP=%DATE:~10,4%%DATE:~4,2%%DATE:~7,2%
  SET TIMESTAMP=%TIME:~0,2%%TIME:~3,2%
  SET TIMESTAMP=%TIMESTAMP: =0%
  SET DATEANDTIME=%DATESTAMP%_%TIMESTAMP%

REM ****Set Customer Name to vaiable****
  SET CustName=ClientsCompanyName

REM ****set patch to APP folder to variable****
  SET APP_DIR=E:\AppMainFolder

REM ****set quantity of logs to keep to variable****
  SET KEEP_LOGS=30

REM ****Enable Batch Service to script****
REM ****DELETE REM FROM THE BELOW LINE IF THERE IS A BATCH SERVICE AND SPECIFY SERVICE NAME****
REM SET BATCH_SERVICE=APP_Batchfile

REM ****Change current location to bin folder****
cd %APP_DIR%\bin

REM ****Stops Services****
IF DEFINED BATCH_SERVICE (net stop %BATCH_SERVICE%)
start /B cmd /C %APP_DIR%\bin\APP_svc.bat APP stop

REM ****Waits for services & kills them if still running****
timeout /t 120
cmd /C taskkill /F /T /FI "SERVICES eq APP_*"

REM ****Change to Windows Temp on C Drive****
cd /D C:
cd C:\Windows\Temp

REM ****Delete DataEngine folders****
REM ****These are temp folders/files left behind when the App makes reports ****
for /d %%x in (DataEngine_*) do rd /s /q "%%x"

REM ****Change to D Drive****
cd /D %APP_DIR%

REM ****Deletes temp folders****
rd /s /q "%APP_DIR%\jboss\server\apollo\tmp"
rd /s /q "%APP_DIR%\jboss\server\apollo\work"
rd /s /q "%APP_DIR%\jboss\server\apollo\log"
rd /s /q "%APP_DIR%\jboss\server\apollo\data"

REM ****Makes oldlogs folder****
mkdir %APP_DIR%\oldlogs

REM ****Zips up logs and moves to oldlogs folder****
%APP_DIR%\bin\7za a -tzip %APP_DIR%\oldlogs\%CUSTNAME%_%DATEANDTIME%.zip %APP_DIR%\log\*.log*

REM ****Deletes current logs****
del /q %APP_DIR%\log\*.log*

REM ****Deletes logs past the "KEEP_LOGS" quantity****
forfiles /p "%APP_DIR%\oldlogs" /s /m *.zip /d -%KEEP_LOGS% /c "cmd /c del @file"

REM ****Starts services****
cmd /C %APP_DIR%\bin\APP_svc.bat APP start
IF DEFINED BATCH_SERVICE (timeout /t 120 & net start %BATCH_SERVICE%)