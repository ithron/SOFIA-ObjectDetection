#!/usr/bin/env bash

set -eux
set -o pipefail

cd models/research

# From the tensorflow/models/research/ directory
MODEL_DIR=/model
PIPELINE_CONFIG_PATH=${MODEL_DIR}/SOFIA.config
python object_detection/model_main_tf2.py \
    --pipeline_config_path=${PIPELINE_CONFIG_PATH} \
    --model_dir=${MODEL_DIR} \
    --alsologtostderr \
    --eval_training_data
