#!/usr/bin/env bash

set -e

SOFIA_DOCKER_IMAGE="${SOFIA_DOCKER_IMAGE:=sreinhold/sofia-object-detection}"

docker build -t ${SOFIA_DOCKER_IMAGE} --build-arg TARGET_UID=`id -u` --build-arg TARGET_GID=`id -g` ./
