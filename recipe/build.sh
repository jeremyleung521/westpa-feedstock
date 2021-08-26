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
. ${CONDA_PREFIX}/${PKG_NAME}-${PKG_VERSION}/westpa.sh
EOC

cat << EOD >> ${CONDA_PREFIX}/etc/conda/deactivate.d/env_vars.sh
#!/usr/bin/env bash
unset WEST_ROOT
unset WEST_BIN
unset WEST_PYTHON
export PATH=${PATH#${CONDA_PREFIX}/${PKG_NAME}-${PKG_VERSION}/bin:}
EOD

# Clean up of previously set codes in activate.d
sed -i 's,'". ${PREFIX}/westpa-2020.03/westpa.sh"',,' ${PREFIX}/etc/conda/activate.d/env_vars.sh
sed -i 's,'". ${PREFIX}/westpa-2020.02/westpa.sh"',,' ${PREFIX}/etc/conda/activate.d/env_vars.sh
sed -i 's,'". ${PREFIX}/westpa-2020.01/westpa.sh"',,' ${PREFIX}/etc/conda/activate.d/env_vars.sh
