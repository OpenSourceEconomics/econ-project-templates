#!/bin/bash
# You can make this executable with 'chmod u+x set-env.sh'

# Define usage/help command
usage="`echo $'\n> '`$(basename "$0") [help] [arguments] -- This script activates present anaconda environment. By supplying
one of more of the arguments below you can also create a environment if none exists and install required
packages.

where arguments can be:
    help, -h      Show this help text
    create        Create a new miniconda environment with the current foldername
    install       Install the packages specified in .env/specification.json. Also run this after updating
                  the specifications file
    update        Update previously installed packages"



# Name of the current directory (which is also the env name)
env_name=${PWD##*/}

# Activate the conda environment
source activate $env_name &> /dev/null

# Get return code of 'source activate ...'
OUT=$?

# Now implement the following structure:

# empty args  -> activate if env, else ask if create and install should be run
# create      -> 'env already exists' if env, else create
# install     -> install from specs if env, write list of installed pkgs, else ask if create should be run
# update      -> update if list of installed pkgs exists
#                   else: if env: 'install needs to be run first, run install?'
#                         if not env: 'no env: run create? also run install?'

# First handle the case with empty arguments
if [ $# -eq 0 ]; then

    # Check return code of activate, i.e. if the environment exists
    if [ $OUT -eq 0 ];then
        echo "Environment successfully activated! Run 'source deactivate' to deactivate it."
        # Create environment and install/update packages
        # python .env/create-or-modify-env.py $@

        # Alias for easier access to Waf.
        alias waf="python waf.py"

        # Set the default Waf configuration to 'fake'.
        export WAFLOCK=.lock-wafbld

    # If activate does not return 0, handle create and and install
    else
        read -q "answer?Environment does not exist. Do you want to create it? (y/n) `echo $'\n> '`"
        case ${answer:0:1} in
            y|Y )
                read -q "install?Do you also want to install the specified packages? (y/n) `echo $'\n> '`"
                case ${install:0:1} in
                    y|Y )
                        python .env/create-or-modify-env.py create install
                    ;;
                    * )
                        python .env/create-or-modify-env.py create
                    ;;
                esac
            source activate $env_name
            ;;
            * )
                return 1
            ;;
        esac

    # end-if for activate return code
    fi

# Now handle the case where arguments are supplied
else
    case $1 in
        '-h' | 'help' )
              echo $usage
              return 0
        ;;
    esac
    # If activate worked environment should exist
    if [ $OUT -eq 0 ];then
        case $1 in
            'activate' )
                echo 'Activating environment..'
            ;;
            'create' )
                echo 'Environment already exists, activating..'
            ;;
            # 'install' )
            #     echo 'Install listed packages and write to list' #TODO in python
            #     ;;
            * )
               python .env/create-or-modify-env.py $@
            ;;
        esac

    # Handle the case where the environment could not be activated
    else
        case $1 in
            'activate' | 'install' | 'update' )
                read -q "answer?Environment does not exist. Do you want to create it? (y/n) `echo $'\n> '`"
                case ${answer:0:1} in
                    y|Y )
                        read -q "install?Do you also want to install the specified packages? (y/n) `echo $'\n> '`"
                        case ${install:0:1} in
                            y|Y )
                                python .env/create-or-modify-env.py create install
                            ;;
                            * )
                                python .env/create-or-modify-env.py create
                            ;;
                        esac
                    ;;
                    * )
                        return 1
                    ;;
                esac
            ;;
            # Else pass arguments to python
            * )
               python .env/create-or-modify-env.py $@
            ;;
        esac
    fi
# end-if for arguments
fi