#!/usr/bin/env bash

set -eux
set -o pipefail

cd models/research

# From the tensorflow/models/research/ directory
MODEL_DIR=/model
PIPELINE_CONFIG_PATH=/home/devel/pipeline.config
CHECKPOINT_DIR=${MODEL_DIR}
CUDA_VISIBLE_DEVICES="-1" python object_detection/model_main_tf2.py \
    --pipeline_config_path=${PIPELINE_CONFIG_PATH} \
    --model_dir=${MODEL_DIR} \
    --checkpoint_dir=${CHECKPOINT_DIR} \
    --alsologtostderr
