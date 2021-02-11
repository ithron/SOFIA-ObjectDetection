#!/usr/bin/env bash

set -eux
set -o pipefail

cd /home/devel/models/research

# From the tensorflow/models/research/ directory
MODEL_DIR=/model
PIPELINE_CONFIG_PATH=/home/devel/pipeline.config
python object_detection/model_main_tf2.py \
    --pipeline_config_path=${PIPELINE_CONFIG_PATH} \
    --model_dir=${MODEL_DIR} \
    --alsologtostderr \
    --eval_training_data
