#!/bin/bash
# You can make this executable with 'chmod u+x set-env.sh'

env_name=${PWD##*/}

# try to activate environment
source activate $env_name >> /dev/null 2>&1
# get return code of activation
OUT=$?

# create environment if it does not exist or create is supplied
# this install packages as well
if [[ ($OUT -eq 1)  || ($1 == "create")]]; then
    conda env create -n $env_name --file environment.yml
fi


# install packages
if [[ $1 == "install" ]]; then
    conda env create -n $env_name --file environment.yml
fi

# update packages
if [[ $1 == "update" ]]; then
    conda env update -n $env_name --file environment.yml
fi

# check the return code of operations
OUT=$?


if [[ ! ($OUT -eq 1) ]]; then
    source activate $env_name
fi

# pip install picky >> /dev/null

