@echo off
call python .env/create_modify_env.py %*

set ret = %ERRORLEVEL% > nul
if NOT ret == 1 (
    for %%A in ("%~f0\..") do set "env_name=%%~nxA" > nul
    if exist .env\workaround.bat (
        call .env\workaround.bat
        del .env\workaround.bat
)
  call activate %env_name%
  )
