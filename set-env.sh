#!/bin/bash
# You can make this executable with 'chmod u+x set-env.sh'

python .env/create_modify_env.py $@

OUT=$?

env_name=${PWD##*/}

if [[ ! (OUT -eq 1) ]]; then
    source activate $env_name
fi
