#!/usr/bin/env bash

set -uo pipefail

SOFIA_DOCKER_IMAGE="${SOFIA_DOCKER_IMAGE:=sreinhold/sofia-object-detection}"
SOFIA_NAME="${SOFIA_NAME:=}"

SOFIA_DATA_DIR="${SOFIA_DATA_DIR:=$(pwd)/data}"
SOFIA_MODEL_DIR="${SOFIA_MODEL_DIR:=$(pwd)/data}"

DOCKER_EXE=`which docker`
COMMON_DOCKER_ARGS="--user `id -u`:`id -g`"
MODEL_DIR=`pwd`/model
DATA_DIR=`pwd`/data

if [[ -n "${SOFIA_NAME}" ]]
then
  COMMON_DOCKER_ARGS="${COMMON_DOCKER_ARGS} --name=${SOFIA_NAME}"
fi

${DOCKER_EXE} run \
  ${COMMON_DOCKER_ARGS} \
  -v ${DATA_DIR}:/data \
  -v ${MODEL_DIR}:/model \
  -it \
  --rm \
  ${SOFIA_DOCKER_IMAGE} \
  /home/devel/export.sh
