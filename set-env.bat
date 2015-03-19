REM You must use the "force" option when creating a conda environment with this script

call python .env/create-or-modify-env.py %*

for %%A in ("%~f0\..") do set "env_name=%%~nxA"

call activate %env_name%

call .env\workaround.bat

del ".env\workaround.bat"