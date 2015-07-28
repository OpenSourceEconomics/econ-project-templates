@echo off
:: set the environment name to be the current folder
for %%A in ("%~f0\..") do set "env_name=%%~nxA" > nul

:: try to activate the environment
call activate %env_name%

set ret = %ERRORLEVEL% > nul


if ret == 1 goto :create
if %1 == "create" goto :create
if %1 == "install" goto :create



:: if it can't be activated, create it
:create
call conda create -n %env_name% --file conda_versions.txt
if exist requirements.txt (
    call activate %env_name%
    call pip install -r requirements.txt
    )
call activate %env_name%


:: if we pass create or install, do the same
::if %1 == "create" (
::    call conda create -n %env_name% --file conda_versions.txt
::    if exist requirements.txt (
::        call activate %env_name%
::        call pip install -r requirements.txt
::        )
::    call activate %env_name%
::    )::

::if %1 == "install" (
::    call conda create -n %env_name% --file conda_versions.txt
::    if exist requirements.txt (
::        call activate %env_name%
::        call pip install -r requirements.txt
::        )
::    call activate %env_name%
::    )

if %1 == "update" (
    call conda update --all
    if exist requirements.txt (
        call activate %env_name%
        :: this should update all pip packages
        for /F "delims===" %i in ('pip freeze -l') do pip install -U %i
        )
    call activate %env_name%
    call picky --update
    )

set ret = %ERRORLEVEL% > nul

if NOT ret == 1 (
    call activate %env_name%
    )

call picky