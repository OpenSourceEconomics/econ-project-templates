#!/bin/bash
set -e

if [ -n "$READTHEDOCS_LANGUAGE" ] && [ -n "$READTHEDOCS_VERSION" ]; then
    export BASE_URL="/$READTHEDOCS_LANGUAGE/$READTHEDOCS_VERSION"
fi

jupyter book build --html
