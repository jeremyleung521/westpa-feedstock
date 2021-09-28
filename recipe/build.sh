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
. ${PREFIX}/${PKG_NAME}-${PKG_VERSION}/westpa.sh
EOC

cat << EOD >> ${PREFIX}/etc/conda/deactivate.d/env_vars.sh
#!/usr/bin/env bash
export PATH=:\${PATH}: # Wrap with colon to prevent special case
export PATH=\${PATH//:\$WEST_BIN:} # Remove the Path
export PATH=\${PATH#:} # Remove start colon
export PATH=\${PATH%:} # Remove end colon
unset WEST_ROOT
unset WEST_BIN
unset WEST_PYTHON
EOD

# Clean up of previously set codes in activate.d
if [ -f ${PREFIX}/etc/conda/activate.d/env_vars.sh ]; then
    sed -i 's,'". ${PREFIX}/westpa-2020.03/westpa.sh"',,' ${PREFIX}/etc/conda/activate.d/env_vars.sh || :
    sed -i 's,'". ${PREFIX}/westpa-2020.02/westpa.sh"',,' ${PREFIX}/etc/conda/activate.d/env_vars.sh || :
    sed -i 's,'". ${PREFIX}/westpa-2020.01/westpa.sh"',,' ${PREFIX}/etc/conda/activate.d/env_vars.sh || :
fi
