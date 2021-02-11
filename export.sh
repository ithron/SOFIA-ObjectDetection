#!/usr/bin/env bash

set -eux
set -o pipefail

cd /home/devel/models/research

MODEL_DIR=/model
PIPELINE_CONFIG_PATH=/home/devel/pipeline.config

python object_detection/exporter_main_v2.py \
  --input_type image_tensor \
  --pipeline_config_path \
  ${PIPELINE_CONFIG_PATH} \
  --trained_checkpoint_dir ${MODEL_DIR} \
  --output_directory ${MODEL_DIR}/exported/SOFIA-ObjectDetection

