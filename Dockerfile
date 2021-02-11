FROM nvidia/cuda:11.0-cudnn8-devel-ubuntu18.04

ENV DEBIAN_FRONTEND noninteractive
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG TARGET_UID=1001
ARG TARGET_GID=1001

# Setup the default user.
ENV TARGET_UID=$TARGET_UID
ENV TARGET_GID=$TARGET_GID
RUN groupadd -g ${TARGET_GID} devel
RUN useradd -rm -d /home/devel -s /bin/bash -g devel -G sudo -u ${TARGET_UID} devel
RUN echo 'devel:devel' | chpasswd
USER devel
WORKDIR /home/devel

USER root
RUN apt-get update && \
    apt-get install -y vim sudo \
    python-opencv \
    protobuf-compiler \
    git \
    less \
    curl \
    python3-distutils \
    python3-apt \
    python3-dev \
    wget

# Install and configure conda
RUN curl -fsSL -v -o ~/miniconda.sh -O  https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh  && \
  chmod +x ~/miniconda.sh && \
  ~/miniconda.sh -b -p /opt/conda && \
  rm ~/miniconda.sh && \
  /opt/conda/bin/conda install -y python=${PYTHON_VERSION} conda-build pyyaml numpy ipython&& \
  /opt/conda/bin/conda clean -ya

USER devel
ENV PATH=/opt/conda/bin:/home/devel/.local/bin:${PATH}
RUN conda create -n myenv
SHELL ["conda", "run", "-n", "myenv", "/bin/bash", "-c"]
RUN conda init bash

# Install dependencies
COPY requirements.txt /home/devel/
RUN pip install -U pip
RUN pip install -r requirements.txt
RUN pip uninstall -y tensorbard tb-nightly
RUN pip install tensorboard

# Install tensorflow object detection
RUN git clone --depth=1 https://github.com/tensorflow/models.git
COPY install_dependencies.sh /home/devel/
RUN cd /home/devel && ./install_dependencies.sh

# Download pre-trained model checkoint
RUN mkdir -p /home/devel/checkpoint && \
  cd /home/devel/checkpoint && \
  wget -c http://download.tensorflow.org/models/object_detection/tf2/20200711/centernet_resnet50_v2_512x512_kpts_coco17_tpu-8.tar.gz -O - | tar -xz

# Copy scripts
COPY train.sh /home/devel/
COPY eval.sh /home/devel/
COPY tb.sh /home/devel/

# Copy piipeline configuration
COPY model/pipeline.config /home/devel/

CMD ["/bin/bash"]
