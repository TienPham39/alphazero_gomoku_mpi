@echo off
setlocal

set "VCXSRV_EXE=C:\Program Files\VcXsrv\vcxsrv.exe"
if not exist "%VCXSRV_EXE%" (
  echo [ERROR] VcXsrv not found at "%VCXSRV_EXE%"
  echo Install VcXsrv first, then rerun this script.
  exit /b 1
)

echo Restarting VcXsrv on display :0...
taskkill /IM vcxsrv.exe /F >NUL 2>NUL
start "" "%VCXSRV_EXE%" :0 -multiwindow -clipboard -wgl -ac -listen tcp
timeout /t 2 /nobreak >NUL

echo Starting Gomoku GUI in Docker...
docker compose run --rm train python -u human_play.py

endlocal
