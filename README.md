# SOFIA Object Detection

This repository contains scripts to train an object/keypoint detection model on the SOF_hip dataset.

## Configuration

The following environment variables cab ne used to customize the scripts:
  - `SOFIA_DATA_DIR` path to the directory that contains the training and validation data.
  - `SOFIA_MODEL_DIR` path to the directory to which training checkpoints should be written.
  - `SOFIA_GPUS` GPUs to use for training. Default to `all`. To select e.g. GPU 0 and GPU 3 set the variable as `export SOFIA_GPUS='"device=0,3"'`.
  - `SOFIA_TP_PORT` Port used by tensorboard, defaults to `8080`.
  - `SOFIA_NAME` Name of the docker container. 
  - `SOFIA_DOCKER_IMAGE` If you built a custom docker image, you must set this variable to the image name.

## Training

The environment variable `SOFIA_DATA_DIR` should point to the directory where the training and validation data is located.
The data directory must contain the two files `SOF-ObjectDetection-train.tfrecord` and
`SOF-ObjectDetection-validation.tfrecord`.

To start the training using the docker image run
```shell
./train-docker.sh
```

## Evaluation

The evaluation script runs the evaluation on each checkpoint written by the training script.
The evaluation does not use GPUs. It can and should therefore be run in parallel to the training script.

```shell
./eval-docker.sh
```

## Monitor

To monitor the training performance run
```shell
./tb-docker.sh
```
and go to [http://localhost:8080](http://localhost:8080).


## Build Docker Image

You can build your custom docker image by running
```shell
./build-docker.sh
```
Ensure to set `SOFIA_DOCKER_IMAGE`.