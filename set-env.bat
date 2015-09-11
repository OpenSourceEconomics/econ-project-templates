@echo off
:: set the environment name to be the current folder
FOR %%A in ("%~f0\..") do SET "env_name=%%~nxA" > nul

:: try to activate the environment
CALL activate %env_name%

:: get arguments FOR create & install


IF /i "%1" == "create" GOTO create
IF /i "%1" == "install" GOTO create
IF /i "%1" == "update" GOTO update
IF %ERRORLEVEL% GEQ 1 GOTO create

GOTO :EOF


:: if it can't be activated, create it
:create
CALL conda create -n %env_name% --file conda_versions.txt
:: don't CALL pip if conda runs into trouble
IF %ERRORLEVEL% GEQ 1 EXIT /B 2
:: CALL pip if we have pip requirements
IF exist requirements.txt (
    CALL activate %env_name%
    CALL pip install -r requirements.txt
    )
GOTO :EOF
    
:: handle update case here
:update
CALL conda update --all
IF exist requirements.txt (
    CALL activate %env_name%
    :: this should update all pip packages
    FOR /F "delims===" %%i in ('pip freeze -l') do pip install -U %%i
CALL activate %env_name%
CALL picky --update
)

CALL picky

GOTO :EOF