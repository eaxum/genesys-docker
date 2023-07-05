#!/bin/sh

export LC_ALL=C.UTF-8
export LANG=C.UTF-8

mkdir -p ${TEMPLATE_FOLDER} ${TMP_DIR}
chown -R eaxum:eaxum ${TEMPLATE_FOLDER} ${TMP_DIR}

echo "Current user: $(whoami)"

genesys upgrade-db
genesys init-data
