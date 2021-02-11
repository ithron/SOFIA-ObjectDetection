#!/usr/bin/env bash

set -uo pipefail

SOFIA_DOCKER_IMAGE="${SOFIA_DOCKER_IMAGE:=sreinhold/sofia-object-detection}"
SOFIA_NAME="${SOFIA_NAME:=}"
SOFIA_TB_PORT="${SOFIA_TB_PORT:=8080}"
SOFIA_MODEL_DIR="${SOFIA_MODEL_DIR:=$(pwd)/data}"

DOCKER_EXE=`which docker`
COMMON_DOCKER_ARGS="--user `id -u`:`id -g` -p ${SOFIA_TB_PORT}:8080"

if [[ -n "${SOFIA_NAME}" ]]
then
  COMMON_DOCKER_ARGS="${COMMON_DOCKER_ARGS} --name=${SOFIA_NAME}"
fi

${DOCKER_EXE} run \
  ${COMMON_DOCKER_ARGS} \
  -v ${SOFIA_MODEL_DIR}:/model \
  -it \
  --rm \
  ${SOFIA_DOCKER_IMAGE} \
  /home/devel/tb.sh
