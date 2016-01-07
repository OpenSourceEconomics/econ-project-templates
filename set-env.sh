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
    conda env create -n $env_name -f .environment.osx.yml
    if [ $? -ne 0 ]; then return; fi
    shift
fi

# update packages
if [[ $1 == "update" ]]; then
    conda env update --name=$env_name --file=.environment.osx.yml
    shift
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
