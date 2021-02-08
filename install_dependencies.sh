#!/usr/bin/env bash

set -eu
set -o pipefail

git submodule update --init

cd models/research
# Compile protos.
protoc object_detection/protos/*.proto --python_out=.

# Install TensorFlow Object Detection API.
cp object_detection/packages/tf2/setup.py .
python -m pip install --use-feature=2020-resolver .

# Test the installation.
python object_detection/builders/model_builder_tf2_test.py
