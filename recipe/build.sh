#!/bin/bash

set -x

./setup.sh
cp -r ${SRC_DIR} ${CONDA_PREFIX}/${PKG_NAME}-${PKG_VERSION}

cd "${CONDA_PREFIX}/${PKG_NAME}-${PKG_VERSION}"
echo "$(ls -la)"
WEST_PYTHON=$(which python3)
WEST_PYTHON=$WEST_PYTHON $WEST_PYTHON .westpa_gen.py
chmod +x westpa.sh

# Export WESTPA environment variables
mkdir -p ${CONDA_PREFIX}/etc/conda/{activate,deactivate}.d
touch ${CONDA_PREFIX}/etc/conda/{activate,deactivate}.d/env_vars.sh
cat << EOC >> ${CONDA_PREFIX}/etc/conda/activate.d/env_vars.sh
#!/usr/bin/env bash
##. \$(dirname \$(dirname \`which python3\`))/${PKG_NAME}-${PKG_VERSION}/westpa.sh
. ${CONDA_PREFIX}/${PKG_NAME}-${PKG_VERSION}/westpa.sh
EOC

cat << EOD >> ${CONDA_PREFIX}/etc/conda/deactivate.d/env_vars.sh
#!/usr/bin/env bash
unset WEST_ROOT
unset WEST_BIN
unset WEST_PYTHON
export PATH=${PATH#${CONDA_PREFIX}/${PKG_NAME}-${PKG_VERSION}/bin:}
EOD


