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
RUN apt-get update && apt-get install -y openssh-server vim sudo python-opencv protobuf-compiler git less curl python3-distutils python3-apt python3-dev wget

# Configure SSHD.
# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
RUN mkdir /run/sshd
RUN bash -c 'install -m755 <(printf "#!/bin/sh\nexit 0") /usr/sbin/policy-rc.d'
RUN ex +'%s/^#\zeListenAddress/\1/g' -scwq /etc/ssh/sshd_config
RUN ex +'%s/^#\zeHostKey .*ssh_host_.*_key/\1/g' -scwq /etc/ssh/sshd_config
RUN RUNLEVEL=1 dpkg-reconfigure openssh-server
RUN ssh-keygen -A -v
RUN update-rc.d ssh defaults

# Configure sudo.¬
RUN ex +"%s/^%sudo.*$/%sudo ALL=(ALL:ALL) NOPASSWD:ALL/g" -scwq! /etc/sudoers

USER devel
RUN mkdir -p /home/devel/.ssh
COPY authorized_keys /home/devel/.ssh/
COPY requirements.txt /home/devel/

USER root
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

RUN pip install -U pip
RUN pip install -r requirements.txt

RUN git clone https://github.com/tensorflow/models.git

COPY install_dependencies.sh /home/devel/

RUN cd /home/devel && ./install_dependencies.sh

RUN mkdir -p /home/devel/checkpoint && \
  cd /home/devel/checkpoint && \
  wget -c http://download.tensorflow.org/models/object_detection/tf2/20200711/centernet_resnet50_v2_512x512_kpts_coco17_tpu-8.tar.gz -O - | tar -xz

COPY train.sh /home/devel/
COPY eval.sh /home/devel/

EXPOSE 22
CMD ["/usr/bin/sudo", "/usr/sbin/sshd", "-D", "-o", "ListenAddress=0.0.0.0"]
