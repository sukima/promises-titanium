#!/bin/sh

# A simple spec runner for jasmine-node.
#
# It can be called from npm test. All options are send to jasmine-node
#
# To use this with npm add it to you package.json file. Example:
#     {
#       "name": "project",
#       "description": "",
#       "version": "0.0.0",
#       "devDependencies": {
#         "coffee-script": "latest",
#         "jasmine-node":  "latest",
#         "mockti":        "latest",
#         "proxyquire":    "latest"
#       },
#       "scripts": {
#         "test": "sh spec/spec_runner.sh"
#       }
#     }

OPTS="--coffee"

DIR=$(dirname $0)
DIR=$(cd "$DIR" && pwd)

if [ "$1" = "-v" ]; then
  silent=""
  shift
else
  silent="> /dev/null"
fi

specs_dir="${DIR}"
app_dir=$(cd "${DIR}/../Resources" && pwd)

if [ -d "${DIR}/../app" ]; then
  has_alloy="yes"
else
  has_alloy="no"
fi

if ! hash jsamine-node > /dev/null 2>&1; then
	JASMINE_NODE=$(cd "${DIR}/../node_modules/.bin" && pwd)
	JASMINE_NODE="${JASMINE_NODE}/jasmine-node"
	if [ ! -e "$JASMINE_NODE" ]; then
		echo "[ERROR] jasmine-node executable not found. Is it in your PATH? Or did you run 'npm install .'?" >&2
		exit -1
	fi
else
	JASMINE_NODE=jasmine-node
fi

if [ "$has_alloy" = "yes" ]; then
  if ! hash alloy > /dev/null 2>&1; then
    ALLOY=$(cd "${DIR}/../node_modules/.bin" && pwd)
    ALLOY="${ALLOY}/alloy"
    if [ ! -e "$ALLOY" ]; then
      echo "[ERROR] alloy executable not found. Is it in your PATH? Or did you run 'npm install .'?" >&2
      exit -1
    fi
  else
    ALLOY=alloy
  fi

  eval "${ALLOY} compile --config platform=ios $silent"
fi

export NODE_PATH="$app_dir"

eval "${JASMINE_NODE}" ${OPTS} --test-dir "${specs_dir}" $@
exit $?
