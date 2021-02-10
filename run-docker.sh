#!/usr/bin/env bash


set -euo pipefail

DOCKER_IMAGE=sudd:5000/sre-sofia-object-detection
DOCKER_EXE=`which docker`
COMMON_DOCKER_ARGS="--user `id -u`:`id -g` -p 22333:22 -P"
NAME=sre-sofia-object-detection
MODEL_DIR=`pwd`/model
DATA_DIR=`pwd`/data

${DOCKER_EXE} run ${COMMON_DOCKER_ARGS} --gpus=all -v ${DATA_DIR}:/data -v ${MODEL_DIR}:/model -it --rm --name="${NAME}" ${DOCKER_IMAGE} $@

