@echo off
:: set the environment name to be the current folder
FOR %%A in ("%~f0\..") do SET "env_name=%%~nxA" > nul

:: try to activate the environment
CALL activate %env_name% > NUL

:: get arguments FOR create & install


IF /i "%1" == "create" GOTO create
IF /i "%1" == "install" GOTO create
IF /i "%1" == "update" GOTO update
IF /i "%1" == "check-env-via-picky" GOTO picky
IF %ERRORLEVEL% GEQ 1 GOTO create

GOTO :EOF


:: if it can't be activated, create it
:create
CALL conda env create -n %env_name% -f .environment.windows.yml
GOTO :EOF

:: handle update case here
:update
CALL conda env update --name=%env_name% --file=.environment.windows.yml
GOTO :EOF