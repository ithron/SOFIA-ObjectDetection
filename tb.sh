#!/usr/bin/env bash

set -eux
set -o pipefail

cd /home/devel

MODEL_DIR=/model

tensorboard --logdir=${MODEL_DIR} --bind_all --port=8080

