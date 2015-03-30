#!/bin/sh
# You can make this executable with 'chmod u+x set-env.sh'

# Create environment and install/update packages
python .env/create-or-modify-env.py $@

# Alias for easier access to Waf.
alias waf="python waf.py"

# Set the default Waf configuration to 'fake'.
export WAFLOCK=.lock-wafbld

# Name of the current directory (which is also the env name)
env_name=${PWD##*/}

# Activate the conda environment
source activate $env_name
