#!/bin/bash

set -x

cp -r ${SRC_DIR} ${PREFIX}/${PKG_NAME}-${PKG_VERSION}
cd "${PREFIX}/${PKG_NAME}-${PKG_VERSION}"

python setup.py develop

# Remove Previous WESTPA environment variables
export PATH=:\${PATH}: # Wrap with colon to prevent special case
export PATH=\${PATH//:\$WEST_BIN:} # Remove the Path
export PATH=\${PATH#:} # Remove start colon
export PATH=\${PATH%:} # Remove end colon
unset WEST_ROOT
unset WEST_BIN
unset WEST_PYTHON

# Clean up of previously set codes in activate.d
if [ -f ${PREFIX}/etc/conda/activate.d/env_vars.sh ]; then
    sed -i 's,'". ${PREFIX}/westpa-2020.05/westpa.sh"',,' ${PREFIX}/etc/conda/activate.d/env_vars.sh || :
    sed -i 's,'". ${PREFIX}/westpa-2020.03/westpa.sh"',,' ${PREFIX}/etc/conda/activate.d/env_vars.sh || :
    sed -i 's,'". ${PREFIX}/westpa-2020.02/westpa.sh"',,' ${PREFIX}/etc/conda/activate.d/env_vars.sh || :
    sed -i 's,'". ${PREFIX}/westpa-2020.01/westpa.sh"',,' ${PREFIX}/etc/conda/activate.d/env_vars.sh || :
fi
