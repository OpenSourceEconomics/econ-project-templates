#!/bin/bash

# get name of the environment by current folder
env_name=${PWD##*/}

# try to activate environment
source activate $env_name > /dev/null 2>&1
# get return code of activation
OUT=$?

# Add R channel
conda config --add channels r > /dev/null 2>&1

# create environment if it does not exist or create is supplied
# this install packages as well
if [[ ($OUT -eq 1)  || ($1 == "create") || ($1 == "install") ]]; then
    conda create -n $env_name --file conda_versions.txt
    if [ $? -ne 0 ]; then return; fi
    if [ -f requirements.txt ]; then
        source activate $env_name >> /dev/null 2>&1
        pip install -r requirements.txt
    fi
fi

# update packages
if [[ $1 == "update" ]]; then
    conda update --all
    if [ $? -ne 0 ]; then return; fi
    if [ -f requirements.txt ]; then
        # Update all pip packages
        source activate $env_name >> /dev/null 2>&1
        pip freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U
    fi
    # Update requirement files
    picky --update
fi

# check the return code of operations
OUT=$?


if [[ ! ($OUT -eq 1) ]]; then
    source activate $env_name
    # set alias for waf
    alias waf="python waf.py"

    # Set the default Waf configuration to 'bld'.
    export WAFLOCK=.lock-wafbld

    # Disable Cudasim
    export NUMBA_ENABLE_CUDASIM=0

    # Change the Waf configuration for debug mode (adjust as it fits your project).
    while [[ $# > 0 ]]
        do
            key="$1"
            case $key in
                -d|--debug-cuda)
                    export WAFLOCK=.lock-wafbld_debug_cuda
                    export NUMBA_ENABLE_CUDASIM=1
                    echo -e "\n\n\nUsing debug-cuda setting.\n\nSlooooooow, only use for testing.\n\n\n"
                    shift
                    ;;
                -c|--check-env-via-picky)
                    picky
                    ;;
                *)
                    echo "Unkown option: " $key
                    shift
                    ;;
            esac
        shift
    done

fi
