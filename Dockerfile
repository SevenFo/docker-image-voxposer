FROM ubuntu:20.04

RUN sed -i 's/archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list &&\
    apt-get update && \
	export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        wget vim gcc bash tar xz-utils git \
        libx11-6 libxcb1 libxau6 libgl1-mesa-dev \
        xvfb dbus-x11 x11-utils libxkbcommon-x11-0 \
        libavcodec-dev libavformat-dev libswscale-dev \
        python3.9-full python3.9-dev build-essential libssl-dev libffi-dev python3-pip libraw1394-11 libmpfr6 \
        libusb-1.0-0 \
        && \
    apt-get autoclean -y && apt-get autoremove -y && apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    ln -s /bin/python3.9 /bin/python

# set up python environment
# set pip mirror to Tsinghua University and upgrade pip
RUN python -m pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple && \
    python -m pip install --upgrade pip
# install torch environment
RUN python -m pip install torch torchvision torchaudio
# install other packages
RUN python -m pip install gdown jupyter openai plotly transforms3d open3d pyzmq cbor accelerate opencv-python-headless progressbar2 gdown gitpython git+https://github.com/cheind/py-thin-plate-spline hickle tensorboard transformers
# install PyRep and RLBench
RUN git clone https://github.com/stepjam/PyRep.git --depth 1 && cd PyRep && \
    python -m pip install -r requirements.txt && \
    python -m pip install . && \
    cd .. && rm -rf PyRep
RUN git clone https://github.com/stepjam/RLBench.git --depth 1 && cd RLBench && \
    python -m pip install -r requirements.txt && \
    python -m pip install . && \
    cd .. && rm -rf RLBench
RUN rm -rf /root/.cache/pip

RUN mkdir -p /shared /opt /root/workspace /models

# download CoppeliaSim and extract it to /opt

COPY download/CoppeliaSim_Edu_V4_1_0_Ubuntu20_04.tar.xz /opt
RUN tar -xf /opt/CoppeliaSim_Edu_V4_1_0_Ubuntu20_04.tar.xz -C /opt && \
    rm /opt/CoppeliaSim_Edu_V4_1_0_Ubuntu20_04.tar.xz

ENV COPPELIASIM_ROOT=/opt/CoppeliaSim_Edu_V4_1_0_Ubuntu20_04
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$COPPELIASIM_ROOT
ENV QT_QPA_PLATFORM_PLUGIN_PATH=$COPPELIASIM_ROOT
ENV PATH=$COPPELIASIM_ROOT:$PATH

# copy the huggingface models repo
COPY download/models.tar.gz /models
RUN tar -xvf /models/models.tar.gz -C /models && \
    rm /models/models.tar.gz

WORKDIR /root/workspace

# RUN echo '#!/bin/bash\ncd $COPPELIASIM_ROOT_DIR\n/usr/bin/xvfb-run --server-args "-ac -screen 0, 1024x1024x24" coppeliaSim "$@"' > /entrypoint && chmod a+x /entrypoint

# Use following instead to open an application window via an X server:
# RUN echo '#!/bin/bash\ncd $COPPELIASIM_ROOT_DIR\n./coppeliaSim "$@"' > /entrypoint && chmod a+x /entrypoint

EXPOSE 23000-23500 80
# ENTRYPOINT ["/entrypoint"]
CMD [ "/bin/bash" ]