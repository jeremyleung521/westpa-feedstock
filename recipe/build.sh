#!/bin/bash

set -x

./setup.sh
cp -r ${SRC_DIR} ${PREFIX}/${PKG_NAME}-${PKG_VERSION}

cd "${PREFIX}/${PKG_NAME}-${PKG_VERSION}"
echo "$(ls -la)"
WEST_PYTHON=$(which python3)
WEST_PYTHON=$WEST_PYTHON $WEST_PYTHON .westpa_gen.py
chmod +x westpa.sh

# Export WESTPA environment variables
mkdir -p ${PREFIX}/etc/conda/{activate,deactivate}.d
touch ${PREFIX}/etc/conda/{activate,deactivate}.d/env_vars.sh
cat << EOC >> ${PREFIX}/etc/conda/activate.d/env_vars.sh
#!/usr/bin/env bash
##. \$(dirname \$(dirname \`which python3\`))/${PKG_NAME}-${PKG_VERSION}/westpa.sh
. ${PREFIX}/${PKG_NAME}-${PKG_VERSION}/westpa.sh
EOC
